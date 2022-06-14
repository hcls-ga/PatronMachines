# PatronMachines
Location for Scripting and Imaging patron Machines
# Remember to cleanup this repo 
## ✨ Code-base structure


```bash
< PROJECT ROOT >
   |
   |-- Apps/                            # Apps to be installed and contain their own config files
   |   |-- Office/                      # Office deployment tool missing it's license key obvi
   |   |
   |   |-- bginfo/                      # Pretty info display added to the background each login
   |   |
   |-- Code/
   |   |-- Import-Module/               # Things the script will import
   |       |-- PSLogging                # A logging script that a friend gave me and I modified
   |       |    |-- PSLogging.psd1     
   |       |    |-- PSLogging.psm1
   |       |    
   |       |-- Patron
   |       |    |-- Patron.psd1
   |       |    |-- Patron.psm1
   |       |
   |   |-- IndividualScripts/           # If I wanted to run things individually
   |   |-- Setup/                       # Normal Way
   |       |-- Breakdown_v1/
   |       |    |-- <*.ps1>            
   |       |    |-- Patron Setup.ps1    # Don't use. Must of been tired. Clean this.
   |       |    |
   |       |-- MobileLab_2/             # Here is the main part
   |       |    |-- Apps.ps1
   |       |    |-- Patron Setup.ps1    # This is the completed Script
   |       |    |-- Rename.cmd
   |       |    |-- SRename.cmd
   |       |    |-- SS.cmd
   |       |    |-- installed windows app.txt
   |       |
   |       |-- scaling.ps1              # Old From Previous dude
```

<br />
# Warning
The script was completed enough locally to work and I don't remember if there was ever that final pull and merge.
So obligitory "Use at your own risk"
