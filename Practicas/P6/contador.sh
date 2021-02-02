#!/bin/bash 

contador=0

while true;
do echo $contador
	contador=`expr $contador + 1`
	sleep 1;
done
