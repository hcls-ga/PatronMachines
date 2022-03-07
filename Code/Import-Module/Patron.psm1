###
# Author: Dylan Young
###

Set-StrictMode -Version Latest

#Finish this script
function List-Apps {
    <#
    .SYNOPSIS
    

    .DESCRIPTION
    

    .PARAMETER LogPath
    

    .PARAMETER LogName
    

    .PARAMETER ParameterName

    .INPUTS
    

    .OUTPUTS

    .NOTES
    Version:        1.0
    Author:         Dylan Young
    Creation Date:  
    Purpose/Change: 

    .EXAMPLE
    
    
    #>
    [CmdletBinding()]
    param (
        [Parameter(Mandatory=$false,Position=0)] [string] $AppType
    )

    Process {
        if ($AppType -eq "All") {
            Get-AppxPackage | Select Name, InstallLocation
        }
    }
}

function Remove-Apps {
<#
.SYNOPSIS
    Remove built-in apps (modern apps) from Windows 10.

.DESCRIPTION
    This script will remove all built-in apps with a provisioning package that's not specified in the 'white-list' in this script.
    It supports MDT and ConfigMgr usage, but only for online scenarios, meaning it can't be executed during the WinPE phase.
    For a more detailed list of applications available in each version of Windows 10, refer to the documentation here:
    https://docs.microsoft.com/en-us/windows/application-management/apps-in-windows-10

.NOTES
    Version: 1.0.0
    Author:      Dylan
    Created:     2022-03-07
    Version history:
    1.0.0 - (2019-03-10) Initial script

    .EXAMPLE
    .\Invoke-RemoveBuiltinApps.ps1
    
#>
Begin {
    # White list of Features On Demand V2 packages
    $WhiteListOnDemand = "NetFX3|DirectX|Tools.DeveloperMode.Core|Language|InternetExplorer|ContactSupport|OneCoreUAP|WindowsMediaPlayer|Hello.Face|Notepad|MSPaint|PowerShell.ISE|ShellComponents"

    # White list of appx packages to keep installed
    $WhiteListedApps = New-Object -TypeName System.Collections.ArrayList
    $WhiteListedApps.AddRange(@(
        "Microsoft.DesktopAppInstaller",
        "Microsoft.Messaging", 
        "Microsoft.MSPaint",
        "Microsoft.Windows.Photos",
        "Microsoft.StorePurchaseApp",
        "Microsoft.MicrosoftStickyNotes",
        "Microsoft.WindowsAlarms",
        "Microsoft.WindowsCalculator", 
        "Microsoft.WindowsCommunicationsApps", # Mail, Calendar etc
        "Microsoft.WindowsSoundRecorder", 
        "Microsoft.WindowsStore"
    ))

    # Windows 10 version 1809
    $WhiteListedApps.AddRange(@(
        "Microsoft.ScreenSketch",
        "Microsoft.HEIFImageExtension",
        "Microsoft.VP9VideoExtensions",
        "Microsoft.WebMediaExtensions",
        "Microsoft.WebpImageExtension"
    ))

    # Windows 10 version 1903
    # No new apps

    # Windows 10 version 1909
    # No New Apps

    # Windows 10 version 2004
    $WhiteListedApps.AddRange(@(
        "Microsoft.VCLibs.140.00"
    ))

    # Windows 10 version 20H2
    $WhiteListedApps.AddRange(@(
        "Microsoft.MicrosoftEdge.Stable"
    ))
}
Process {
    # Functions - Replace with PSLogging but keep file name
    function Write-LogEntry {
        param(
            [parameter(Mandatory=$true, HelpMessage="Value added to the RemovedApps.log file.")]
            [ValidateNotNullOrEmpty()]
            [string]$Value,

            [parameter(Mandatory=$false, HelpMessage="Name of the log file that the entry will written to.")]
            [ValidateNotNullOrEmpty()]
            [string]$FileName = "RemovedApps.log"
        )
        # Determine log file location
        $LogFilePath = Join-Path -Path $env:windir -ChildPath "Temp\$($FileName)"

        # Add value to log file
        try {
            Out-File -InputObject $Value -Append -NoClobber -Encoding Default -FilePath $LogFilePath -ErrorAction Stop
        }
        catch [System.Exception] {
            Write-Warning -Message "Unable to append log entry to $($FileName) file"
        }
    }

    # Initial logging
    Write-LogEntry -Value "Starting built-in AppxPackage, AppxProvisioningPackage and Feature on Demand V2 removal process"

    # Determine provisioned apps
    $AppArrayList = Get-AppxProvisionedPackage -Online | Select-Object -ExpandProperty DisplayName

    # Loop through the list of appx packages
    foreach ($App in $AppArrayList) {
        Write-LogEntry -Value "Processing appx package: $($App)"

        # If application name not in appx package white list, remove AppxPackage and AppxProvisioningPackage
        if (($App -in $WhiteListedApps)) {
            Write-LogEntry -Value "Skipping excluded application package: $($App)"
        }
        else {
            # Gather package names
            $AppPackageFullName = Get-AppxPackage -Name $App | Select-Object -ExpandProperty PackageFullName -First 1
            $AppProvisioningPackageName = Get-AppxProvisionedPackage -Online | Where-Object { $_.DisplayName -like $App } | Select-Object -ExpandProperty PackageName -First 1

            # Attempt to remove AppxPackage
            if ($AppPackageFullName -ne $null) {
                try {
                    Write-LogEntry -Value "Removing AppxPackage: $($AppPackageFullName)"
                    Remove-AppxPackage -Package $AppPackageFullName -ErrorAction Stop | Out-Null
                }
                catch [System.Exception] {
                    Write-LogEntry -Value "Removing AppxPackage '$($AppPackageFullName)' failed: $($_.Exception.Message)"
                }
            }
            else {
                Write-LogEntry -Value "Unable to locate AppxPackage for current app: $($App)"
            }

            # Attempt to remove AppxProvisioningPackage
            if ($AppProvisioningPackageName -ne $null) {
                try {
                    Write-LogEntry -Value "Removing AppxProvisioningPackage: $($AppProvisioningPackageName)"
                    Remove-AppxProvisionedPackage -PackageName $AppProvisioningPackageName -Online -ErrorAction Stop | Out-Null
                }
                catch [System.Exception] {
                    Write-LogEntry -Value "Removing AppxProvisioningPackage '$($AppProvisioningPackageName)' failed: $($_.Exception.Message)"
                }
            }
            else {
                Write-LogEntry -Value "Unable to locate AppxProvisioningPackage for current app: $($App)"
            }
        }
    }

    Write-LogEntry -Value "Starting Features on Demand V2 removal process"

    # Get Features On Demand that should be removed
    try {
        $OSBuildNumber = Get-WmiObject -Class "Win32_OperatingSystem" | Select-Object -ExpandProperty BuildNumber

        # Handle cmdlet limitations for older OS builds
        if ($OSBuildNumber -le "16299") {
            $OnDemandFeatures = Get-WindowsCapability -Online -ErrorAction Stop | Where-Object { $_.Name -notmatch $WhiteListOnDemand -and $_.State -like "Installed" } | Select-Object -ExpandProperty Name
        }
        else {
            $OnDemandFeatures = Get-WindowsCapability -Online -LimitAccess -ErrorAction Stop | Where-Object { $_.Name -notmatch $WhiteListOnDemand -and $_.State -like "Installed" } | Select-Object -ExpandProperty Name
        }

        foreach ($Feature in $OnDemandFeatures) {
            try {
                Write-LogEntry -Value "Removing Feature on Demand V2 package: $($Feature)"

                # Handle cmdlet limitations for older OS builds
                if ($OSBuildNumber -le "16299") {
                    Get-WindowsCapability -Online -ErrorAction Stop | Where-Object { $_.Name -like $Feature } | Remove-WindowsCapability -Online -ErrorAction Stop | Out-Null
                }
                else {
                    Get-WindowsCapability -Online -LimitAccess -ErrorAction Stop | Where-Object { $_.Name -like $Feature } | Remove-WindowsCapability -Online -ErrorAction Stop | Out-Null
                }
            }
            catch [System.Exception] {
                Write-LogEntry -Value "Removing Feature on Demand V2 package failed: $($_.Exception.Message)"
            }
        }    
    }
    catch [System.Exception] {
        Write-LogEntry -Value "Attempting to list Feature on Demand V2 packages failed: $($_.Exception.Message)"
    }

    # Complete
    Write-LogEntry -Value "Completed built-in AppxPackage, AppxProvisioningPackage and Feature on Demand V2 removal process"
}
}

