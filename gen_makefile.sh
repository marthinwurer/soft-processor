#!/bin/bash

# calculate the main file
in=$1
filename="${in%.*}"
echo "$filename"

options=${@:2}


rm -r work
mkdir work
# --vcd=out.vcd
ghdl -i --workdir=work $options *.vhd
ghdl --gen-makefile --workdir=work $options $filename > makefile

sed -i "7a\
	GHDLRUNFLAGS= --vcd=wave_${filename}.vcd" makefile
