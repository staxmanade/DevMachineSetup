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
	git commit . -m $message


}

function gitlog() {

	# found on StackOverflow
	# http://stackoverflow.com/questions/1838873/visualizing-branch-topology-in-git

	git log --graph --full-history --all --color --pretty=format:"%x1b[31m%h%x09%x1b[32m%d%x1b[0m%x20%s"
}

function gitstandup() {

	# Good post on git pretty formatting
	# http://alexefish.com/post/18453172089/pretty-git-logging
	git log --author=Jason --graph --full-history --all --color --pretty=format:"%ar %x1b[31m%h%x09%x1b[32m%d%x1b[0m%x20%s"
}

function gitsummary(){
	git shortlog --numbered --summary
}
function gitFixWhiteSpace { git rm --cached -r .; git reset --hard; }
