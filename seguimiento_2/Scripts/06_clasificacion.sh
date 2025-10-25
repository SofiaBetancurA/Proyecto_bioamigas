#!/usr/bin/env bash 
set -euo pipefail


DB_DIR="clasificacion/kraken2_db"                                                    # Carpeta de la base de datos
DB_URL="https://genome-idx.s3.amazonaws.com/kraken/minikraken2_v2_8GB_201904.tgz"
UNMAPPED="mapeo/unmapped_reads"                                                                     # Carpeta con los FASTQ no mapeados
OUT="clasificacion/kraken_results"                                                                 # Carpeta de salida
THREADS=2                                                                            # Número de núcleos
SAMPLES=("evol1" "evol2")                                                            # Muestras a analizar

# 1. Descargar la base de datos
echo ">> Descargando base de datos MiniKraken..."
mkdir -p "$DB_DIR"
cd "$DB_DIR"

wget -O minikraken2_v2_8GB_201904.tgz "$DB_URL"
tar -xvzf minikraken2_v2_8GB_201904.tgz --strip-components=1 -C .
rm minikraken2_v2_8GB_201904.tgz

cd ../../
echo "[OK] Base de datos descargada y descomprimida correctamente."


KRONA_TAX_DIR="$HOME/micromamba/envs/env/opt/krona/taxonomy"
KRONA_UPDATE="$HOME/micromamba/envs/env/opt/krona/updateTaxonomy.sh"

if [ -f "$KRONA_UPDATE" ]; then
  echo ">> Verificando taxonomía de Krona..."
  bash "$KRONA_UPDATE" || echo "[Aviso] No se pudo actualizar la taxonomía de Krona, usando la existente."
else
  echo "[Aviso] No se encontró el script updateTaxonomy.sh en el entorno Krona."
fi


mkdir -p "$OUT"

# 2. Procesamiento de las muestras 
for sample in "${SAMPLES[@]}"; do
  echo ">> Clasificando $sample con Kraken2..."

  kraken2 \
    --db "$DB_DIR" \
    --memory-mapping \
    --threads "$THREADS" \
    --paired \
    --report "$OUT/${sample}.kraken2.report" \
    --output "$OUT/${sample}.kraken2.out" \
    "$UNMAPPED/${sample}_unmapped_R1.fastq" \
    "$UNMAPPED/${sample}_unmapped_R2.fastq"

  echo "[OK] $sample clasificado correctamente."

  # 3. Genera Krona desde resultados de Kraken2 
  echo ">> Generando gráfico Krona desde Kraken2..."
  awk '{print $2"\t"$3}' "$OUT/${sample}.kraken2.out" > "$OUT/${sample}.krona_input"
  ktImportTaxonomy "$OUT/${sample}.krona_input" -o "$OUT/${sample}_kraken_krona.html"
  rm "$OUT/${sample}.krona_input"
  echo "[OK] Gráfico Krona de Kraken2 generado: $OUT/${sample}_kraken_krona.html"

  # 4. Cálcula las abundancias con Bracken 
  echo ">> Estimando abundancia con Bracken para $sample..."
  bracken \
    -d "$DB_DIR" \
    -i "$OUT/${sample}.kraken2.report" \
    -o "$OUT/${sample}.bracken.txt" \
    -r 150 \
    -l S

  echo "[OK] Abundancia estimada: $OUT/${sample}.bracken.txt"

  # 5. Genera Krona desde resultados de Bracken 
  echo ">> Generando gráfico interactivo con Krona (Bracken)..."
  ktImportTaxonomy "$OUT/${sample}.bracken.txt" -o "$OUT/${sample}_bracken_krona.html"
  echo "[OK] Gráfico Krona de Bracken generado: $OUT/${sample}_bracken_krona.html"
done

echo "[FINALIZADO] Todas las muestras procesadas. Resultados en: $OUT/"
echo "   - *_kraken_krona.html → visualización directa de Kraken2"
echo "   - *_bracken_krona.html → abundancias ajustadas con Bracken"