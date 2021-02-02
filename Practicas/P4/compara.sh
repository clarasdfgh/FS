#!/bin/bash

echo "Los números introducidos son: " $1 ", " $2

echo ""
echo "Son iguales? " $(($1 == $2))

echo ""
echo "Es" $1 "mayor o igual que" $2 "? "  $(($1 >= $2))

echo ""
echo "Es" $1 "menor o igual que" $2 "? "  $(($1 <= $2))
