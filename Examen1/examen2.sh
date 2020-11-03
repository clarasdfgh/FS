#!/bin/bash

#FS -- Examen módulo 1
#Ejercicio 2 (2 puntos)
#Clara María Romero Lara

find /etc -user root -ctime 7 -name "*[^aep]*.[^aep]*" -perm -o=r
