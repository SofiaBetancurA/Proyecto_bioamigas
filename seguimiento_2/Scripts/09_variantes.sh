#!/bin/bash
set -euo pipefail

# ==== 1. Entradas ====
# Archivo VCF con las variantes filtradas
VCF_INPUT="variantes_samtools/cohort.filtered.vcf"

# Nombre del genoma de referencia (como se registrará en SnpEff)
GENOME="ancestro"

# Ruta del genoma ensamblado (primera entrega)
GENOME_FASTA="ensamblaje/trimmed/scaffolds.fasta"

# Archivo de anotación de Prokka (segunda entrega)
PROKKA_GFF="anotacion_prokka/ancestro.gff"

# Carpeta de salida para los resultados
OUTDIR="resultados_variantes_interes"

# Ruta donde está instalado SnpEff (si está en el PATH, puede dejarse vacío)
SNPEFF_PATH=""

# ==== 2. Comprobaciones previas ====
echo "Verificando dependencias..."

# Verificar que existan los archivos necesarios
for file in "$VCF_INPUT" "$GENOME_FASTA" "$PROKKA_GFF"; do
  if [ ! -f "$file" ]; then
    echo "ERROR: No se encontró el archivo requerido: $file"
    exit 1
  fi
done

# Verificar que Java esté disponible
if ! command -v java &> /dev/null; then
  echo "ERROR: Java no está instalado o no está en el PATH."
  exit 1
fi

# Detectar SnpEff automáticamente
if [ -z "$SNPEFF_PATH" ]; then
  if command -v snpEff &> /dev/null; then
    SNPEFF_CMD="snpEff"
  elif [ -f "./snpEff.jar" ]; then
    SNPEFF_CMD="java -jar ./snpEff.jar"
  else
    echo "ERROR: No se encontró snpEff. Coloca snpEff.jar en el directorio actual o agrégalo al PATH."
    exit 1
  fi
else
  SNPEFF_CMD="java -jar $SNPEFF_PATH/snpEff.jar"
fi

# ==== 3. Crear carpeta de resultados ====
mkdir -p "$OUTDIR"

# ==== 4. Verificar o construir base de datos SnpEff ====
if [ -d "snpEff/data/$GENOME" ]; then
  echo "Base de datos $GENOME encontrada. Continuando..."
else
  echo "No se encontró la base de datos $GENOME. Construyéndola..."

  mkdir -p snpEff/data/$GENOME

  # Copiar archivos del genoma y anotación
  cp "$GENOME_FASTA" snpEff/data/$GENOME/sequences.fa
  cp "$PROKKA_GFF" snpEff/data/$GENOME/genes.gff

  # Construir base de datos con el archivo .gff
  $SNPEFF_CMD build -gff3 -v $GENOME

  if [ $? -ne 0 ]; then
    echo "ERROR: Falló la construcción de la base de datos SnpEff para $GENOME."
    exit 1
  fi
fi

# ==== 5. Ejecutar SnpEff ====
echo "Ejecutando SnpEff sobre el archivo VCF..."
$SNPEFF_CMD $GENOME $VCF_INPUT > $OUTDIR/variantes_snpeff_annot.vcf \
  -csvStats $OUTDIR/snpeff_estadisticas.csv \
  -s $OUTDIR/snpeff_reporte.html

# ==== 6. Filtrar variantes con impacto alto o moderado ====
echo "Extrayendo variantes con impacto HIGH o MODERATE..."
grep -E "HIGH|MODERATE" $OUTDIR/variantes_snpeff_annot.vcf > $OUTDIR/variantes_interes.vcf

# ==== 7. Generar resumen de genes afectados ====
echo "Generando resumen de genes afectados..."
grep -E "ANN=" $OUTDIR/variantes_interes.vcf | \
  cut -f8 | grep -o "Gene_Name=[^;]*" | cut -d"=" -f2 | sort | uniq -c | sort -nr \
  > $OUTDIR/resumen_genes.txt

# ==== 8. Mensaje final ====
echo "Análisis completado. Resultados guardados en $OUTDIR"
echo "Archivos generados:"
echo " - variantes_snpeff_annot.vcf : Variantes anotadas con efectos"
echo " - snpeff_reporte.html : Reporte visual"
echo " - variantes_interes.vcf : Variantes candidatas (HIGH/MODERATE)"
echo " - resumen_genes.txt : Genes más afectados"










