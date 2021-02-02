#!/bin/bash
#FS -- Examen módulo 2
#Ejercicio 1 (3 puntos)
#Clara M Romero Lara


if (test $# -gt 1 && test $# -lt 4) && [[ "$1" != "--h" ]];
then

	if (test $# -gt 1 && test $# -lt 4) && [[ "$1" = "--c" ]];
	then
		
		if test $# -eq 3 && test -f $2 && test -f $3
		then
			printf "Copiando fichero $2 en fichero $3...\n"
			cp $2 $3		
		
		elif test $# -eq 2 && test -d $2	
		then
			printf "Copiando los ficheros regulares del directorio actual en $2...\n" 
			cp $PWD/* $2
		
		else
			printf "Error en los argumentos. Consulte la ayuda con --h\n"
		
		fi;
	fi;
	
elif test $# -eq 2 && [[ "$1" = "--sh" ]]
then
	printf "shshsh"
	#if [[ "$2" = "zsh" ]] || [[ "$2" = "sh" ]] || [[ "$2" = "bash" ]]
	#then
	#	printf "Comprobando los usuarios que usan $2...\n"
		#echo `cat /etc/passwd | grep -oP '^.*"$2"$'| cut -d':' -f1`
		
	#else
	#	printf "Error en los argumentos. Consulte la ayuda con --h\n"
	#fi;	
	
else
	printf "Consulte la ayuda: \n"
	printf "./examen1.sh  --c  argumentos. Los argumentos pueden ser:\n"
		printf "    fichero_fuente  fichero_destino  . Copia el fichero fuente en el distino\n"
      printf "    solo directorio_destino (si no existe se crea).  Copia los ficheros planos del directorio de trabajo en el directorio_destino\n"

	printf "./examen1.sh  --h   muestra esta ayuda en pantalla\n"
	printf "./examen1,sh --sh argumento. El guión nos deberá mostrar los usuarios que están usando el tipo de Shell especificado como argumento. El argumento podrá ser: csh, o sh o bash...\n"
fi;


