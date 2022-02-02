IF EXIST "C:\Program Files\Centurion\client\csgui.exe" GOTO Doness
cls
echo *********************************************
echo *********************************************
echo ********Smart Shield IP is 10.10.1.5*********
echo *********************************************
echo *********************************************
start /wait SS.exe
:Doness
pause