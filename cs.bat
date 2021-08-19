@echo off
del cs.tap /Q
cd src
pasmo --name cs --tapbas Main.asm ..\cs.tap --public
cd ..
"C:\Mis programas\Spectaculator\Spectaculator.exe" cs.tap
