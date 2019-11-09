#!/bin/bash
#
# @author hagarciag
#
# Este script lanza el orquestador de scala y luego empieza a mostrar el log en consola
#
# TENER EN CUENTA:
# Este script es invocado desde el archivo orquestador_local.sh
# Para ejecutar este script se debe estar ubicado en el directorio ~/orquestador.
#
# Las opciones usadas significan lo siguiente:
# 2>&1   Significa que la salida estandar y los errores se deben dirigir al log especificado
# &      Con eso se especifica que el proceso corre en background, es decir, si se cae la conexión sigue la ejecución

# Se define el directorio de ejecucion
directorio_ejecucion=ejecution_folder
echo "Se define el directorio de ejecucion: ${directorio_ejecucion}"

# Nos ubicamos en el directorio
echo "Se entra al directorio ${directorio_ejecucion}"
cd ${directorio_ejecucion}

# Se define el nombre del archivo log
log=ejecution_scala_orquestator_`date +"%Y%m%d_%H%M%S"`.log
echo "Se crea el log de ejecucion ${log}"

# Se ejecuta el proceso
echo "Se invoca el spark-submit para ejecutar el proceso"
JAVA_HOME=/org/mycompany/java/jdk1.8.0_111 spark-submit --class Main Orquestador.jar> ${log} 2>&1 &

# Comando ver el log mientras se ejecuta el proceso
tail -f ${log}

exit
