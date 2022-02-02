<#
.SYNOPSIS
  <Overview of script>
.DESCRIPTION
  <Brief description of script>
.PARAMETER <Parameter_Name>
    <Brief description of parameter input required. Repeat this attribute if required>
.INPUTS
  <Inputs if any, otherwise state None>
.OUTPUTS
  <Outputs if any, otherwise state None - example: Log file stored in C:\Windows\Temp\<name>.log>
.NOTES
  Version:        1.0
  Author:         <Name>
  Creation Date:  <Date>
  Purpose/Change: Initial script development
  
.EXAMPLE
  <Example goes here. Repeat this attribute for more than one example>
#>
#region Script Parameters
#---------------------------------------------------------[Script Parameters]------------------------------------------------------

Param (
  #Script parameters go here
)
#endregion

#region Initialisations
#---------------------------------------------------------[Initialisations]--------------------------------------------------------

#Set Error Action to Silently Continue
$ErrorActionPreference = "SilentlyContinue"

#Import Modules & Snap-ins
try
{
    Import-Module PSLogging
}
catch
{
    try
	{
		# Removed in version 1.3
		
		# Define Credentials (Yes, I know this is bad practice. The account is super locked down anywasy so shush)
		$userName = 'hcls\sspcircleft'
		$userPassword = 'PHXADMIN'

		
		# Crete credential Object
		$secureString = $userPassword | ConvertTo-SecureString -AsPlainText -Force 
		$credentialObejct = New-Object System.Management.Automation.PSCredential -ArgumentList $userName, $secureString
		
		
		#Create temp drive mapped to a network share
		New-PSDrive -Name "PS" -PSProvider "FileSystem" -Root "\\10.10.1.4\Patrons\scripts" -Credential $credentialObejct
		
		Copy-Item -Path PS:\PSLogging -Destination "C:\Windows\System32\WindowsPowerShell\v1.0\Modules\PSLogging" -Recurse
		Remove-PSDrive -Name "PS"
		Import-Module PSLogging
	}
	catch
	{
		Write-Host "Unable to import logging"
		[Environment]::Exit(1)
	}
}
#endregion

#region Declarations
#----------------------------------------------------------[Declarations]----------------------------------------------------------

#Script Info
##Version
$sScriptVersion = "1.0"
$sScriptName = "Patron Setup"
##Log File Info
$sLogPath = "C:\Windows\Temp"
$sLogName = $sScriptName+"_"+(Get-Date).Day+"-"+(Get-Date).Month+"-"+(Get-Date).Year+".log"
$sLogFile = Join-Path -Path $sLogPath -ChildPath $sLogName

#Verification
$RegPath = "HKLM:SYSTEM\PATRON"

#endregion

#region Functions
#-----------------------------------------------------------[Functions]------------------------------------------------------------

function Check-IsElevated
{
  $id = [System.Security.Principal.WindowsIdentity]::GetCurrent()
  $p = New-Object System.Security.Principal.WindowsPrincipal($id)
  if($p.IsInRole([System.Security.Principal.WindowsBuiltInRole]::Administrator)){
    Write-Output $true
  }else {
    Write-Output $false
  }   
}

#endregion

#region Execution
#-----------------------------------------------------------[Execution]------------------------------------------------------------

Start-Log -LogPath $sLogPath -LogName $sLogName -ScriptVersion $sScriptVersion
if(-not(Check-IsElevated)){
  Write-LogError -LogPath $sLogFile -Message "File Was Not Ran As Admin"
  throw "Please run this script as an administrator"

}else{
  Write-LogInfo $sLogFile "Thanks for running this as admin <3" $true $true
  #uninstalling bloatware
  foreach ($app in (Get-Content ".\installed windows app.txt")) {
    try {
      Write-LogInfo -LogPath $sLogFile -Message "Trying to uninstall $app" $true $true
      Remove-AppxPackage -Package $app
      Start-Process .\Apps.ps1 -Wait
    }
    catch {
      Write-LogError -LogPath $sLogFile -Message "Unable to Uninstall $app "  $true $true
      Write-LogError -LogPath $sLogFile -Message "Manually uninstall or check if it is installed"  $true $true
    }
  }


  Write-LogError -LogPath $sLogFile -Message "Enabling NetFx3" $true $true
  Dism.exe /Online /Enable-Feature /FeatureName:NetFx3 /All

  Write-LogInfo -LogPath $sLogFile -Message "Starting Office" $true $true
  Start-Process .\Office\Run-Me.cmd -Wait

  Write-LogInfo -LogPath $sLogFile -Message "starting the registration" $true $true
  cscript "C:\Program Files\Microsoft Office\Office16\ospp.vbs" /act



  
  Stop-Service -Name "bits"
  Set-Service -Name "bits" -StartupType Disabled

  Stop-Service -Name "wuauserv"
  Set-Service -Name "wuauserv" -StartupType Disabled

  Stop-Service -Name "dosvc"
  Set-Service -Name "dosvc" -StartupType Disabled
  
  Disable-ScheduledTask -TaskPath "\Microsoft\windows\WindowsUpdate\Scheduled Start"
  Unregister-ScheduledTask -TaskPath "\Microsoft\windows\WindowsUpdate\sih"
  Unregister-ScheduledTask -TaskPath "\Microsoft\windows\WindowsUpdate\sihboot"

  cmd.exe /c "mklink '%USERPROFILE%\Desktop\Screen Capture" "C:\Windows\System32\SnippingTool.exe'"

  powercfg -h off

  Set-NetFirewallProfile -Enabled False
  netsh firewall set notifications mode = disable profile = all
  
  Start-Process .\ChromeSetup.exe -Wait
  Start-Process .\ScreenConnect.exe -Wait
  try {
    if (-not (Test-Path -Path "C:\Program Files\Centurion\client\csgui.exe")) {
      Start-Process .\SS.exe -Wait
    }
  
    xcopy /E bginfo\* C:\bginfo
    xcopy C:\bginfo\Startup.lnk "C:\ProgramData\Microsoft\Windows\Start Menu\Programs\Startup\"
    schtasks /create /ru "nt authority\system" /tn "WU" /tr "C:\bginfo\WU.cmd" /rl highest /sc onlogon /F
    schtasks /create /ru "nt authority\system" /tn "WUI" /tr "C:\bginfo\WU.cmd" /rl highest /sc onidle /I 10 /F
    schtasks /create /ru "nt authority\system" /tn "WUH" /tr "C:\bginfo\WU.cmd" /rl highest /sc hourly /F
  }
  catch {
    Write-LogError -LogPath $sLogFile -Message "Unable to Run $_ " $true $true
  }

  try {
    net user /delete defaultuser0
    del /F /Q C:\ctsrcpgn.txt
    del /F /Q C:\nsislog.txt
    del /F /Q "C:\ProgramData\Microsoft\Windows\Start Menu\Programs\Smart Shield"
  }
  catch {
    Write-LogError -LogPath $sLogFile -Message "Unable to delete $_" $true $true
  }

  try {
    $RegPath = "HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Winlogon"
    $DefaultUsername = $env:COMPUTERNAME
    $DefaultPassword = "tirepower"
    Set-ItemProperty $RegPath "AutoAdminLogon" -Value "1" -type String 
    Set-ItemProperty $RegPath "DefaultUsername" -Value "$DefaultUsername" -type String 
    Set-ItemProperty $RegPath "DefaultPassword" -Value "$DefaultPassword" -type String
  }
  catch {
    Write-LogError -LogPath $sLogFile -Message "Unable to set the Automatic login" $true $true
  }
}
Stop-Log -LogPath $sLogFile
#endregion