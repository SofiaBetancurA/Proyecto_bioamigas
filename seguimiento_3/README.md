# README ENTREGA 3 PROYECTO BIOINFORMÁTICA

---

## 🧬 DIAGRAMA DE FLUJO DEL PROCESO

<img width="1024" height="768" alt="Flujo de trabajo entrega 2" src="https://github.com/user-attachments/assets/1cb605db-d411-468e-a5b2-ab86be35948a" />

---
**PASO 1:** Desde su terminal, en el directorio **home**, verifique que se encuentra en la carpeta del proyecto.  
Si no se encuentra en ella, ábrala con el siguiente comando:

```bash
cd proyecto
```
**PASO 2:** Usted deberá **actualizar el entorno** que fue creado para la Entrega 2.  
Para esto, añada los siguientes paquetes al archivo **`env.yaml`**:

```yaml
- seqkit
- aliview
- mafft
- iqtree
```

Luego, desde su terminal (asegurándose de estar dentro de la carpeta **proyecto**), ejecute el siguiente comando para actualizar el entorno:

```bash
conda env update -f env.yaml
```

Una vez se haya actualizado el entorno, actívelo con el siguiente comando:

```bash
conda activate env
```

**PASO 3:** Dentro de la carpeta **proyecto**, cree una nueva carpeta llamada **proyecto_filogenetica** con el siguiente comando:

```bash
mkdir proyecto_filogenetica
```
**PASO 4:** Diríjase a la carpeta recién creada con:

```bash
cd proyecto_filogenetica
```

---

##  PUESTA A PUNTO DEL ARCHIVO `.FASTA` QUE INGRESARÁ EN MAFFT

Diríjase al siguiente enlace:  
🔗 [https://data.orthodb.org/current/fasta?id=9806486at2&seqtype=cds&species=](https://data.orthodb.org/current/fasta?id=9806486at2&seqtype=cds&species=)

Si su computador es **Windows**, luego de abrir el enlace presione **Ctrl + A** para seleccionar todo.  
Si usa **MacOS**, presione **Command + A**.

Desde **Visual Studio Code**, cree un archivo llamado **`ortologos.fasta`** y pegue el contenido copiado (Ctrl + C o Command + C).

**LIMPIEZA DEL ARCHIVO `.FASTA`**

Ahora, es importante realizar una limpieza para:

- Eliminar duplicados  
- Tomar 200 secuencias de manera aleatoria  
- Cambiar el ID de las secuencias

Ejecute desde su terminal el siguiente comando:

```bash
awk '/^>/{prefix=$0; sub(/:.*/, "", prefix); if(!seen[prefix]++){print $0; getline seq; print seq}}' ortologos.fasta | awk 'BEGIN{RS=">"; ORS=""} NR>1{print ">"$0}' | seqkit sample -n 200 > filtrado_downsampled_200.fasta
```
**LIMPIEZA DE NOMBRES (SIMPLIFICAR LOS IDs)**

Para que en el árbol aparezca el formato **organismo + pub_gen_id**, ejecute:

```bash
awk '/^>/{if(match($0, /"organism_name":"([^"]+)".*"pub_gene_id":"([^"]+)"/, a)){gsub(/ /, "", a[1]); print ">"a[1]""a[2]} else {print $0}} !/^>/' filtrado_downsampled_200.fasta > filtrado_downsampled_200_clean.fasta
```

**VERIFICACIÓN DE SECUENCIAS SELECCIONADAS**

Para comprobar que se seleccionaron exactamente **200 secuencias**, ejecute:

```bash
grep -c "^>" filtrado_downsampled_200_clean.fasta
```

La salida esperada debe ser:

```
200
```
**FASTA final con la query sequence y el outgroup**

Manualmente puede abrir el archivo filtrado_downsampled_200_clean.fasta e insertar la secuencia del GEN que descargó desde el NCBI y para la secuencia del outgroup (Gen gyrA para la archea _Haloferax volcanii_ DS2) se deben ejecutar otros comandos. En caso de que no las tenga, las puede encontrar en:

🔗Query: https://www.ncbi.nlm.nih.gov/gene/946614

🔗Outgroup: https://www.ncbi.nlm.nih.gov/gene/8926485 

**Nota:** para el outgroup descargue las secuencia y guardela en un archivo que nombrará gen_archea.fna.

Después ejecute el siguiente comando: 
```bash
cat filtrado_downsampled_200_clean.fasta gene_archea.fna >> concatenado_final2.fasta
```
---
## MAFFT
Asegurese de tener el entorno env activado, después, ejecute el siguiente comando:
```bash
mafft --auto concatenado_final2.fasta > alineamiento_concatenado_final2.fasta
```
---
## IQTREE
Asegurese de tener el entorno env activado, después, ejecute el siguiente comando:
```bash
iqtree -s alineamiento_concatenado_final2.fasta  -m MFP -alrt 1000 -B 1000
```
**Nota:** En esta parte del proceso, es de especial interés el archivo alineamiento_concatenado_final2.fasta.log porque presenta la información utilizada para el modelo de construcción del árbol.

