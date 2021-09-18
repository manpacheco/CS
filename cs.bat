@echo off
del cs.tap /Q
del public.txt /Q
cd src
pasmo --name cs --tapbas Main.asm ..\cs.tap --public
REN --public public.txt
cd ..
"C:\Mis programas\Spectaculator\Spectaculator.exe" cs.tap
