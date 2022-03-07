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

Write-LogInfo -LogPath $sLogFile -Message "Enabling NetFx3" $true $true
Dism.exe /Online /Enable-Feature /FeatureName:NetFx3 /All -Verbose >> $sLogFile

Write-LogInfo -LogPath $sLogFile -Message "Starting Office" $true $true
Start-Process .\Office\Run-Me.cmd -Wait -Verbose >> $sLogFile

Write-LogInfo -LogPath $sLogFile -Message "starting the registration" $true $true
cscript "C:\Program Files\Microsoft Office\Office16\ospp.vbs" /act -Verbose >> $sLogFile



Write-LogInfo -LogPath $sLogFile -Message "Enabling NetFx3" $true $true
Stop-Service -Name "bits" -Verbose >> $sLogFile
Set-Service -Name "bits" -StartupType Disabled -Verbose >> $sLogFile

Write-LogInfo -LogPath $sLogFile -Message "Enabling NetFx3" $true $true
Stop-Service -Name "wuauserv" -Verbose >> $sLogFile
Set-Service -Name "wuauserv" -StartupType Disabled -Verbose >> $sLogFile

Write-LogInfo -LogPath $sLogFile -Message "Enabling NetFx3" $true $true
Stop-Service -Name "dosvc" -Verbose >> $sLogFile
Set-Service -Name "dosvc" -StartupType Disabled -Verbose >> $sLogFile

Write-LogInfo -LogPath $sLogFile -Message "Enabling NetFx3" $true $true
Disable-ScheduledTask -TaskPath "\Microsoft\windows\WindowsUpdate\Scheduled Start" -Verbose >> $sLogFile
Unregister-ScheduledTask -TaskPath "\Microsoft\windows\WindowsUpdate\sih" -Verbose >> $sLogFile
Unregister-ScheduledTask -TaskPath "\Microsoft\windows\WindowsUpdate\sihboot" -Verbose >> $sLogFile

Write-LogInfo -LogPath $sLogFile -Message "Enabling NetFx3" $true $true
cmd.exe /c "mklink '%USERPROFILE%\Desktop\Screen Capture" "C:\Windows\System32\SnippingTool.exe'" -Verbose >> $sLogFile

Write-LogInfo -LogPath $sLogFile -Message "Enabling NetFx3" $true $true
powercfg -h off -Verbose >> $sLogFile

Write-LogInfo -LogPath $sLogFile -Message "Enabling NetFx3" $true $true
Set-NetFirewallProfile -Enabled False -Verbose >> $sLogFile
netsh firewall set notifications mode = disable profile = all -Verbose >> $sLogFile
  
Stop-Log -LogPath $sLogFile
#endregion