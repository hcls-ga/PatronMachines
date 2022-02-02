Get-AppxPackage *4DF9E0F8.Netflix* | Remove-AppxPackage
Get-AppxPackage *5A894077.McAfeeSecurity * | Remove-AppxPackage
Get-AppxPackage *C27EB4BA.DropboxOEM* | Remove-AppxPackage
Get-AppxPackage *DellInc.* | Remove-AppxPackage
Get-AppxPackage *BingWeather* | Remove-AppxPackage
Get-AppxPackage *Messaging* | Remove-AppxPackage
Get-AppxPackage *MicrosoftOfficeHub* | Remove-AppxPackage
Get-AppxPackage *MicrosoftSolitaireCollection* | Remove-AppxPackage
Get-AppxPackage *MicrosoftStickyNotes* | Remove-AppxPackage
Get-AppxPackage *MixedReality.Portal* | Remove-AppxPackage
Get-AppxPackage *Office.OneNote* | Remove-AppxPackage
Get-AppxPackage *OneConnect* | Remove-AppxPackage
Get-AppxPackage *People* | Remove-AppxPackage
Get-AppxPackage *Print3D* | Remove-AppxPackage
Get-AppxPackage *ScreenSketch* | Remove-AppxPackage
Get-AppxPackage *SkypeApp* | Remove-AppxPackage
Get-AppxPackage *Wallet* | Remove-AppxPackage
Get-AppxPackage *WindowsAlarms* | Remove-AppxPackage
Get-AppxPackage *WindowsCommunicationsApp* | Remove-AppxPackage
Get-AppxPackage *WindowsFeedbackHub* | Remove-AppxPackage
Get-AppxPackage *WindowsMaps* | Remove-AppxPackage
Get-AppxPackage *Xbox* | Remove-AppxPackage
Get-AppxPackage *YourPhone* | Remove-AppxPackage
Get-AppxPackage *Zune* | Remove-AppxPackage
Get-AppxPackage *KillerControlCenter* | Remove-AppxPackage
Get-AppxPackage *DellMobileConnect* | Remove-AppxPackage
Get-AppxPackage *GetStarted* | Remove-AppxPackage
Get-AppxPackage *GetHelp* | Remove-AppxPackage
Get-AppxPackage *RemoteDesktop* | Remove-AppxPackage

(Get-WmiObject -Query "SELECT * From Win32_Product WHERE Name Like 'Office 16 Click-to-Run Extensibility Component'").uninstall()
(Get-WmiObject -Query "SELECT * From Win32_Product WHERE Name Like 'Office 16 Click-to-Run Localization Component'").uninstall()
(Get-WmiObject -Query "SELECT * From Win32_Product WHERE Name Like 'Office 16 Click-to-Run Licensing Component'").uninstall()
(Get-WmiObject -Query "SELECT * From Win32_Product WHERE Name Like 'Dell SupportAssist Remediation'").uninstall()
(Get-WmiObject -Query "SELECT * From Win32_Product WHERE Name Like 'Dell Digital Delivery Services'").uninstall()
(Get-WmiObject -Query "SELECT * From Win32_Product WHERE Name Like 'Dell Power Manager Service'").uninstall()
(Get-WmiObject -Query "SELECT * From Win32_Product WHERE Name Like 'Dell Update - SupportAssist Update Plugin'").uninstall()
(Get-WmiObject -Query "SELECT * From Win32_Product WHERE Name Like 'Dell Update for Windows 10'").uninstall()
(Get-WmiObject -Query "SELECT * From Win32_Product WHERE Name Like 'Dell Mobile Connect Drivers'").uninstall()

Remove-Item -path C:\Dell -Recurse -Force
Remove-Item -path C:\Drivers -Recurse -Force
Remove-Item -path C:\Apps -Recurse -Force
Remove-Item -path "C:\Program File\Dell" -Recurse -

exit
