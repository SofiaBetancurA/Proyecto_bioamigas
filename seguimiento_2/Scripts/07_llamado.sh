#!/usr/bin/env bash
set -euo pipefail

# Parámetros y rutas
REF="ensamblaje/trimmed/scaffolds.fasta"   # Genoma ensamblado del ancestro
BAM_DIR="mapeo"                            # Carpeta con los BAM filtrados
OUT_DIR="variantes_samtools"               # Carpeta de salida
THREADS=4                                  # Núcleos a usar
MINQUAL=28                                 # Calidad mínima de variante
MINDP=10                                   # Profundidad mínima

mkdir -p "$OUT_DIR"                        # Crea la carpeta para guardar los resultados que son variantes_samtools


echo ">>> LLAMADO DE VARIANTES (SAMTOOLS + BCFTOOLS)"
echo "Referencia: $REF"
echo "Archivos BAM: $BAM_DIR/*.filtered.bam"
echo

# 1. Crear lista de BAMs 
BAMS=$(ls $BAM_DIR/*.filtered.bam)
echo ">> BAMs detectados:"
echo "$BAMS"
echo

# 2. Generar archivo mpileup 
# Este comando examina todos los BAM y construye el perfil de variantes
echo ">> Ejecutando samtools mpileup..."
bcftools mpileup -f "$REF" -O b -o "$OUT_DIR/cohort.bcf" $BAMS

# -f   : archivo de referencia
# -O b : salida en BCF binario
# -o   : nombre dle archivo de salida 


# 3. Llamar variantes 

echo ">> Llamando variantes con bcftools call..."
bcftools call -mv -Ov -o "$OUT_DIR/cohort.raw.vcf" "$OUT_DIR/cohort.bcf"

# -m : modelo multialélico
# -v : solo variantes (descarta posiciones iguales a la referencia)
# -Ov : salida en formato VCF texto

# 4. Filtrado de variantes 
echo ">> Filtrando variantes (QUAL >= $MINQUAL, DP >= $MINDP)..."
bcftools filter -s LOWQUAL -e "QUAL<${MINQUAL} || DP<${MINDP}" \
  "$OUT_DIR/cohort.raw.vcf" \
   -Ov \
   -o \
   "$OUT_DIR/cohort.filtered.vcf"

# 5. Generar tabla resumen 
echo ">> Creando tabla resumen de variantes..."
bcftools query -f '%CHROM\t%POS\t%REF\t%ALT\t%QUAL\t%INFO/DP\t[%GT\t]\n' \
  "$OUT_DIR/cohort.filtered.vcf" > "$OUT_DIR/variants_table.tsv"

# 6. Estadísticas básicas 
echo ">> Calculando estadísticas de variantes..."
bcftools stats "$OUT_DIR/cohort.filtered.vcf" > "$OUT_DIR/cohort.filtered.stats.txt"

# 7. Finalización
echo ">>> Llamado de variantes completado."
echo "Archivos generados en la carpeta: $OUT_DIR"
echo "  - cohort.bcf                (archivo intermedio de samtools)"
echo "  - cohort.raw.vcf            (sin filtrar)"
echo "  - cohort.filtered.vcf       (filtrado final)"
echo "  - variants_table.tsv        (tabla resumen para informe)"
echo "  - cohort.filtered.stats.txt (estadísticas globales)"
