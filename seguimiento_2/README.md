<p align="center">
  <h1>README ENTREGA 2 PROYECTO BIOINFORMÁTICA</h1>
</p>

**DIAGRAMA DE FLUJO DEL PROCESO**
![Diagrama de flujo](https://github.com/SofiaBetancurA/Proyecto_bioamigas/blob/main/seguimiento_2/Flujo%20de%20trabajo%20entrega%202.png)

**Paso 1.**  Desde su terminal, en el directorio home, verifique que se encuentre en la carpeta proyecto si no se encuentra en ella ábrala con el siguiente comando:
<p align="center">
  <code>cd proyecto</code>
</p>

**Paso 2.**  Abra la carpeta scripts que se encuentra dentro de la carpeta proyecto y guarde cada uno de los scripts adjuntados en la carpeta del repositorio denominada Scripts (06_clasificacion.sh, 07_llamado.sh, 08_anotacion.sh, 09_variantes.sh) y otórgueles a los scripts el permiso para que sean ejecutables con el siguiente comando:
<p align="center">
  <code>chmod +x ./scripts/*.sh</code>
</p>

**Nota:** asegúrese de otorgar los permisos desde la carpeta proyecto.

**Paso 3.** Usted deberá actualizar el entorno que fue creado para la entrega 1, para esto debe añadir los siguientes paquetes al archivo env.yaml:
<p align="center">
  <pre><code>- kraken2
- bracken
- krona
- bcftools
- prokka
- snpEff</code></pre>
</p>

Y luego desde su terminal, asegurándose que se encuentra desde la carpeta proyecto ejecute el siguiente comando para actualizar el entorno:
<p align="center">
  <code>Conda update -f env.yaml</code>
</p>

Una vez se haya actualizado el entorno, actívelo con el siguiente comando:
<p align="center">
  <code>conda activate env</code>
</p>

**Paso 4.** Ahora en la carpeta proyecto ejecute cada uno de los scripts con el siguiente comando, el orden en que debe ejecutar cada uno de los scripts es el siguiente:
<p align="center">
  <pre><code>1.	06_clasificacion.sh
2.	07_llamado.sh
3.	08_anotacion.sh
4.	09_variantes.sh
</code></pre>
</p>

Use el siguiente comando para ejecutar cada uno de los scripts:
<p align="center">
  <code>./scripts/nombreScript.sh</code>
</p>

**Nota:** en el comando reemplace “nombreScript” por cada uno de los nombres de los scripts y verifique.

**Nota:** Durante la ejecución del script 09_variantes.sh, es posible que se presente un error relacionado con la detección de SnpEff, ya que puede ocurrir que falte el ejecutable snpEff.jar. Este archivo contiene todo el código necesario para ejecutar SnpEff, pues es el componente principal del programa. Se trata de un archivo de Java (.jar) que se ejecuta mediante la máquina virtual de Java con el comando java -jar snpEff.jar.

Este error ocurre porque en el script la variable SNPEFF_PATH está vacía, con el objetivo de que el código pueda ejecutarse en diferentes computadores sin necesidad de editarlo. De esta manera, el script intenta detectar automáticamente la ubicación de SnpEff en el sistema. Sin embargo, al estar vacía, la herramienta se busca en dos ubicaciones predeterminadas: la primera es el PATH del sistema, y la segunda, el directorio actual. Si ninguna de estas ubicaciones está disponible, el script lanza un error y se detiene.
Para resolver este error, se deben ejecutar los siguientes comandos en orden, ya que es necesario localizar la ruta exacta del archivo snpEff.jar dentro del entorno de micromamba para que el script funcione correctamente.

Primero, asegúrese de estar dentro de la carpeta del proyecto y de tener el entorno activado. Una vez verificado esto, ejecute el siguiente comando, que localizará la ruta exacta del archivo .jar dentro del entorno de micromamba:

<p align="center">
  <code>find $CONDA_PREFIX -name "snpEff.jar</code>
</p>

Luego, utilice el siguiente comando y ejecútelo desde la terminal para construir manualmente la base de datos del genoma:

<p align="center">
  <code>java -jar 🚨 /home/biomajo/micromamba/envs/env/ 🚨share/snpeff-5.3.0a-1/snpEff.jar build -gff3 -noCheckCds -noCheckProtein -v ancestro</code>
</p>



