#!/usr/bin/env bash
set -euo pipefail


RAW="data/fastq"    #Carpeta con fastq crudos 
TRIM="data/trimmed" #Carpeta con fastq recortados
OUT="ensamblaje"    #Carpeta de salida para el ensamblaje
QUAST="$OUT/quast"  #Carpeta dentro de ensamblaje donde se guarda los reportes QUAST
THREADS=4           #4 hilos de nucleos del procesador
   

# Ensamblajes con SPAdes
#Ensabla el genoma usando las lecturas crudas y las lecturas cortadas 
#Genera los scaffolds
mkdir -p "$OUT/raw" "$OUT/trimmed"

echo ">> Ensamblaje ancestro con reads CRUDOS..."
spades.py \
  -1 "$RAW/anc_R1.fastq.gz" \
  -2 "$RAW/anc_R2.fastq.gz" \
  -o "$OUT/raw" \
  -t "$THREADS"

echo ">> Ensamblaje ancestro con reads TRIMMED..."
spades.py \
  -1 "$TRIM/anc_R1.trimmed.fastq.gz" \
  -2 "$TRIM/anc_R2.trimmed.fastq.gz" \
  -o "$OUT/trimmed" \
  -t "$THREADS"

echo "[OK] Ensamblajes completados."
echo "  - Ensamblaje RAW     : $OUT/raw/scaffolds.fasta"
echo "  - Ensamblaje TRIMMED : $OUT/trimmed/scaffolds.fasta"


# Evaluación con QUAST
#Compara ambos ensamblajes con QUAST

mkdir -p "$QUAST"

echo ">> Evaluando ensamblajes con QUAST..."
quast.py \
  -o "$QUAST" \
  -t "$THREADS" \
  -l "Raw,Trimmed" \
  "$OUT/raw/scaffolds.fasta" "$OUT/trimmed/scaffolds.fasta"

echo "[OK] Reporte de QUAST generado en $QUAST"