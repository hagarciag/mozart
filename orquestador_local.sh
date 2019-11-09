#!/bin/bash
#
# @author hagarciag
#
# Este ejecutor desencadena la ejecución desde el equipo local (Windows + Git Bash) y orquesta diferentes acciones
# como: borrado de archivos, subida de archivos y ejecución del orquestador_remoto
#
# TENER EN CUENTA:
# El comando sftp solo sube archivos (este comando no crea carpetas), por lo El archivo las estructura de carpeta ya debe
# existir en servidor, de lo contrario falla carga de los archivos al especificarle una carpeta remota en cual debe dejar
# un archivo pero no la encuentra creada.
# Este proceso pide 3 veces la contraseña, eso lo hace porque se conecta 3 veces al servidor de acceso al data lake:
# 1. Primero se conecta para borrar los archivos existentes.
# 2. Se conecta para dejar allá los archivos mas reciente de nuestra carpeta de windows
# 3. Se conecta para realizar la ejecución del proceso

# Se obtiene el usuario con el cual se pasan los archivos y se ejecuta el proceso en el servidor de acceso al data lake.
# Se asume que el usuario logueado en Windows es el mismo del servidor Linux al que se conecta para realizar las operaciones,
# de lo contrario coloque el usuario con el que raliza las operaciones en el servidor Linux remoto.
usuario="$(whoami)"
echo "Se asigna el usuario '${usuario}' para subir los archivos a ejecutar al servidor"

# Se asigna la URL del servidor de acceso al data lake
url_access_landing_zone=myserver.corp
echo "Se asigna la URL '${url_access_landing_zone}' del servidor de acceso a la landing zone"

# Se define el directorio de ejecucion
directorio_ejecucion=ejecution_folder
echo "Se define el directorio de ejecucion: ${directorio_ejecucion}"


# Se borran los archivos con los cuales se hizo la ejecución
echo "Comienza el borrado de archivos existentes en el servidor..."
ssh ${url_access_landing_zone} < borrar_archivos_servidor.sh
echo "Termina el borrado de archivos existentes en el servidor..."


# Se cargan los archivos para tener una version reciente antes de la ejecución.
echo "Comienza la carga de los archivos a ejecutar al servidor..."
sftp ${usuario}@${url_access_landing_zone} << EOF
  put -r ../../orquestador/*.sh ${directorio_ejecucion}/orquestador/
  put -r ../../2-consignación_folder_dummy/1-dummy-process/*.sql ${directorio_ejecucion}/2-consignación_folder_dummy/1-dummy-process/
  put -r ../../2-consignación_folder_dummy/2-dummy-process/*.sql ${directorio_ejecucion}/2-consignación_folder_dummy/2-dummy-process/
  put -r ../../2-dummy-folder/1-other-dummy-process/*.sql ${directorio_ejecucion}/2-dummy-folder/1-other-dummy-process/
  put -r ../../3-unit_tests/1-dummy-process/*.py ${directorio_ejecucion}/3-unit_tests/1-dummy-process/
  put -r ../../Orquestador.jar ${directorio_ejecucion}/Orquestador.jar
EOF
echo "Termina la carga de los archivos a ejecutar al servidor..."

echo "Empieza la ejecución del orquestador..."
ssh ${url_access_landing_zone} < orquestador_remoto.sh
echo "Termina la ejecución del orquestador..."

exit
