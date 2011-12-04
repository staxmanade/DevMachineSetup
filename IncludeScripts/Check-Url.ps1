<#
.SYNOPSIS
Takes a list of urls and verifies that the url is valid.

.DESCRIPTION
The Check-Url script takes a piped list of url and attempts download the HEAD of the file from the web. If it retrieves an HTTP status of OK then the URL is reported as valid. If the result is anything else or an exception, then the url is reported as invalid.

.INPUTS
List of url's to check. Note: the url's must begin with http:// or https://

.OUTPUTS
Returns a powershell object with two properties
    1. IsValid [bool] - signifies weather the url was determined as Valid or not
	2. Url [string] - the url that was checked.
	3. HttpStatus - The http status resulting from the web request.
	4. Error - Any possible error resulting from the request.

.EXAMPLE
@('http://www.google.com', 'http://www.asd----fDSAWQSDF-GZz.com') | .\Check-Url.ps1

.EXAMPLE
@('http://www.google.com', 'http://www.asd----fDSAWQSDF-GZz.com') | .\Check-Url.ps1 | where { !$_.IsValid }
Reports the Invalid url's.
#>

 BEGIN {
}
PROCESS {
  ## You have to at least make sure it's got a value 
  ## Really you should check it's TYPE to make sure you can do something useful...
  if($_) {
	
	$url = $_;

	$urlIsValid = $false
	try
	{
		$request = [System.Net.WebRequest]::Create($url)
		$request.Method = 'HEAD'
		$response = $request.GetResponse()
		$httpStatus = $response.StatusCode
		$urlIsValid = ($httpStatus -eq 'OK')
		$tryError = $null
		$response.Close()
	}
	catch [System.Exception] {
		$httpStatus = $null
		$tryError = $_.Exception
		$urlIsValid = $false;
	}

	$x = new-object Object | `
			add-member -membertype NoteProperty -name IsValid -Value $urlIsvalid -PassThru | `
			add-member -membertype NoteProperty -name Url -Value $_ -PassThru | `
			add-member -membertype NoteProperty -name HttpStatus -Value $httpStatus -PassThru | `
			add-member -membertype NoteProperty -name Error -Value $tryError -PassThru
	$x 
  }
}
END {

}
<#
	References...
	
	http://stackoverflow.com/questions/924679/c-how-can-i-check-if-a-url-exists-is-valid
	http://huddledmasses.org/using-script-functions-in-the-powershell-pipeline/
#>
