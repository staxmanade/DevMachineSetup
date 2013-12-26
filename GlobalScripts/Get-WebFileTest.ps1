
function Get-WebFileTest {
    [CmdletBinding()]
    param( 
        [Parameter(Mandatory=$True,ValueFromPipeline=$True,ValueFromPipelinebyPropertyName=$True)]
        [string[]] $urls,
        $fileName = $null,
        [switch]$Passthru,
        [switch]$quiet
    )
    BEGIN {
        $webClient = New-Object System.Net.WebClient
    }
    PROCESS {

        foreach($url in $urls) {

            $file = $webClient.DownloadString($url)

            New-Object Object `
                | Add-Member NoteProperty Url $url -PassThru  `
                | Add-Member NoteProperty Contents $file -PassThru
        }
    }
    END {

    }
}
