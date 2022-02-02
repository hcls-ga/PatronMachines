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
#region Execution
#-----------------------------------------------------------[Execution]------------------------------------------------------------

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