@echo ********************Change Computer Name********************
set /p newname= "Enter New Computer Name: "
echo THIS COMPUTER WILL BE NAMED %newname%!
pause
wmic computersystem where name="%computername%" call rename name="%newname%" > name.txt
wmic computersystem where name="%computername%" call joindomainorworkgroup name="WG.%newname%" >> name.txt

