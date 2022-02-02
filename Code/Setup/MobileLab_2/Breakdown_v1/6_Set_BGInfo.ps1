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
$sLogName = "4_Set_BGInfo.log"
$sLogFile = Join-Path -Path $sLogPath -ChildPath $sLogName
#endregion

#region Execution
#-----------------------------------------------------------[Execution]------------------------------------------------------------

Start-Log -LogPath $sLogPath -LogName $sLogName -ScriptVersion $sScriptVersion

xcopy /E ..\bginfo\* C:\bginfo

xcopy C:\bginfo\Startup.lnk "C:\ProgramData\Microsoft\Windows\Start Menu\Programs\Startup\"

schtasks /create /ru "nt authority\system" /tn "WU" /tr "C:\bginfo\WU.cmd" /rl highest /sc onlogon /F

schtasks /create /ru "nt authority\system" /tn "WUI" /tr "C:\bginfo\WU.cmd" /rl highest /sc onidle /I 10 /F

schtasks /create /ru "nt authority\system" /tn "WUH" /tr "C:\bginfo\WU.cmd" /rl highest /sc hourly /F

Stop-Log -LogPath $sLogFile
#endregion