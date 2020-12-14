#!/bin/bash 
# Uso: pathmas directorio [after] 
if ! echo $PATH | /bin/egrep -q "(^|:)$1($|:)" ; then 
		if [ "$2" == "after" ] ; then # <<<<<<<<<<<<<<<<<<<<< 
				PATH=$PATH:$1 
			else 
				PATH=$1:$PATH 
		fi 
	else echo "$1 ya está en el path" 
fi
