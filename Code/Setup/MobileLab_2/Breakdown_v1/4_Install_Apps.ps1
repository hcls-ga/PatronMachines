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

[CmdletBinding()]

Param (
  [Parameter(Mandatory=$true,Position=0)][string]$LogPath,
  [Parameter(Mandatory=$true,Position=1)][string]$LogName
)

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
$sLogName = "4_Insatll_Apps.log"
$sLogFile = Join-Path -Path $sLogPath -ChildPath $sLogName
#endregion

#region Execution
#-----------------------------------------------------------[Execution]------------------------------------------------------------

Start-Log -LogPath $sLogPath -LogName $sLogName -ScriptVersion $sScriptVersion

Start-Process .\ChromeSetup.exe -Wait -Verbose >> $sLogFile

Start-Process .\ScreenConnect.exe -Wait -Verbose >> $sLogFile

Start-Process .\SS.exe -Wait -Verbose >> $sLogFile

Stop-Log -LogPath $sLogFile
#endregion