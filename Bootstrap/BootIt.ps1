# Developer machine setup - run the below oneliner (in an elevated PS profile to setup a my development environment)
#  iex ((new-object net.webclient).DownloadString('https://raw.github.com/staxmanade/DevMachineSetup/master/Bootstrap/BootIt.ps1'))
#


# Install Chocolatey from chocolatey.org
iex ((new-object net.webclient).DownloadString('http://bit.ly/psChocInstall'))

# add chocolatey to the path since v0.9.8.16 doesn't do it.
if(!(where.exe chocolatey)){ $env:Path += ';C:\Chocolatey\bin;' }

# get the pre released version. It haz cool features!
chocolatey install chocolatey -pre


$chocolateyIds = '7zip
notepadplusplus
poshgit
fiddler
treesizefree
P4Merge
wincommandpaste
linqpad4
putty
f.lux
SkyDrive
paint.net
git-credential-winstore
dotpeek
googlechrome
WindowsLiveWriter
boxstarter'

$chocolateyIds > ChocolateyInstallIds.txt
$path = get-item 'ChocolateyInstallIds.txt'
$notepad = [System.Diagnostics.Process]::Start( "notepad.exe", $path )
$notepad.WaitForExit()
$chocolateyIds = (cat $path | where { $_ })
$chocolateyIds | %{ cinstm $_ }




import-module "$env:chocolateyinstall\chocolateyInstall\helpers\chocolateyInstaller.psm1"
$helperDir = (Get-ChildItem $env:ChocolateyInstall\lib\boxstarter.helpers*)
if($helperDir.Count -gt 1){$helperDir = $helperDir[-1]}
import-module $helperDir\boxstarter.helpers.psm1

Set-ExplorerOptions -showHidenFilesFoldersDrives -showProtectedOSFiles -showFileExtensions

Install-ChocolateyPinnedTaskBarItem (Find-Program "Google\Chrome\Application\chrome.exe")
Install-ChocolateyPinnedTaskBarItem "$env:SystemRoot\system32\WindowsPowerShell\v1.0\powershell.exe"

Install-ChocolateyFileAssociation ".txt" "$editorOfChoice"
Install-ChocolateyFileAssociation ".dll" "$env:ChocolateyInstall\bin\dotPeek.bat"

Enable-RemoteDesktop




if(!(where.exe git)){
	#Why is git not on the PATH?

	$gitPath = 'C:\Program Files\git\bin'
	if(!(test-path $gitPath)){
		$gitPath = 'C:\Program Files (x86)\Git\bin'
	}

	if(test-path "$gitPath\git.exe"){
		$env:Path += ";$gitPath"
	}
	else{
		throw "could not find git, rest of setup not going to execute..."
		return;
	}
}

git config --global user.email jason@elegantcode.com
git config --global user.name 'Jason Jarrett'
git config --global color.status.changed "cyan normal bold" 
git config --global color.status.untracked "cyan normal bold"

# configure git diff and merge if p4merge was installed
if($chocolateyIds -match 'p4merge') {
	git config --global merge.tool p4merge
	git config --global mergetool.p4merge.cmd 'p4merge.exe \"$BASE\" \"$LOCAL\" \"$REMOTE\" \"$MERGED\"'
	git config --global mergetool.prompt false
	
	git config --global diff.tool p4merge
	git config --global difftool.p4merge.cmd 'p4merge.exe \"$LOCAL\" \"$REMOTE\"'
}

# setup local powershell profile.
iex ((new-object net.webclient).DownloadString('https://raw.github.com/staxmanade/DevMachineSetup/master/Bootstrap/initPsProfile.ps1'))


Install-WindowsUpdate -AcceptEulaInstall-WindowsUpdate -AcceptEula
