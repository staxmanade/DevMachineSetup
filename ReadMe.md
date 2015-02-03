
> By: [@staxmanade](http://staxmanade.com)

Purpose for repo!
--



To organize the configuration and setup of my typical development environment.



1. One time setup of my developer machine 
--

Execute the following one-liner in an elevated powershell prompt

    set-executionpolicy unrestricted;
    iex ((new-object net.webclient).DownloadString('https://raw.github.com/staxmanade/DevMachineSetup/master/Bootstrap/BootIt.ps1'))


2. Initialize powershell profile
--

 NOTE: This is already included in the #1 above

    set-executionpolicy unrestricted;
    iex ((new-object net.webclient).DownloadString('https://raw.github.com/staxmanade/DevMachineSetup/master/Bootstrap/initPsProfile.ps1'))

