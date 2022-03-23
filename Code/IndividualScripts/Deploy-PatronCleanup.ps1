function Deploy-PatronCleanUp {

    [CmdletBinding()]
    param (
        [Parameter(Mandatory=$false,Position=0)] [ParameterType] $all = $true
    )
    
    if ($all) {
        net user /delete defaultuser0
        del /F /Q C:\ctsrcpgn.txt
        del /F /Q C:\nsislog.txt
        del /F /Q "C:\ProgramData\Microsoft\Windows\Start Menu\Programs\Smart Shield"
    }


}
Deploy-PatronCleanUp