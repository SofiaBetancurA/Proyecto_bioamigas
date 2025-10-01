#!/usr/bin/env bash
set -euo pipefail 
#-e: el script se detiene si un comando falla
#-u: el scrip falla si se una una variable no definida
#-o pipefail: si cualquiera de los comandos falla, todo el pipeline falla 
# Crear estructura base

mkdir -p data/{fastq,trimmed} qc/{pre,post,fastp} mapeo ensamblaje

# Entrando a la carpeta para desacrgar datos 
DIR="data/fastq" #Variable de entorno que la ruta de las carpetas data/fastq
wget -O "${DIR}/data.tar.gz" https://osf.io/2jc4a/download

# Descomprimir DIR (dentro de fastq)
tar -xzf "${DIR}/data.tar.gz" -C "${DIR}"

# Borrar el .tar.gz para no duplicar
rm "${DIR}/data.tar.gz"
mv "${DIR}/data/"* "${DIR}/"
rmdir "${DIR}/data"

echo "[OK] Setup completo: datos en datos/fastq/"