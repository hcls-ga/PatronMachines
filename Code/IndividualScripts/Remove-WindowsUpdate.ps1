function Verify-DisableWU {
    if ( (Get-Service -Name 'bits' | Select StartType ).StartType -eq 'Disabled') {
        return $true
    }
    return $false
}

function Remove-WindowsUpdate {

    [CmdletBinding()]
    param (
        [Parameter(Mandatory=$false,Position=0)] [bool] $Auto = $ture
    )

    if ($Auto) {
        if ( (!Verify-DisableWU) ) {
            Remove-WindowsUpdate
        }
    }else{
        Stop-Service -Name "bits"
        Set-Service -Name "bits" -StartupType Disabled

        Stop-Service -Name "wuauserv"
        Set-Service -Name "wuauserv" -StartupType Disabled

        Stop-Service -Name "dosvc"
        Set-Service -Name "dosvc" -StartupType Disabled
    }
    
}

Remove-WindowsUpdate