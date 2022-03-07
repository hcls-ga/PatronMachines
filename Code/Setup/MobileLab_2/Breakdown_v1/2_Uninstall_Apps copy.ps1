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
$sLogName = "2_Uninstall_Apps.log"
$sLogFile = Join-Path -Path $sLogPath -ChildPath $sLogName
#endregion

#region Execution
#-----------------------------------------------------------[Execution]------------------------------------------------------------

Start-Log -LogPath $sLogPath -LogName $sLogName -ScriptVersion $sScriptVersion
foreach ($app in (Get-Content "..\installed windows app.txt")) {
  try {
    Write-LogInfo -LogPath $sLogFile -Message "Trying to uninstall $app" $true $true
    Remove-AppxPackage -Package $app -Verbose >> $sLogFile
    Start-Process ..\Apps.ps1 -Wait
  }
  catch {
    Write-LogError -LogPath $sLogFile -Message "Unable to Uninstall $app "  $true $true
    Write-LogError -LogPath $sLogFile -Message "Manually uninstall or check if it is installed"  $true $true
  }
}
Stop-Log -LogPath $sLogFile
#endregion