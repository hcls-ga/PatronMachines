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
Import-Module PSLogging
#endregion

#region Declarations
#----------------------------------------------------------[Declarations]----------------------------------------------------------

#Script Version
$sScriptVersion = "1.0"

#Log File Info
$sLogPath = "C:\Windows\Temp"
$sLogName = "3_Set_Configs.log"
$sLogFile = Join-Path -Path $sLogPath -ChildPath $sLogName
#endregion

#region Execution
#-----------------------------------------------------------[Execution]------------------------------------------------------------

Start-Log -LogPath $sLogPath -LogName $sLogName -ScriptVersion $sScriptVersion

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
  
Stop-Log -LogPath $sLogFile
#endregion