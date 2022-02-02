# =========================================================================================================
# if you like to reset your DPI Scaling to the DEFAULT, you can use the registry (Option five) from here:
# https://www.tenforums.com/tutorials/5990-change-dpi-scaling-level-displays-windows-10-a.html#option5
#
# But, since the default value is different on various monitors, if you like to force 100%,
# you need the following trick:
# for each monitor - set DPIValue to 0xFFFFFFFF (which is -1 in DWord)
#
# Last update: 18 December 2018
# Created by: Itsho
# =========================================================================================================


# -1 == 0xFFFFFFFF in DWord == 100% DPI scaling
# 0 = default setting of the screen (can be 125%!)
# 1 = default settings + 1
# 2 = default settings + 2
$dpiValue = -1

$activeMonitorsRegPath = "HKCU:\Control Panel\Desktop\PerMonitorSettings"
$genericMonitorsList = Get-ChildItem HKLM:\System\CurrentControlSet\Control\GraphicsDrivers\ScaleFactors

Write-Host( [string]::Format("Found {0} ScaleFactors monitors", $genericMonitorsList.Length));

foreach ($genericMonitor in $genericMonitorsList) {

  $tempRegPath = $activeMonitorsRegPath + '\' + $genericMonitor.PsChildname;

  # if registry KEY already exists
  if (Test-Path -Path $tempRegPath) {

    Write-Host('Updating value for monitor - ' + $genericMonitor.PsChildname)

    # update existing-item DPI's value
    Set-ItemProperty -Path $tempRegPath -Name 'DpiValue' -Value $dpiValue –Force 

	} else {

    Write-Host('Creating new key and value for monitor - ' + $genericMonitor.PsChildname)

    # create new key under PerMonitorSettings
    New-Item -Path $activeMonitorsRegPath -Name $genericMonitor.PsChildname –Force | Out-Null

    # create new value
    New-ItemProperty  -Path $tempRegPath -Name 'DpiValue' -PropertyType DWord -Value $dpiValue –Force  | Out-Null
	}
}

# Notice - disposing registry objects is mandatory when loading hive of a different user. 
# otherwise you won't be able to unload the hive...
$genericMonitorsList.Close();
$genericMonitorsList = $null;