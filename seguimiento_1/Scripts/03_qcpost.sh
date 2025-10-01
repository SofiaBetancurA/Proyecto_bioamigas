#!/usr/bin/env bash
set -euo pipefail
IN="data/trimmed"
OUT="qc/post"
mkdir -p "$OUT"

fastqc -o "$OUT" -t 4 "$IN"/*.fastq.gz  #Corre FastQC para verificar la calidad después del trimming 
multiqc -o "$OUT" "$OUT" "qc/fastp" 2>/dev/null || true  #Corre MultiQC para generar el reporte único

echo "[OK] QC post-trimming en $OUT"