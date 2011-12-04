
function invoke-psake-locally
{
	# Helper script for those who want to run psake without importing the module.
	# Example:
	# .\psake.ps1 "default.ps1" "BuildHelloWord" "4.0" 

	# Must match parameter definitions for psake.psm1/invoke-psake 
	# otherwise named parameter binding fails
	param(
	  [Parameter(Position=0,Mandatory=0)]
	  [string]$buildFile = 'default.ps1',
	  [Parameter(Position=1,Mandatory=0)]
	  [string[]]$taskList = @(),
	  [Parameter(Position=2,Mandatory=0)]
	  [string]$framework = '4.0',
	  [Parameter(Position=3,Mandatory=0)]
	  [switch]$docs = $false,
	  [Parameter(Position=4,Mandatory=0)]
	  [System.Collections.Hashtable]$parameters = @{},
	  [Parameter(Position=5, Mandatory=0)]
	  [System.Collections.Hashtable]$properties = @{}
	)

	try {
	  $psakeModulePath = (join-path ($pwd).Path psake.psm1)
	  
	  if(!(test-path $psakeModulePath))
	  {
		throw "Cannot find $psakeModulePath"
	  }
	  import-module $psakeModulePath
	  invoke-psake $buildFile $taskList $framework $docs $parameters $properties
	} finally {
	  remove-module psake -ea 'SilentlyContinue'
	}
}
set-alias ip invoke-psake-locally
