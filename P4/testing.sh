#!/bin/bash

echo "El archivo" $1 "..."

test -f $1 && test -x $1
plano_exe=$?

test -h $1
simb=$?

echo "¿Es un archivo plano y tiene permisos de ejecución? " $plano_exe
echo "¿Es un enlace simbólico? " $simb