function Install-Apps {

    [CmdletBinding()]
    param (
        [Parameter(Mandatory=$false,
        Position = 0,
        HelpMessage='Whether to install Chrome')]
        [bool] 
        $Chrome = $true,

        [Parameter(Mandatory=$false,
        Position = 1,
        HelpMessage='Location of the Chrome Installer')] 
        [ValidateScript({
            if ( -Not ($_ | Test-Path -PathType Leaf) ) {
                throw "File $_ does not exist"
            }
            return $true
        })]
        [System.IO.FileInfo] 
        $ChromeLoc = '.\ChromeSetup.exe',

        [Parameter(Mandatory=$false,
        Position = 2,
        HelpMessage='Whether to install Screen Connect')]
        [bool] 
        $SC = $true,

        [Parameter(Mandatory=$false,
        Position = 3,
        HelpMessage='Location of the Chrome Installer')] 
        [ValidateScript({
            if ( -Not ($_ | Test-Path -PathType Leaf) ) {
                throw "File $_ does not exist"
            }
            return $true
        })]
        [System.IO.FileInfo] 
        $SCLoc = '.\ScreenConnect.exe',

        [Parameter(Mandatory=$false,
        Position = 4,
        HelpMessage='Whether to install Smart Sheild')] 
        [bool] 
        $SS = $true,

        [Parameter(Mandatory=$false,
        Position = 5,
        HelpMessage='Location of the Chrome Installer')] 
        [ValidateScript({
            if ( -Not ($_ | Test-Path -PathType Leaf) ) {
                throw "File $_ does not exist"
            }
            return $true
        })]
        [System.IO.FileInfo] 
        $SSLoc = '.\SS.exe',

        [Parameter(Mandatory=$false,
        Position = 6,
        HelpMessage='Whether to install Office')] 
        [bool] 
        $Office = $true,

        [Parameter(Mandatory=$false,
        Position = 7,
        HelpMessage='Location of the Chrome Installer')] 
        [ValidateScript({
            if ( -Not ($_ | Test-Path -PathType Leaf) ) {
                throw "File $_ does not exist"
            }
            return $true
        })]
        [System.IO.FileInfo] 
        $OfficeLoc = '.\Office\Run-Me.cmd'
    )
    begin{

    }
    process{
        if ($Chrome -eq $true) {
            try {
                Start-Process .\ChromeSetup.exe -Wait
            }
            catch {
                Write-LogError -LogPath $sLogFile -Message "Unable to install Chrome" $true $true
            }
        }
    
        if ($SC -eq $true) {
            try {
                Start-Process .\ScreenConnect.exe -Wait
            }
            catch {
                Write-LogError -LogPath $sLogFile -Message "Unable to install Screen Connect" $true $true
            }
        }
        if ($SS -eq $true) {
            try {
                Start-Process .\SS.exe -Wait
            }
            catch {
                Write-LogError -LogPath $sLogFile -Message "Unable to install Smart Sheild" $true $true
            }
        }
        if ($Chrome -eq $true) {
            try {
                Start-Process .\Office\Run-Me.cmd -Wait
            }
            catch {
                Write-LogError -LogPath $sLogFile -Message "Unable to install Office" $true $true
            }
        }
    }
    
}

