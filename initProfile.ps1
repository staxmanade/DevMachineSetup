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

$globalProfileScriptsPath = "$(split-path $profile)\PsProfile\GlobalScripts\"

foreach($file in (ls "$globalProfileScriptsPath*.ps1"))
{
	"Dot Sourcing Script - $($file.FullName)"
	. $file.FullName
}


Remove-Item alias:cd
Set-Alias cd (Get-Item "$($globalProfileScriptsPath)\Change-Directory.ps1")


$tfPath = Coalesce-Paths (Find-Program 'Microsoft Visual Studio 11.0\Common7\IDE\TF.exe'), (Find-Program 'Microsoft Visual Studio 10.0\Common7\IDE\TF.exe')
function tf(){ & $tfPath $args;}


$editorOfChoice = Find-Program 'vim\vim73\vim.exe'
if(!$editorOfChoice){
	$editorOfChoice = Find-Program 'Notepad++\notepad++.exe'
}


if($editorOfChoice)
{
    set-alias notepad $editorOfChoice
    set-alias edit $editorOfChoice
}

if($error.Count -eq 0)
{ 
	cls
}
