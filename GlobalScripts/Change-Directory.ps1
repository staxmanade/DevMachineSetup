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

	function Get-CommandList() {
		(Get-Location -Stack).ToArray() | sort Path -Unique
	}

	function Print-Extended-CD-Menu(){
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
						$newLocation = (Get-CommandList)[$cdIndex-1]
					}
				}
			}
			
			#If we are actually changing the dir.
			if($pwd.Path -ne $newLocation){
			
				# if the path exists
				if( test-path $newLocation ){
				
					# if it's a file - get the directory then go there.

					if( !(Get-Item $newLocation -Force).PSIsContainer ) {
						$newLocation = (split-path $newLocation)
					}
				
					Push-Location $newLocation
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
						Push-Location $newLocation
					}
				}
			}
		}
	}
}

Internal-Change-Directory -cmd $cmd -ShowCount $ShowCount