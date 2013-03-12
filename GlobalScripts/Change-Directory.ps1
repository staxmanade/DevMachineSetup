<#
	How to replace the default "CD" command.
		> Remove-Item alias:cd
		> Set-Alias cd C:\Code\Scripts\Change-Directory.ps1
#>
param(
	$cmd,
	$ShowCount = 10,
	[switch] $force
)

function Internal-Change-Directory($cmd, $ShowCount){

    if(!$global:CD_COMMAND_HISTORY_LIST) {
        $global:CD_COMMAND_HISTORY_LIST = New-Object 'System.Collections.Generic.List[string]'
    }

    function Set-CDLocation($newLocation) {
        $newLocation = get-item $newLocation;
        $global:CD_COMMAND_HISTORY_LIST.Add($newLocation)
        Push-Location $newLocation
    }

	function Get-CommandList() {
		$global:CD_COMMAND_HISTORY_LIST | sort -Unique
	}

	function Print-Extended-CD-Menu() {
		$index = 1;
		foreach($location in Get-CommandList){
			if($index -eq 0) {
				Write-Host ("{0,6}) {1}" -f $index, $location)
			}
			else {
				Write-Host ("{0,6}) {1}" -f $index, $location)
			}
			$index++
			if($index -gt $ShowCount){
				break;
			}
		}
	}

	switch($cmd) {
		"" { Print-Extended-CD-Menu }
		"?" { Print-Extended-CD-Menu }
		"--help" { Print-Extended-CD-Menu }
		"-" {
            if($global:CD_COMMAND_HISTORY_LIST.Count -ge 2) {
                Set-CDLocation ($global:CD_COMMAND_HISTORY_LIST[$global:CD_COMMAND_HISTORY_LIST.Count-2])
            }
        }
		default {
		
			$newLocation = $cmd;

			# check to see if we're using a number command and get the correct directory.
			[int]$cdIndex = 0;
			if([system.int32]::TryParse($cmd, [ref]$cdIndex)) {
			
				# Don't pull from the history if the index value is the same as a folder name
				if( !(test-path $cdIndex) ) {
					$results = (Get-CommandList);
					if( ($results | measure).Count -eq 1 ){
						$newLocation = $results
					}
					else {
						$newLocation = $results[$cdIndex-1]
					}
				}
			}
			
			#If we are actually changing the dir.
			if($pwd.Path -ne $newLocation){
			
				# if the path exists
				if( test-path $newLocation ){
				
					# if it's a file - get the file's directory.
					if( !(Get-Item $newLocation -Force).PSIsContainer ) {
						$newLocation = (split-path $newLocation)
					}
				
					Set-CDLocation $newLocation
				}
				else {
					if($force) {
						$prompt = 'y'
					}
					else {
						$prompt = Read-Host "Folder not found. Create it? [y/n]"
					}
					
					if($prompt -eq 'y' -or $prompt -eq 'yes') {
						mkdir $newLocation
						Set-CDLocation $newLocation
					}
				}
			}
		}
	}
}

Internal-Change-Directory -cmd $cmd -ShowCount $ShowCount