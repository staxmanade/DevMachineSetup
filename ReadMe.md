
Run the following script to init a new machine
--

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