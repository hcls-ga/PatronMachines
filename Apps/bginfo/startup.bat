@echo off
sc config "wuauserv" start= disabled
sc stop "wuauserv"
sc config "bits" start= disabled
sc stop "bits"
sc config "dosvc" start= disabled
sc stop "dosvc"
schtasks /change /tn "Microsoft\windows\WindowsUpdate\Scheduled Start" /disable
schtasks /delete /tn "Microsoft\windows\WindowsUpdate\sih" /F
schtasks /delete /tn "Microsoft\windows\WindowsUpdate\sihboot" /F

sc config "wuauserv" start= disabled
sc stop "wuauserv"
sc config "bits" start= disabled
sc stop "bits"
sc config "dosvc" start= disabled
sc stop "dosvc"
schtasks /change /tn "Microsoft\windows\WindowsUpdate\Scheduled Start" /disable
schtasks /delete /tn "Microsoft\windows\WindowsUpdate\sih" /F
schtasks /delete /tn "Microsoft\windows\WindowsUpdate\sihboot" /F

sc config "wuauserv" start= disabled
sc stop "wuauserv"
sc config "bits" start= disabled
sc stop "bits"
sc config "dosvc" start= disabled
sc stop "dosvc"
schtasks /change /tn "Microsoft\windows\WindowsUpdate\Scheduled Start" /disable
schtasks /delete /tn "Microsoft\windows\WindowsUpdate\sih" /F
schtasks /delete /tn "Microsoft\windows\WindowsUpdate\sihboot" /F
cls
timeout 15
net use p: /delete /y
net use p: \\10.10.1.4\Patrons patron /user:hcls\patron
bginfo.exe default.bgi /silent /timer:0 /nolicprompt
timeout 5
net use p: /delete /y