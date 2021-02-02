#!/bin/bash


dia=`date +%j`

if [[ $1 == "-h" ]] ;
	then printf "Este programa calcula los días restantes hasta fin de año y devuelve si son múltiplo de 5. Para ejecutar: ./fecha.sh\n\n";
fi;


if [[ $(( (365 - $dia) % 5 )) == 0 ]];
	then printf "Es multiplo de 5\n";

else printf "No es multiplo de 5\n";
fi;
		
