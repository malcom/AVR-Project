rem
rem Simple script over make tool for convert GCC output messages
rem style to Visual Studio format.
rem
rem Used in AVR project template for Visual Studio IDE
rem http://github.com/malcom/AVR-Project
rem
rem Copyright (C) 2016 Marcin 'Malcom' Malich <me@malcom.pl>
rem
rem Released under the MIT License.
rem

@echo off

if "%1" == ""       goto build
if "%1" == "build"   goto build
if "%1" == "rebuild" goto rebuild
if "%1" == "clean"   goto clean

make %*
goto eof

:build
rem gcc <file>:line[:column]: type: <text>
rem vc  <file>(line[,column]): type: <text>
make 2>&1 | sed -e "s/:\([0-9]\+\):\([0-9]\+\):/(\1,\2):/" -e "s/:\([0-9]\+\):/(\1):/"
goto eof

:rebuild
make clean
goto build

:clean
make clean
goto eof

:eof