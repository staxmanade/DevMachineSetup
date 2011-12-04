
function Load-Assembly($assembly)
{
	echo $assembly
	if(test-path $assembly)
	{
		$assemblyPath = get-item $assembly
		[System.Reflection.Assembly]::LoadFrom($assemblyPath)
	}
	else
	{
		[System.Reflection.Assembly]::LoadWithPartialName("$assembly")
	}
}
