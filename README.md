# Tutorial: preparacion de archivos WRF/WPS en Leftraru

Este tutorial muestra como ingresar a Leftraru, descargar los archivos de la clase y preparar WPS para ejecutar `geogrid.exe`.

En todos los comandos, reemplazar `studentXX` por el usuario correspondiente, por ejemplo `student01`, `student02`, etc.

## 1. Ingresar a Leftraru desde terminal

```bash
ssh -p 4603 studentXX@leftraru.nlhpc.cl
```

Ingresar la contrasena entregada para el usuario:

```text
contrasena: ******
```

## 2. Descargar la carpeta con archivos de la clase

Desde `/home/courses/studentXX/`, clonar el repositorio:

```bash
git clone https://github.com/SurAurora/archivos_WRF.git
```

Esto creara la carpeta:

```bash
/home/courses/studentXX/archivos_WRF
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

Copiar el archivo `namelist.wps` creado en la pagina Domain Wizard de Jiri Richter, descargado desde GitHub:

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

El siguiente paso es ejecutar `geogrid.exe`. Para eso se utiliza un documento con las caracteristicas del trabajo que se quiere ejecutar. Este documento se puede crear en:

https://wiki.nlhpc.cl/Generador_Scripts

Los documentos ya estan listos en `/home/courses/studentXX/archivos_WRF`. Copiarlos a la carpeta correcta:

```bash
cp /home/courses/studentXX/archivos_WRF/*.job /home/courses/studentXX/models/wps/WPS-4.2/
```

Editar cada archivo `.job`:

```bash
nano run_geogrid.job
nano run_ungrib.job
nano run_metgrid.job
```

En cada `.job`, cambiar el correo:

```bash
#SBATCH --mail-user=correo@dgac.gob.cl
```

Tambien revisar que la ruta donde esta ubicado `namelist.wps` corresponda al usuario correcto:

```bash
cd /home/courses/studentXX/models/wps/WPS-4.2/
```

Guardar y cerrar cada archivo.

Dar permisos de ejecucion a cada `.job`:

```bash
chmod a+x *.job
```

## 10. Ejecutar `geogrid.exe`

Ejecutar el trabajo:

```bash
sbatch run_geogrid.job
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
