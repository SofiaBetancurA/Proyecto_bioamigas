#!/usr/bin/env bash
set -euo pipefail
IN="data/fastq" #Variable con la carpeta de entrada donde estan los archivos .fastq.gz
OUT="qc/pre"    #Carpeta de salida, donde se guadan los reportes QC


fastqc -o "$OUT" -t 4 "$IN"/*.fastq.gz #Corre FastQC sobre los archivos fastaq.gz y guarda los reportes en la carpeta
                                       #El 4 es para indicar que usa 4 hilos de nucleos del procesador
multiqc -o "$OUT" "$OUT"               #Usa MultiQC para buscar los resultados en qc/pre y generar el reporte único

echo "[OK] QC inicial en $OUT"