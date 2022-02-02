REM ***************************
REM *******(C) Neil Byrd*******
REM ***************************

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

schtasks /change /tn "Microsoft\windows\UpdateOrchestrator\Maintenance Install" /disable
schtasks /change /tn "Microsoft\windows\UpdateOrchestrator\Policy Install" /disable
schtasks /change /tn "Microsoft\windows\UpdateOrchestrator\Reboot" /disable
schtasks /change /tn "Microsoft\windows\UpdateOrchestrator\Refresh Settings" /disable
schtasks /change /tn "Microsoft\windows\UpdateOrchestrator\Resume On Boot" /disable
schtasks /change /tn "Microsoft\windows\UpdateOrchestrator\Schedule Retry Scan" /disable
schtasks /change /tn "Microsoft\windows\UpdateOrchestrator\Schedule Scan" /disable
schtasks /change /tn "Microsoft\windows\UpdateOrchestrator\USO_UxBroker_Display" /disable
schtasks /change /tn "Microsoft\windows\UpdateOrchestrator\USO_UxBroker_ReadyToReboot" /disable
taskkill /f /im usoclient.exe
takeown /f C:\windows\system32\usoclient.exe
icacls C:\windows\system32\usoclient.exe /grant administrators:F
del C:\windows\system32\usoclient.exe 


sc config "wuauserv" start= disabled
sc stop "wuauserv"
sc config "bits" start= disabled
sc stop "bits"
sc config "dosvc" start= disabled
sc stop "dosvc"
schtasks /change /tn "Microsoft\windows\WindowsUpdate\Scheduled Start" /disable
schtasks /delete /tn "Microsoft\windows\WindowsUpdate\sih" /F
schtasks /delete /tn "Microsoft\windows\WindowsUpdate\sihboot" /F

schtasks /change /tn "Microsoft\windows\UpdateOrchestrator\Maintenance Install" /disable
schtasks /change /tn "Microsoft\windows\UpdateOrchestrator\Policy Install" /disable
schtasks /change /tn "Microsoft\windows\UpdateOrchestrator\Reboot" /disable
schtasks /change /tn "Microsoft\windows\UpdateOrchestrator\Refresh Settings" /disable
schtasks /change /tn "Microsoft\windows\UpdateOrchestrator\Resume On Boot" /disable
schtasks /change /tn "Microsoft\windows\UpdateOrchestrator\Schedule Retry Scan" /disable
schtasks /change /tn "Microsoft\windows\UpdateOrchestrator\Schedule Scan" /disable
schtasks /change /tn "Microsoft\windows\UpdateOrchestrator\USO_UxBroker_Display" /disable
schtasks /change /tn "Microsoft\windows\UpdateOrchestrator\USO_UxBroker_ReadyToReboot" /disable
taskkill /f /im usoclient.exe
takeown /f C:\windows\system32\usoclient.exe
icacls C:\windows\system32\usoclient.exe /grant administrators:F
del C:\windows\system32\usoclient.exe 


sc config "wuauserv" start= disabled
sc stop "wuauserv"
sc config "bits" start= disabled
sc stop "bits"
sc config "dosvc" start= disabled
sc stop "dosvc"
schtasks /change /tn "Microsoft\windows\WindowsUpdate\Scheduled Start" /disable
schtasks /delete /tn "Microsoft\windows\WindowsUpdate\sih" /F
schtasks /delete /tn "Microsoft\windows\WindowsUpdate\sihboot" /F


schtasks /change /tn "Microsoft\windows\UpdateOrchestrator\Maintenance Install" /disable
schtasks /change /tn "Microsoft\windows\UpdateOrchestrator\Policy Install" /disable
schtasks /change /tn "Microsoft\windows\UpdateOrchestrator\Reboot" /disable
schtasks /change /tn "Microsoft\windows\UpdateOrchestrator\Refresh Settings" /disable
schtasks /change /tn "Microsoft\windows\UpdateOrchestrator\Resume On Boot" /disable
schtasks /change /tn "Microsoft\windows\UpdateOrchestrator\Schedule Retry Scan" /disable
schtasks /change /tn "Microsoft\windows\UpdateOrchestrator\Schedule Scan" /disable
schtasks /change /tn "Microsoft\windows\UpdateOrchestrator\USO_UxBroker_Display" /disable
schtasks /change /tn "Microsoft\windows\UpdateOrchestrator\USO_UxBroker_ReadyToReboot" /disable
taskkill /f /im usoclient.exe
takeown /f C:\windows\system32\usoclient.exe
icacls C:\windows\system32\usoclient.exe /grant administrators:F
del C:\windows\system32\usoclient.exe 