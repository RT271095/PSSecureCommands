<#
	.SYNOPSIS
	Function used to create new keys for each secure command
	
	.EXAMPLE
	# To generate a key with a size of 16 and a max number of 32
	New-Key
	
	.EXAMPLE
	# To generate a key with a custom size and max number
	New-Key -Size $Size -Max $Max
#>
Function New-Key {
	param([Int]$Size=16,[Int]$Max=32)
	return get-random -count $Size -Maximum $Max
}

<#
	.SYNOPSIS
	To add a new secure command to $global:scmd list
	
	.EXAMPLE
	Add-SecureCommand -name ipconfig -command "ipconfig"
	
#>
Function Add-SecureCommand {
	param([String]$Name,[string]$Command)
	if($null -eq $global:scmd){$global:scmd = @()}
	$key = New-key
	$SecureCommand = convertto-securestring $Command -asplaintext | convertfrom-securestring -key $key
	$global:scmd += @(@{name=$Name; SecureCommand=$SecureCommand; key=$key})
}

<#
	.SYNOPSIS
	To remove a secure command from $global:scmd list
	
	.EXAMPLE
	Remove-SecureCommand -Name ipconfig
	
#>
Function Remove-SecureCommand {
	param([String]$Name)
	$tosave = @()
	foreach($elem in $global:scmd){
		if($elem.Name -ne $Name){
			$tosave += @($elem)
		}
	}
	$global:scmd = $tosave
}

<#
	.SYNOPSIS
	To invoke a secure command from $global:scmd list
	
	.EXAMPLE
	# to execute without parameters
	Invoke-SecureCommand -Name ipconfig
	
	.EXAMPLE
	# to execute with parameters
	Invoke-SecureCommand -Name ping -Parameters @{host="google.com"}
#>
Function Invoke-SecureCommand {
	param([String]$Name, [PSObject]$Parameters=@{})
	$my_scmd = $global:scmd | where {$_.Name -eq $Name}
	if($null -ne $my_scmd){
		$command = convertto-securestring $my_scmd.SecureCommand -key $my_scmd.key | convertfrom-securestring -asplaintext
		$ScriptBlock =[System.Management.Automation.ScriptBlock]::Create($Command)
		. $ScriptBlock @Parameters
	}else{
		Write-output "Secured command $Name not found ..."
	}
}

<#
	.SYNOPSIS
	To save secure commands from $global:scmd list into JSON file
	
	.EXAMPLE
	Save-SecureCommands -Path .\securecommands.json
#>
Function Save-SecureCommands {
	param([String]$Path)
	$JSON = $scmd | convertto-json
	$JSON | out-file "$Path" -encoding default
}

<#
	.SYNOPSIS
	To import secure command from a JSON file into $global:scmd list
	
	.EXAMPLE
	Import-SecureCommands -Path .\securecommands.json
#>
Function Import-SecureCommands {
	param([String]$Path)
	$global:scmd = get-content $Path -raw | convertfrom-json
	return $global:scmd
}