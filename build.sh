#!/bin/bash
# Building project script
# Usage - bash build.sh <entity-name>

# Compila todos os arquivos .vhd 
ghdl -a *.vhd

# Roda a simulação 
ghdl -r "$1_tb" --wave=waves.ghw

# Abre o GTKWave
gtkwave waves.ghw
