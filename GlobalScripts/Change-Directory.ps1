
function Internal-Change-Directory($cmd, $ShowCount){

	if(!$ShowCount) {
		$ShowCount = 10;
	}

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
				Write-Host ("{0,6}) {1}" -f $index, $location)
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

			# Turn "cd ...." into "cd ../../../"
			if ($newLocation -match "^\.*$" -and $newLocation.length -gt 2) {
				$numberToChange = $newLocation.length - 1
				$newLocation = ""
				for($i = 0; $i -lt $numberToChange; $i++) {
					$newLocation += "../"
				}
			}


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

Set-Alias -Name Remove-Item -Value Internal-Remove-Item -Option AllScope
Set-Alias -Name cd -Value Internal-Change-Directory -Option AllScope
