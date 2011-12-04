
Run the following script to init a new machine
--

    $profileDir = (split-path $profile)
    if(! (test-path $profileDir))
    {
    	mkdir $profileDir
    }

    pushd $profileDir
    
    	git clone git@github.com:staxmanade/PsProfile.git
    
    	". `"$(split-path $profile)\PsProfile\initProfile.ps1`"" | Out-File $profile -append
    
    	. $profile
    popd
    
