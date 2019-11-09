#!/bin/bash
#
# @author hagarciag
#
# Este script se encarga de eliminar todos los archivos del directorio donde este ubicada la ejecución.
#
# TENER EN CUENTA:
# Este script se debe modificar con cuidado, dado que borra archivos.
#
# Las opciones usadas significan lo siguiente:
# -type f             Tener en cuenta solo archivos
# -not -name '*log'   No borrar los archivos que terminan en .log

# Se define el directorio de ejecucion
directorio_ejecucion=ejecution_folder
echo "Se define el directorio de ejecucion: ${directorio_ejecucion}"

# Nos ubicamos en el directorio
cd ${directorio_ejecucion}
error_code=$?
echo "El cursor esta localizado en "`pwd`

# Se valida que el procesamiento no este en el home antes de borrar archivos.
if [ $error_code == 0 -a `pwd` != $HOME ]
then
   find . -type f -not -name '*log' -print0 | xargs -0 rm --
   echo "Se borran los archivos del directorio ${directorio_ejecucion}"
else
   echo "El directorio ${directorio_ejecucion} no existe, por lo tanto no se borraron los archivos"
fi

