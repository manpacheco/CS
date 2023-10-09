@echo off
cd "c:\Users\Manuel\Desktop\Proyecto CS\CSand"
del cs.tap /Q
cd src
del public.txt /Q
"C:\Prog_SSD\Pasmo_054b2\pasmo.exe" --name cs --tapbas Main.asm ..\cs.tap --public
echo Renombrando
REN --public public.txt
cd ..
rem "f:\Mis programas\Spectaculator\Spectaculator.exe" cs.tap
"f:\Manuel\Spectrum\spin\zxspin.exe" "c:\Users\Manuel\Desktop\Proyec~1\CSand\cs.tap"


