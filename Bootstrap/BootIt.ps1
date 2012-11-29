# install this script by executing
#  iex ((new-object net.webclient).DownloadString('https://raw.github.com/staxmanade/Scripts/master/devInstall.ps1'))
# 


# Install Chocolatey from chocolatey.org
iex ((new-object net.webclient).DownloadString('http://bit.ly/psChocInstall'))

# add chocolatey to the path since v0.9.8.16 doesn't do it.
if(!(where.exe chocolatey)){ $env:Path += ';C:\Chocolatey\bin;' }

# get the pre version because it has some features not yet released.
chocolatey install chocolatey -pre

#Install all my favorite packages.
#cinst all -source 'http://www.myget.org/F/6a72e3c34526424eacb4a37e8c21f809/'

$chocolateyIds = '7zip
notepadplusplus
poshgit
fiddler
treesizefree
P4Merge
wincommandpaste
linqpad4
putty
SkyDrive
paint.net
git-credential-winstore
dotpeek
googlechrome
WindowsLiveWriter
boxstarter.helpers'

$chocolateyIds > ChocolateyInstallIds.txt
$path = get-item 'ChocolateyInstallIds.txt'
$notepad = [System.Diagnostics.Process]::Start( "notepad.exe", $path )
$notepad.WaitForExit()
$chocolateyIds = (cat $path | where { $_ })
$chocolateyIds | %{ cinstm $_ }



if(!(where.exe git)){

	$gitPath = 'C:\Program Files\git\bin\git.exe'
	if(!(test-path $gitPath)){
		$gitPath = 'C:\Program Files (x86)\Git\bin\git.exe'
	}

	function git(){
		& $gitPath $args
	}
}

git config --global user.email jason@elegantcode.com
git config --global user.name 'Jason Jarrett'

# configure git diff and merge if p4merge was installed
if($chocolateyIds -match 'p4merge') {
	git config --global merge.tool p4merge
	git config --global mergetool.p4merge.cmd 'p4merge.exe \"$BASE\" \"$LOCAL\" \"$REMOTE\" \"$MERGED\"'
	git config --global mergetool.prompt false
	
	git config --global diff.tool p4merge
	git config --global difftool.p4merge.cmd 'p4merge.exe \"$LOCAL\" \"$REMOTE\"'
}

# setup local powershell profile.
function initProfile()
{
    $profileDir = (split-path $profile)
    if(! (test-path $profileDir))
    {
        mkdir $profileDir
    }

    pushd $profileDir

        if(test-path PsProfile)
        {
            pushd PsProfile
                try{
					git pull
                }
                catch{
                    $error
                }
            popd
        }
        else
        {
            git clone git://github.com/staxmanade/PsProfile.git
        }

        if(!(cat $profile | select-string 'PsProfile\\initProfile.ps1'))
        {
            "Adding initProfile to $Profile"
            ". `"$(split-path $profile)\PsProfile\initProfile.ps1`"" | Out-File $profile -append -encoding ASCII
        }
        . $profile
    popd
}

initProfile


import-module "$env:chocolateyinstall\chocolateyInstall\helpers\chocolateyInstaller.psm1"
$helperDir = (Get-ChildItem $env:ChocolateyInstall\lib\boxstarter.helpers*)
if($helperDir.Count -gt 1){$helperDir = $helperDir[-1]}
import-module $helperDir\boxstarter.helpers.psm1

Set-ExplorerOptions -showHidenFilesFoldersDrives -showProtectedOSFiles -showFileExtensions

Install-ChocolateyPinnedTaskBarItem (Find-Program "Google\Chrome\Application\chrome.exe")
Install-ChocolateyPinnedTaskBarItem "$env:SystemRoot\system32\WindowsPowerShell\v1.0\powershell.exe"

Install-ChocolateyFileAssociation ".txt" "$editorOfChoice"
Install-ChocolateyFileAssociation ".dll" "$env:ChocolateyInstall\bin\dotPeek.bat"
