#!/usr/bin/env bash
set -euxo pipefail


cc ./src/gl.c -lGL -c -I./include
# cc main.c gl.o -lGL -lglfw -o out -Wall -Wextra -I./include

nasm -felf64 main.asm -gdwarf
cc main.o gl.o -lGL -lglfw -o out -no-pie
