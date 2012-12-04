param(
	$beginSha = $(throw '-beginSha is required'),
	$endSha = $(throw '-endSha is required'),
	$projectName = $( (get-item .).name )
)


# Get a list of all the files that have been added/modified/deleted
$filesWithMods = git diff --name-status $beginSha $endSha | Select @{Name="ChangeType";Expression={$_.Substring(0,1)}}, @{Name="File"; Expression={$_.Substring(2)}}

# There has to be a cleaner way? (to get the sha1 of the 'end commit')
$endShaShortName = (git log --format=%H $endSha | select -First 1).Substring(0, 10)
$beginShaShortName = (git log --format=%H $beginSha | select -First 1).Substring(0, 10)

$deployFileBasename = "..\$($projectName)_$endShaShortName"

#var to hold the 'readme' file we're dumping information to
$rm = "$deployFileBaseName.txt"


"Changes from $beginShaShortName to $endShaShortName" > $rm
"" >> $rm

"Files Removed:" >> $rm
$filesWithMods | where{$_.ChangeType -eq 'D' } | %{ "`t" + $_.File } >> $rm
"" >> $rm

$filesAddedOrModified = $filesWithMods | where{$_.ChangeType -ne 'D' }
"Files Added or Modified:" >> $rm
$filesWithMods | where{$_.ChangeType -ne 'D' } | %{ "`t" + $_.File } >> $rm
"" >> $rm
"" >> $rm
"" >> $rm

"Complete git diff between the changes:" >> $rm
git diff $beginSha $endSha >> $rm

# Dump the modified/added files to the zip (excluding the deleted files)
$filesAddedOrModified | %{ $_.File} | AddTo-7Zip "$deployFileBasename.zip" | out-null

