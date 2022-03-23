function Install-Desktop {
    if ( -not (Verify-DesktopInstall)) {
        xcopy /E bginfo\* C:\bginfo
        xcopy C:\bginfo\Startup.lnk "C:\ProgramData\Microsoft\Windows\Start Menu\Programs\Startup\"
        schtasks /create /ru "nt authority\system" /tn "WU" /tr "C:\bginfo\WU.cmd" /rl highest /sc onlogon /F
        schtasks /create /ru "nt authority\system" /tn "WUI" /tr "C:\bginfo\WU.cmd" /rl highest /sc onidle /I 10 /F
        schtasks /create /ru "nt authority\system" /tn "WUH" /tr "C:\bginfo\WU.cmd" /rl highest /sc hourly /F
    }    
}

function Verify-DesktopInstall {
    Test-Path -Path C:\bginfo
}

function Install-AutoLogin {

    [CmdletBinding()]
    param (
        [Parameter(Mandatory=$false,Position=0)] [string] $UserName = $env:COMPUTERNAME,
        [Parameter(Mandatory=$false,Position=1)] [string] $Password = 'tirepower'
    )
    
    $RegPath = "HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Winlogon"
    Set-ItemProperty $RegPath "AutoAdminLogon" -Value "1" -type String 
    Set-ItemProperty $RegPath "DefaultUsername" -Value $Username -type String 
    Set-ItemProperty $RegPath "DefaultPassword" -Value "$Password" -type String

}
Install-Desktop
Install-AutoLogin
