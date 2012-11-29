# Developer machine setup - run the below oneliner (in an elevated PS profile to setup a my development environment)
#  iex ((new-object net.webclient).DownloadString('https://raw.github.com/staxmanade/DevMachineSetup/master/Bootstrap/initPsProfile.ps1'))
#

##### What is this script doing?
# 1. Make the `$Profile` directory if it doesn't exist.
# 2. CD into that profile directory
# 3. If the DevMachineSetup folder already exists (use git to pull down the latest version)
#    Else clone the DevMachineSetup folder from my github
# 4. Now make sure that the `initProfile` script gets loaded into the `$Profile`
# 5. Dot-Source the `$Profile` so we have the latest/greatest.

$profileDir = (split-path $profile)
if(! (test-path $profileDir))
{
	mkdir $profileDir
}

pushd $profileDir

	if(test-path DevMachineSetup)
	{
		pushd DevMachineSetup
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
		git clone https://github.com/staxmanade/DevMachineSetup.git
	}

	if(!(cat $profile | select-string 'DevMachineSetup\\initProfile.ps1'))
	{
		"Adding initProfile to $Profile"
		". `"$(split-path $profile)\DevMachineSetup\initProfile.ps1`"" | Out-File $profile -append -encoding ASCII
	}
	. $profile
popd
