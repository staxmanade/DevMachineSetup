function Coalesce-Paths {
    $result = $null
    foreach($arg in $args) {
        if ($arg -is [ScriptBlock]) {
            $result = & $arg
        } else {
            $result = $arg
        }
        if($result){
                if (test-path "$result") { break }
        }
    }
    $result
}

# - this will attempt to pull down the latest profile in the background.
$profileUpdatedVar = "LastProfileUpdatedDate"

if([Environment]::GetEnvironmentVariable($profileUpdatedVar, "User") -lt ((get-date).Date)) {
    
    if(test-path (split-path $profile)){
        pushd (split-path $profile)
         pushd PsProfile
          git pull

          [Environment]::SetEnvironmentVariable($profileUpdatedVar, (get-date).Date, "User")
         popd
        popd
    }
    else {
	"Could not update profile because the folder doesn't exist? - weird!"
    }
}

$globalProfileScriptsPath = "$(split-path $profile)\PsProfile\GlobalScripts\"

foreach($file in (ls "$globalProfileScriptsPath*.ps1"))
{
	"Dot Sourcing Script - $($file.FullName)"
	. $file.FullName
}


Remove-Item alias:cd
Set-Alias cd (Get-Item "$($globalProfileScriptsPath)\Change-Directory.ps1")


$tfPath = Coalesce-Paths (Find-Program 'Microsoft Visual Studio 11.0\Common7\IDE\TF.exe' -force) (Find-Program 'Microsoft Visual Studio 10.0\Common7\IDE\TF.exe' -force)
function tf(){ 

	if($tfPath -and (test-path $tfPath)) {
		& $tfPath $args;
	}
	else {
		throw "TF path [$tfPath] could not be found"
	}
	
}


$editorOfChoice = Coalesce-Paths (Find-Program 'vim\vim73\vim.exe') (Find-Program 'Notepad++\notepad++.exe')

if($editorOfChoice)
{
    set-alias notepad $editorOfChoice
    set-alias edit $editorOfChoice
}




if($error.Count -eq 0)
{ 
	cls
}
