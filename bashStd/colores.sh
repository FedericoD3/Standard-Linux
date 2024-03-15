#!/bin/bash

color=16;

while [ $color -lt 245 ]; do
    echo -e "$color: \\e[38;5;${color}m hello \\e[48;5;${color}m world \\e[0m"
    ((color++));
done  
