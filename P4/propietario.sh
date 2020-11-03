#!/bin/bash

if test -O $1 && test -r $1;
	then printf "Ud. es el propietario del archivo $1 y tiene permiso de lectura\n";
else
	printf "Ud. no es el propietario del archivo $1 y no tiene permiso de lectura\n";
fi;
