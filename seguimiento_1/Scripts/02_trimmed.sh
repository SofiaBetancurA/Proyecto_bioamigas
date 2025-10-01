#!/usr/bin/env bash
set -euo pipefail

IN="data/fastq"
OUTD="data/trimmed" #Carpeta de salida del trimming, donde se guardan los FastQ cortados
QCD="qc/fastp"      #Carpeta donde se guardan los reportes de calidad del trimming

mkdir -p "$OUTD" "$QCD"

# Illumina paired-end (anc, evol1, evol2)
#Se toman los fatos crudos de las 3 muestras y se hace el trimming y limpieza con fastp
for sample in anc evol1 evol2; do
  fastp \
    -i "$IN/${sample}_R1.fastq.gz" \
    -I "$IN/${sample}_R2.fastq.gz" \
    -o "$OUTD/${sample}_R1.trimmed.fastq.gz" \
    -O "$OUTD/${sample}_R2.trimmed.fastq.gz" \
    --detect_adapter_for_pe \
    --trim_front1 15 \
    --trim_front2 15 \
    --trim_tail1 5 \
    --trim_tail2 5 \
    --qualified_quality_phred 28 \
    --length_required 50 \
    --cut_front --cut_tail --cut_mean_quality 20 \
    --thread 4 \
    --html "$QCD/fastp_${sample}.html" \
    --json "$QCD/fastp_${sample}.json"
done


echo "[OK] fastp completado. Salidas en $OUTD"