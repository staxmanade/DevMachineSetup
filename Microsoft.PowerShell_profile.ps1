
$globalProfileScriptsPath = (get-item .\GlobalScripts\)

foreach($file in "$($globalProfileScriptsPath)\*.ps1")
{
	"Dot Sourcing Script - $file"
	. $file
}


Remove-Item alias:cd
Set-Alias cd (Get-Item "$($globalProfileScriptsPath)\Change-Directory.ps1")


$tfPath = Find-Program 'Microsoft Visual Studio 10.0\Common7\IDE\TF.exe'
function tf(){ & $tfPath $args }


$notepadPath = Find-Program 'Notepad++\notepad++.exe'
if($notepadPath)
{
    set-alias notepad $notepadPath
    set-alias np $notepadPath
}
