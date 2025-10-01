<p align="center">
  <h1>README ENTREGA 1 PROYECTO BIOINFORMÁTICA</h1>
</p>

![Diagrama de flujo]("C:\Users\andre\Downloads\Beige Neutral Flowchart Graph Template.png")


**Paso 1.**  Desde su terminal, ubicado en el directorio home, cree una carpeta que se llame proyecto usando el siguiente código:
<p align="center">
  <code>mkdir proyecto</code>
</p>


**Paso 2.** Abra la carpeta proyecto y dentro de esta cree una carpeta llamada scripts, la cual usara para almacenar los scripts necesarios para ejecutar el proyecto. Use los siguientes códigos:
<p align="center">
  <code>cd proyecto</code><br>
  <code>mkdir scripts</code>
</p>

**Paso 3.**  Guarde en la carpeta scripts cada uno de los scripts adjuntados (00_descargas.sh, 01_qcpre.sh, 02_trimmed.sh, 03_qcpost.sh, 04_ensamblaje.sh, 05_mapeo.sh) y otórgueles a los scripts el permiso para que sean ejecutables con el siguiente comando:
<p align="center">
  <code>chmod +x ./scripts/*.sh</code>
</p>

**Nota:**  asegúrese de otorgar los permisos desde la carpeta proyecto.

**Paso 4.** Crear y activar el entorno env.
Descargue el archivo environment.yml en la carpeta proyecto, el cual contiene todas las herramientas necesarias para ejecutar los scripts como fastqc, multiqc, samtools, bwa, qualimap, quast, spades, etc. Luego ejecute el siguiente comando que creara el entorno env. 
 <p align="center">
   <code>conda env create -f environment.yml</code>
</p>

Y active el entorno con: 
<p align="center">
  <code>conda activate env</code>
</p>

**Paso 5.** Ahora en la carpeta proyecto ejecute cada uno de los scripts con el siguiente comando, el orden en que debe de ejecutar cada uno de los scripts es el siguiente:
          1.	00_descargas.sh
          2.	01_qcpre.sh
          3.	02_trimmed.sh
          4.	03_qcpost.sh
          5.	04_ensamblaje.sh
          6.	05_mapeo.sh
El comando para ejecutar cada script:
<p align="center">
  <code>./scripts/nombreScript.sh</code>
</p>

**Nota:**  en el comando reemplace “nombreScript” por cada uno de los nombres de los scripts y verifique que el entorno env este activado.

**Interpretación en qualimap**

Para conocer el numero de reads que sobrevivieron al filtrado de calidad luego del hacer la depuración de datos crudos se puede emplear el siguiente comando:
<p align="center">
  <code>zcat data/trimmed/evol2_R1.trimmed.fastq.gz | wc -l | awk '{print $1/4}'</code>
</p>

donde Zcat es el comando encargado de descomprimir los archivos .gz  almacenados en la carpeta trimmed que esta dentro de la carpeta data para que luego con el comando wc -l cuente las líneas descomprimidas y con el comando awk '{print $1/4}' se toma como entrada la salida numérica del comando anterior y con $1 selecciona el conteo de líneas que hizo y luego lo divide entre 4. Finalmente, imprime en pantalla el resultado de esa división, que representa el numero de reads en archivo fastq, dado que cada read se conforma por 4 lineas.
Este comando me dará como resultado el numero de reads que contiene por ejemplo en este caso el archivo evol2_R1.trimmed.fastq.gz   y al cambiar en el código por el archivo evol2_R2.trimmed.fastq.gz  obtendré el número de reads correspondiente para este y la suma de ambos archivos corresponde al numero de reads que sobrevivieron al filtrado después de aplicar la calidad y esto servirá como punto de referencia para comparar con el numero final de reads consideradas para el mapeo.

