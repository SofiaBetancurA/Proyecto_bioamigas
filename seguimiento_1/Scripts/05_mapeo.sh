#!/usr/bin/env bash
set -euo pipefail

REF="ensamblaje/trimmed/scaffolds.fasta"   # Referencia ensamblada del ancestro
IN="data/trimmed"                          # Lecturas depuradas de los evolucionados
OUT="mapeo"                                # Carpeta de salida del mapeo
THREADS=4                                  # Núcleos a usar

mkdir -p "$OUT"

# 1. Indexar la referencia
echo ">> Indexando referencia con BWA..."
bwa index "$REF"

# 2. Mapeo y análisis
for sample in evol1 evol2; do
  echo ">> Procesando muestra: $sample"

  # Alineamiento inicial -> ordenar por nombre
  bwa mem -t "$THREADS" "$REF" \
    "$IN/${sample}_R1.trimmed.fastq.gz" \
    "$IN/${sample}_R2.trimmed.fastq.gz" \
    | samtools sort -n -o "$OUT/${sample}.name_sorted.bam"

  # Añadir tags de parejas (fixmate)
  samtools fixmate -m "$OUT/${sample}.name_sorted.bam" "$OUT/${sample}.fixmate.bam"

  # Ordenar por posición genómica
  samtools sort -o "$OUT/${sample}.pos_sorted.bam" "$OUT/${sample}.fixmate.bam"

  # Marcar y eliminar duplicados
  samtools markdup -r "$OUT/${sample}.pos_sorted.bam" "$OUT/${sample}.dedup.bam"

  # Filtrar por calidad de mapeo (ejemplo: MAPQ >= 28)
  samtools view -b -q 28 "$OUT/${sample}.dedup.bam" > "$OUT/${sample}.filtered.bam"

  # Indexar BAM final
  samtools index "$OUT/${sample}.filtered.bam"

  # Estadísticas con samtools
  samtools flagstat "$OUT/${sample}.filtered.bam" > "$OUT/${sample}.flagstat.txt"
  samtools stats "$OUT/${sample}.filtered.bam" > "$OUT/${sample}.stats.txt"

  # QC con Qualimap
  qualimap bamqc -bam "$OUT/${sample}.filtered.bam" -outdir "$OUT/qualimap_${sample}"

  # Extraer reads NO mapeados (-f 4) y convertir a FASTQ
  samtools view -f 4 -b "$OUT/${sample}.dedup.bam" > "$OUT/${sample}.unmapped.bam"
  bedtools bamtofastq -i "$OUT/${sample}.unmapped.bam" \
    -fq "$OUT/${sample}_unmapped_R1.fastq" \
    -fq2 "$OUT/${sample}_unmapped_R2.fastq"

  echo "[OK] Procesamiento de $sample completado."
done

echo "[OK] Mapeo y procesamiento finalizados. Resultados en $OUT/"