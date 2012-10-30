Run the following script to init a new machine
--

#### What is this script doing?
1. Make the `$Profile` directory if it doesn't exist.
2. set our current directory to where the profile is located
3. If the PsProfile folder already exists (use git to pull down the latest version)
   Else clone the PsProfile folder from my github
4. Now make sure that the `initProfile` script gets loaded into the `$Profile`
5. Dot-Source the `$Profile` so we have the latest/greatest.

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
    			git clone git@github.com:staxmanade/PsProfile.git
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