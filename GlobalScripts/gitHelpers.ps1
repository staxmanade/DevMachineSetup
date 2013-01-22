function gitinit()
{
	git init
	if($LASTEXITCODE)
	{
		return;
	}

	$gitIgnoreRemotePath = 'https://raw.github.com/staxmanade/Scripts/master/.gitignore.rename'
	$destinationPath = "$(pwd)\.gitignore"
	$clnt = new-object System.Net.WebClient
	echo "Downloading base .gitignore from - $gitIgnoreRemotePath"
	$clnt.DownloadFile($gitIgnoreRemotePath, "$destinationPath")
}

function gitGo($message) {

	git add .
	git commit -m $message


}
