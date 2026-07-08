# Tutorial de ejecución simulación WRF en modo diagnóstico en NLHPC.

Este tutorial esta siendo escrito por Aurora Lagos-Duarte (aurora.lagos.d@uchile.cl). 
Última actualización el 08-julio-2026.

En este documento encontrará el paso a paso de: como ingresar a Leftraru, descargar los archivos mínimos para ejecutar el flujo completo de WRF y hacer una simulación WRF en modo de diagnóstico. Todo esto en el ambiente HPC del Laboratorio Nacional de Computación de Alto Rendimiento (https://www.nlhpc.cl/)

nota: En todos los comandos siguientes, reemplazar `studentXX` por el usuario correspondiente, por ejemplo `student01`, `student02`, etc.

## 1. Ingresar al NLHPC desde terminal

```bash
ssh -p XXXX studentXX@leftraru.nlhpc.cl
```

Ingresar la contrasena entregada para el usuario:

```text
contrasena: **************
```

## 2. Descargar o actualizar la carpeta con archivos de la clase

Desde `/home/courses/studentXX/`, clonar el repositorio:

```bash
git clone https://github.com/SurAurora/archivos_WRF.git
```

Esto creara la carpeta:

```bash
/home/courses/studentXX/archivos_WRF
```

En caso de ya haber tenido la carpeta, debe ingresar a ella:

```bash
cd /home/courses/studentXX/archivos_WRF/
```

y actualizar los archivos:

```bash
git pull
```

## 3. Crear la carpeta `models`

Volver al home del usuario y crear la carpeta `models`:

```bash
cd
mkdir models
```

Entrar a `models`:

```bash
cd models
```

## 4. Crear la carpeta `wps`

Dentro de `models`, crear la carpeta `wps` y entrar:

```bash
mkdir wps
cd wps
```

Copiar la carpeta del modelo WPS en el directorio actual:

```bash
cp -r /home/lmod/software/WPS/4.2-intel-2022.00-dmpar/WPS-4.2 .
```

Entrar a la carpeta `WPS-4.2`:

```bash
cd WPS-4.2
```

## 5. Reemplazar el `namelist.wps`

Cambiar de nombre el archivo original `namelist.wps` para dejarlo como respaldo:

```bash
mv namelist.wps namelist.wps.bak
```

Copiar el archivo `namelist.wps` creado en la pagina Domain Wizard de Jiri Richter (https://jiririchter.github.io/WRFDomainWizard/), descargado desde GitHub:

```bash
cp /home/courses/studentXX/archivos_WRF/namelist.wps.dominio_93km_ChileCentroSur .
```

## 6. Descargar datos geoestaticos de WRF

El siguiente paso es descargar los datos geoestaticos de WRF, que incluyen topografia, uso de suelo, textura de suelo, albedo, LAI, entre otros.

Los datos estan disponibles en:

https://www2.mmm.ucar.edu/wrf/users/download/get_sources_wps_geog.html#mandatory

Para descargar los datos, volver a `/home/courses/studentXX/`:

```bash
cd
```

Crear la carpeta `data` e ingresar a ella:

```bash
mkdir data
cd data
```

Descargar los datos geoestaticos en ese directorio:

```bash
wget https://www2.mmm.ucar.edu/wrf/src/wps_files/geog_low_res_mandatory.tar.gz
```

Una vez descargados, descomprimirlos:

```bash
tar -xzvf geog_low_res_mandatory.tar.gz
```

La direccion de los archivos geoestaticos sera:

```bash
/home/courses/studentXX/data/WPS_GEOG_LOW_RES
```

## 7. Editar el archivo `namelist.wps.dominio_93km_ChileCentroSur`

Volver a la carpeta de WPS:

```bash
cd /home/courses/studentXX/models/wps/WPS-4.2/
```

Abrir el archivo:

```bash
nano namelist.wps.dominio_93km_ChileCentroSur
```

Cambiar el flag `geog_data_path` por:

```fortran
 geog_data_path       = '/home/courses/studentXX/data/WPS_GEOG_LOW_RES/'
```

Como se utilizaran datos de baja resolucion, el flag `geog_data_res` debe ser:

```fortran
 geog_data_res        = 'lowres', 'lowres'
```

Guardar y cerrar el archivo.

## 8. Crear link simbolico a `namelist.wps`

Crear un link simbolico, equivalente a un acceso directo, desde `namelist.wps.dominio_93km_ChileCentroSur` con el nombre `namelist.wps`:

```bash
ln -s namelist.wps.dominio_93km_ChileCentroSur namelist.wps
```

## 9. Copiar y editar scripts `.job`

El siguiente paso es ejecutar `geogrid.exe`. Para eso se utiliza un documento con las caracteristicas del trabajo que se quiere ejecutar y que luego gestionara SLURM. Este documento se puede crear en:

https://wiki.nlhpc.cl/Generador_Scripts

Los documentos ya estan listos y estan disponibles en `/home/courses/studentXX/archivos_WRF`. Solo hay que copiar los scripts de lanzamiento con el siguiente comando:

```bash
cp /home/courses/studentXX/archivos_WRF/run_wps* /home/courses/studentXX/models/wps/WPS-4.2/
```

Editar cada script:

```bash
nano run_wps_geogrid.job
nano run_wps_ungrib.job
nano run_wps_metgrid.job
```

En cada script, cambiar el correo:

```bash
#SBATCH --mail-user=correo@dgac.gob.cl
```

Tambien revisar que la ruta donde esta ubicado `namelist.wps` corresponda al usuario correcto:

```bash
cd /home/courses/studentXX/models/wps/WPS-4.2/
```

Guardar y cerrar cada archivo.

Dar permisos de ejecucion a cada script:

```bash
chmod a+x run_wps_geogrid.job run_wps_ungrib.job run_wps_metgrid.job
```

## 10. Ejecutar `geogrid.exe`

Ejecutar el trabajo:

```bash
sbatch run_wps_geogrid.job
```

## 11. Revisar el estado de la tarea

Para revisar el estado de la tarea:

```bash
squeue
```

Tambien se puede usar la opcion `-i5` para actualizar el estado cada 5 segundos:

```bash
squeue -i5
```

Para cortar el comando `squeue`, usar:

```text
Ctrl + C
```

Una vez que termine la tarea, llegara un correo de notificacion con el mensaje `(COMPLETED)`, o bien al revisar el estado de la tarea con `squeue` no aparecera ninguna tarea ejecutandose.

Para confirmar que la tarea fue completada con exito, revisar las ultimas lineas del archivo `geogrid.log`:

```bash
tail -20 geogrid.log
```

Si la tarea fue ejecutada exitosamente, el ultimo mensaje dira:

```text
*** Successful completion of program geogrid.exe ***
```

Caso contrario, hubo un error en alguno de los pasos anteriores.

## 12. Descargar datos meteorologicos

Antes de descargar los datos meteorologicos, crear una carpeta que albergara los datos meteorologicos que serviran de condiciones iniciales y condiciones de borde:

```bash
cd /home/courses/studentXX/data/
mkdir CI_CB
cd CI_CB
mkdir fnl
```

La ruta completa sera `/home/courses/studentXX/data/CI_CB/fnl/`. En esa posicion se copiara el archivo creado en la pagina de GDEX que permite la descarga automatizada del producto FNL:

```bash
cp /home/courses/studentXX/archivos_WRF/download_fnl_gdex.csh .
```

Para comenzar la descarga, ejecutar:

```bash
./download_fnl_gdex.csh
```

## 13. Linkear datos meteorologicos

Una vez terminada la descarga, volver a la carpeta de trabajo de WPS:

```bash
cd /home/courses/studentXX/models/wps/WPS-4.2
```

Y linkear los archivos meteorologicos descargados:

```bash
./link_grib.csh /home/courses/studentXX/data/CI_CB/fnl/fnl* .
```

## 14. Linkear `Vtable`

Tambien linkear la `Vtable` correspondiente a los archivos meteorologicos:

```bash
ln -s ungrib/Variable_Tables/Vtable.GFS Vtable
```

## 15. Ejecutar `ungrib.exe`

Ya esta todo preparado para ejecutar `ungrib.exe`:

```bash
sbatch run_wps_ungrib.job
```

Se puede revisar el avance con el comando:

```bash
squeue -i5
```

Una vez terminada la tarea, revisar las ultimas 20 lineas del archivo `ungrib.log` para confirmar que haya terminado con exito:

```bash
tail -20 ungrib.log
```

De haber terminado con exito, deberia decir:

```text
****  Done deleting temporary files.
*** Successful completion of program ungrib.exe ***
```

## 16. Ejecutar `metgrid.exe`

Si `ungrib.exe` termino con exito, el siguiente paso es ejecutar `metgrid.exe`:

```bash
sbatch run_wps_metgrid.job
```

Una vez terminada la tarea, revisar que esta haya terminado con exito:

```bash
tail -20 metgrid.log
```

De haber terminado con exito, deberia decir:

```text
*** Successful completion of program metgrid.exe ***
```

## 17. Crear la carpeta `wrf`

Dentro de `models`, crear la carpeta `wrf` y entrar:

```bash
mkdir wrf
cd wrf
```

Copiar la carpeta del modelo WRF en el directorio actual:

```bash
cp -r /home/lmod/software/WRF/4.3.3-intel-2022.00-dmpar/WRF-4.3.3 .
```

Entrar a la carpeta `WRF-4.3.3`:

```bash
cd WRF-4.3.3
```

Entrar al directorio `run`, donde se ejecutan `real.exe` y `wrf.exe`:

```bash
cd run
```

## 18. Reemplazar el `namelist.input`

Cambiar de nombre el archivo original `namelist.input` para dejarlo como respaldo:

```bash
mv namelist.input namelist.input.bak
```

Copiar el archivo `namelist.input`:

```bash
cp /home/courses/studentXX/archivos_WRF/namelist.input.dominio_93km_ChileCentroSur .
```

## 19. Crear link simbolico a `namelist.input`

Crear un link simbolico, equivalente a un acceso directo, desde `namelist.input.dominio_93km_ChileCentroSur` con el nombre `namelist.input`:

```bash
ln -s namelist.input.dominio_93km_ChileCentroSur namelist.input
```

## 20. Crear link simbolico a archivos `met_em`

Crear un link simbolico de los archivos `met_em.d0*`:

```bash
ln -s /home/courses/studentXX/models/wps/WPS-4.2/met_em.d0* .
```

## 21. Copiar y editar scripts `.job`

Los siguientes pasos son ejecutar `real.exe` y `wrf.exe`. Los documentos para lanzarlos estan disponibles en `/home/courses/studentXX/archivos_WRF`. Solo hay que copiar los archivos `.job` con el siguiente comando:

```bash
cp /home/courses/studentXX/archivos_WRF/run_wrf* /home/courses/studentXX/models/wrf/WRF-4.3.3/run/
```

Ahora, para cada archivo `.job`:

```bash
nano run_wrf_real.job
nano run_wrf_wrf.job
```

Hay que cambiar el correo:

```bash
#SBATCH --mail-user=correo@dgac.gob.cl
```

Y dar permisos de ejecucion a cada `.job`:

```bash
chmod a+x *.job
```

## 22. Ejecutar `real.exe`

Ejecutar el trabajo:

```bash
sbatch run_wrf_real.job
```

Una vez terminada la tarea, la ultima linea del archivo `rsl.error.0000` debe ser:

```text
SUCCESS COMPLETE REAL_EM INIT
```

## 23. Ejecutar `wrf.exe`

Ejecutar el trabajo:

```bash
sbatch run_wrf_wrf.job
```

Una vez terminada la tarea, la ultima linea del archivo `rsl.error.0000` debe ser:

```text
SUCCESS COMPLETE WRF
```
