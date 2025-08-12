# PSSecureCommands
Powershell Module to convert commands into secured ones 

# Example of use
``` powershell
PS C:\Users\rpt> Import-Module PSSecureCommands
PS C:\Users\rpt> Add-SecureCommand -Name show -Command @"
>> param([String]`$Show)
>> write-output "Let's show : `$show"
>> "@
PS C:\Users\rpt> Add-SecureCommand -name ipconfig -command "ipconfig"
PS C:\Users\rpt> Invoke-SecureCommand -Name show -parameters @{show="toto"}
Let's show : toto
PS C:\Users\rpt> Invoke-SecureCommand -Name show
Let's show :
PS C:\Users\rpt> $global:scmd

Name                           Value
----                           -----
key                            {27, 18, 0, 3…}
SecureCommand                  76492d1116743f0423413b16050a5345MgB8AFEAMwBhAFUAYwBHAHUAcgBEAGUAbgBFAEsAMwBUAEkALwBjADEAUAB0AFEAPQA9AHwANgA2AGEANgA2ADQAYQAzADAANwBlAGYA…
name                           show
key                            {8, 26, 23, 29…}
SecureCommand                  76492d1116743f0423413b16050a5345MgB8AHoATwBRAGsAcQBtADUAcQBZAFcALwArAG0AWAB1AGcARAA4AFkAMgBtAFEAPQA9AHwAOABjADMAZABmAGYAYwAzADIANQA0AGYA…
name                           ipconfig

PS C:\Users\rpt> Remove-SecureCommand -Name ipconfig
PS C:\Users\rpt> $global:scmd

Name                           Value
----                           -----
key                            {27, 18, 0, 3…}
SecureCommand                  76492d1116743f0423413b16050a5345MgB8AFEAMwBhAFUAYwBHAHUAcgBEAGUAbgBFAEsAMwBUAEkALwBjADEAUAB0AFEAPQA9AHwANgA2AGEANgA2ADQAYQAzADAANwBlAGYA…
name                           show

PS C:\Users\rpt> save-SecureCommands -Path .\test.json
PS C:\Users\rpt> test-path .\test.json
True
PS C:\Users\rpt> $global:scmd = $null
PS C:\Users\rpt> $global:scmd
PS C:\Users\rpt> Import-SecureCommands -Path .\test.json

key             SecureCommand
---             -------------
{27, 18, 0, 3…} 76492d1116743f0423413b16050a5345MgB8AFEAMwBhAFUAYwBHAHUAcgBEAGUAbgBFAEsAMwBUAEkALwBjADEAUAB0AFEAPQA9AHwANgA2AGEANgA2ADQAYQAzADAANwBlAGYAYwBhADcAYgAwADY…

PS C:\Users\rpt> $global:scmd | Format-Table Name,key,SecureCommand

name key             SecureCommand
---- ---             -------------
show {27, 18, 0, 3…} 76492d1116743f0423413b16050a5345MgB8AFEAMwBhAFUAYwBHAHUAcgBEAGUAbgBFAEsAMwBUAEkALwBjADEAUAB0AFEAPQA9AHwANgA2AGEANgA2ADQAYQAzADAANwBlAGYAYwBhADcAYg…

PS C:\Users\rpt>
```
