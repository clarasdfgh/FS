#!/bin/bash

if test -f $1 ; 
	then printf "El archivo $1 existe\n"; 

elif test -d $2 ; 
	then printf "El archivo $1 no existe, pero $2 es un directorio\n"; 

else printf "El archivo $1 no existe\n"; 
fi
