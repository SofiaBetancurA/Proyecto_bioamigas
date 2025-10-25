#!/usr/bin/env bash
set -euo pipefail

# Parámetros y rutas
REF="ensamblaje/trimmed/scaffolds.fasta"   # Genoma ensamblado del ancestro
OUT_DIR="anotacion_prokka"                 # Carpeta de salida para la anotación
PREFIX="ancestro"                          # Prefijo para los archivos de salida
THREADS=4                                  # Núcleos a usar del computador
LOCUS_TAG="ANC"                            # Etiqueta de locus para los genes
SPECIES="Escherichia coli"                 # Especie 

mkdir -p "$OUT_DIR"

echo ">>> ANOTACIÓN DEL GENOMA CON PROKKA"
echo "Referencia: $REF"
echo "Salida: $OUT_DIR"

# 1. Ejecutar PROKKA 
prokka \
  --outdir "$OUT_DIR" \
  --prefix "$PREFIX" \
  --locustag "$LOCUS_TAG" \
  --genus Escherichia \
  --species coli \
  --strain ancestral \
  --usegenus \
  --cpus "$THREADS" \
  --force \
  "$REF"

# --outdir      → carpeta de salida
# --prefix      → prefijo para los archivos de salida (ej: ancestro.gff, ancestro.faa...)
# --locustag    → etiqueta para los genes, útil en anotaciones
# --genus, --species, --strain → información biológica de la muestra
# --usegenus    → usa base de datos específica del género
# --cpus        → núcleos para acelerar el proceso
# --force       → sobreescribe si ya existe la carpeta de salida

echo ">>> ANOTACIÓN COMPLETADA"
echo "Archivos generados en: $OUT_DIR"
echo "Principales archivos:"
echo "  - ancestro.gff   (anotaciones completas)"
echo "  - ancestro.gbk   (formato GenBank)"
echo "  - ancestro.faa   (proteínas predichas)"
echo "  - ancestro.ffn   (genes en nucleótidos)"
echo "  - ancestro.tbl   (tabla de anotaciones)"