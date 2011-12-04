
foreach($file in (ls .\IncludeScripts\*.ps1))
{
	"Dot Sourcing Script - $file"
	. $file
}

$tfPath = Find-Program 'Microsoft Visual Studio 10.0\Common7\IDE\TF.exe'
function tf(){ & $tfPath $args }

$notepadPath = Find-Program 'Notepad++\notepad++.exe'
if($notepadPath)
{
    set-alias notepad $notepadPath
    set-alias np $notepadPath
}
