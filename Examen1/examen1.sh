#!/bin/bash

#FS -- Examen módulo 1
#Ejercicio 1 (8 puntos)
#Clara María Romero Lara

if test $# -eq 1;
then
	lineas=`ls -l *$1* | wc -l`

	printf "El número de archivos que contienen la cadena $1 es: $lineas\n" 

	caracteres=`wc -c *$1* | tail -1`

	printf "El tamaño total en caracteres de estos archivos es $caracteres\n";
	
elif test $# -eq 2 && test -f $2;
then
	test -f $2 && cat $1 >> $2 || cp $1 $2 ;
	
elif test $# -eq 2 && test -d $2;
then
	touch $2/$1-`date +%Y-%m-%d`
	cat $1 >> $2/$1-`date +%Y-%m-%d`;
	
else
	printf "\n Este es el ejercicio 1 del examen del modulo 1 de FS. Su uso es como sigue:\n\n"
	printf "\t ./examen1 cadenaCaracteres -- devuelve todos los archivos del directorio de trabajo\n\t que contengan en su nombre la cadenaCaracteres, \n\tel número de archivos y el total de caracteres\n\n"
	printf "\t ./examen1 nombreArchivo1 nombreArchivo2 -- si no existe nombreArchivo2 se creará y \n\tcopia el archivo nombreArchivo1 en el archivo nombreArchivo2. \n\tSi ya existe el archivo nombreArchivo2, entonces se le añade al final del \n\tarchivo nombreArchivo2 el contenido del archivo nombrearchivo1\n\n"
	printf "\t ./examen1 nombrearchivo1 nombreDirectorio -- copia el archivo nombreArchivo1 en \n\tel directorio nombreDirectorio con el \n\tsiguiente nombre: nombreArchivo1_AAA-MM-DD, donde  AAAA-MM-DD es la fecha \n\tcuando se ejecuta el guión\n\n";
	printf "\t En cualquier otro caso, imprime este mensaje de ayuda\n"
fi;

