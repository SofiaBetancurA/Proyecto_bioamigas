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
```
- kraken2
- bracken
- krona
- bcftools
- prokka
- snpEff

Y luego desde su terminal, asegurándose que se encuentra desde la carpeta proyecto ejecute el siguiente comando para actualizar el entorno:
<p align="center">
  <code>Conda update -f env.yaml</code>
</p>


