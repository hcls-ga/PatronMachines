
function Verify-Chrome {
    $ChromeLoc1 = 'C:\Program Files\Google\Chrome\Application\chrome.exe'
    $ChromeLoc2 = 'C:\Program Files (x86)\Google\Chrome\Application\chrome.exe'
    $ChromeLoc3 = '%LocalAppData%\Google\Chrome\Application\chrome.exe'
    
    if ((Test-Path -Path $ChromeLoc1 -PathType Leaf) -or (Test-Path -Path $ChromeLoc2 -PathType Leaf) -or (Test-Path -Path $ChromeLoc13 -PathType Leaf)) {
        return $true
    }
    else {
        return $false
    }
}

function Verify-SS {
    $SSLoc = 'C:\Program Files\Centurion Technologies\Client\ctsrgui.exe'
    
    if ((Test-Path -Path $SSLoc1 -PathType Leaf)) {
        return $true
    }
    else {
        return $false
    }
}

function Verify-SC {
    $SCLoc = 'C:\Program Files (x86)\ScreenConnect Client *\ScreenConnect.WindowsClient.exe'
    
    if ((Test-Path -Path $SCLoc -PathType Leaf)) {
        return $true
    }
    else {
        return $false
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
        Position = 2,
        HelpMessage='Whether to install Screen Connect')]
        [bool] 
        $SC = $true,

        [Parameter(Mandatory=$false,
        Position = 4,
        HelpMessage='Whether to install Smart Sheild')] 
        [bool] 
        $SS = $true,

        [Parameter(Mandatory=$false,
        Position = 6,
        HelpMessage='Whether to install Office')] 
        [bool] 
        $Office = $true,

        [Parameter(Mandatory=$false,
        Position = 8,
        HelpMessage='This option only installs what isnt already installed')] 
        [bool] 
        $Auto = $true
    )
    begin{
        if ($Auto) {
            Write-Host "Running Installs Automatically"
            $Chrome = !(Verify-Chrome)
            Write-Host "Installing Chrome: $Chrome"
            $SC = !(Verify-SC)
            Write-Host "Installing ScreenConnect: $SC"
            $SS = !(Verify-SS)
            Write-Host "Installing SmartSheild: $SS"
        }
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
        if ($Office -eq $true) {
            try {
                Start-Process .\Office\Run-Me.cmd -Wait
            }
            catch {
                Write-LogError -LogPath $sLogFile -Message "Unable to install Office" $true $true
            }
        }
    }
    
}

Install-Apps