function Verify-WindowsUpdate {
    if ( (Get-Service -Name 'bits' | Select StartType ).StartType -eq 'Disabled') {
        return $false
    }
    return $true
}

function Remove-WindowsUpdate {

    [CmdletBinding()]
    param (
        [Parameter(Mandatory=$false,Position=0)] [bool] $DisableSchTasks = $false #add this later
    )

    if (Verify-WindowsUpdateDisabled) {
        Stop-Service -Name "bits"
        Set-Service -Name "bits" -StartupType Disabled

        Stop-Service -Name "wuauserv"
        Set-Service -Name "wuauserv" -StartupType Disabled

        Stop-Service -Name "dosvc"
        Set-Service -Name "dosvc" -StartupType Disabled
    }
    
}

function Install-Desktop {
    if ( -not (Test-Path -Path C:\bginfo)) {
        xcopy /E bginfo\* C:\bginfo
        xcopy C:\bginfo\Startup.lnk "C:\ProgramData\Microsoft\Windows\Start Menu\Programs\Startup\"
        schtasks /create /ru "nt authority\system" /tn "WU" /tr "C:\bginfo\WU.cmd" /rl highest /sc onlogon /F
        schtasks /create /ru "nt authority\system" /tn "WUI" /tr "C:\bginfo\WU.cmd" /rl highest /sc onidle /I 10 /F
        schtasks /create /ru "nt authority\system" /tn "WUH" /tr "C:\bginfo\WU.cmd" /rl highest /sc hourly /F
    }    
}

function Install-AutoLogin {

    [CmdletBinding()]
    param (
        [Parameter(Mandatory=$false,Position=0)] [bool] $UserName = $env:COMPUTERNAME,
        [Parameter(Mandatory=$false,Position=0)] [bool] $Password = 'tirepower'
    )
    
    $RegPath = "HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Winlogon"
    Set-ItemProperty $RegPath "AutoAdminLogon" -Value "1" -type String 
    Set-ItemProperty $RegPath "DefaultUsername" -Value "$DefaultUsername" -type String 
    Set-ItemProperty $RegPath "DefaultPassword" -Value "$DefaultPassword" -type String

}