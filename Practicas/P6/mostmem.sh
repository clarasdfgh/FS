#!/bin/bash 

top -n 1 -o %MEM | head -8 | tail -1 | sed $'s/[^[:print:]\t]//g' | sed $'\s(\w+).?$'  > temp.txt


echo temp.txt | grep -oE '\s(\w+).?$'
sed $'s/[^[:print:]\t]//g' file.txt

##QUIERO SACAR SOLO EL NOMBRE, por eso hay cuarenta cosas distintas de regex. Tal y como estamos podría imprimir la línea y a tomar por culo pero el examen es mañana y no tengo tiempo que perder, chau, tengo closure
