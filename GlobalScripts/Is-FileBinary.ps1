function Is-FileBinary(){

	param(  
	    [Parameter(
		Position=0, 
		Mandatory=$true, 
		ValueFromPipeline=$true,
		ValueFromPipelineByPropertyName=$true)
	    ]
	    [Alias('FullName')]
	    [String[]]$FilePath
	    )
		
# Copied/modified from
# http://stackoverflow.com/questions/1077634/powershell-search-script-that-ignores-binary-files


	BEGIN {

	}
	PROCESS {
		# The file to be tested

		if($FilePath -and ($FilePath.PsIsContainer))
		{
			throw "this only works against files, not folders [$FilePath]";
			return;
		}

		# encoding variable
		$encoding = ""

		# Get the first 1024 bytes from the file
		$byteArray = Get-Content -Path $FilePath -Encoding Byte -TotalCount 1024

		if( ("{0:X}{1:X}{2:X}" -f $byteArray) -eq "EFBBBF" )
		{
		    # Test for UTF-8 BOM
		    $encoding = "UTF-8"
		}
		elseif( ("{0:X}{1:X}" -f $byteArray) -eq "FFFE" )
		{
		    # Test for the UTF-16
		    $encoding = "UTF-16"
		}
		elseif( ("{0:X}{1:X}" -f $byteArray) -eq "FEFF" )
		{
		    # Test for the UTF-16 Big Endian
		    $encoding = "UTF-16 BE"
		}
		elseif( ("{0:X}{1:X}{2:X}{3:X}" -f $byteArray) -eq "FFFE0000" )
		{
		    # Test for the UTF-32
		    $encoding = "UTF-32"
		}
		elseif( ("{0:X}{1:X}{2:X}{3:X}" -f $byteArray) -eq "0000FEFF" )
		{
		    # Test for the UTF-32 Big Endian
		    $encoding = "UTF-32 BE"
		}

		if($encoding)
		{
		    # File is text encoded
		    return $false
		}

		# So now we're done with Text encodings that commonly have '0's
		# in their byte steams.  ASCII may have the NUL or '0' code in
		# their streams but that's rare apparently.

		# Both GNU Grep and Diff use variations of this heuristic

		if( $byteArray -contains 0 )
		{
		    # Test for binary
		    return $true
		}

		# This should be ASCII encoded 
		$encoding = "ASCII"

		return $false
	}
	END {
	}
}
