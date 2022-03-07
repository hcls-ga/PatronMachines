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
		.\1_Install_PSL.ps1
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
$sScriptName = "Patron_Setup"
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
  Write-LogInfo $sLogFile "Unistalling Apps" $true $true
  try {
    .\2_Uninstall_Apps.ps1
  }
  catch {
    Write-LogError -LogPath $sLogFile -Message "Unable to Run $_ " $true $true
  }
  
  #Set Configuration
  Write-LogInfo $sLogFile "Setting Configurations" $true $true
  try {
    .\3_Set_Configs.ps1
  }
  catch {
    Write-LogError -LogPath $sLogFile -Message "Unable to Run $_ " $true $true
  }

#Installing aoolications
Write-LogInfo $sLogFile "Installing Appilications" $true $true
  try {
    .\4_Insatll_Apps.ps1
  }
  catch {
    Write-LogError -LogPath $sLogFile -Message "Unable to Run $_ " $true $true
  }

  #Setting auto-login
  Write-LogInfo $sLogFile "Setting Auto-login" $true $true
  try {
    .\5_Set_AutoLogin.ps1
  }
  catch {
    Write-LogError -LogPath $sLogFile -Message "Unable to Run $_ " $true $true
  }

  #Setup BGInfo
  Write-LogInfo $sLogFile "Setting up BGInfo" $true $true
  try {
    .\6_Set_BGInfo.ps1
  }
  catch {
    Write-LogError -LogPath $sLogFile -Message "Unable to Run $_ " $true $true
  }

  #Cleaning Up
  Write-LogInfo $sLogFile "Cleaning up" $true $true
  try {
    .\7_Clean_All.ps1
  }
  catch {
    Write-LogError -LogPath $sLogFile -Message "Unable to Run $_ " $true $true
  }
}
Stop-Log -LogPath $sLogFile
#endregion