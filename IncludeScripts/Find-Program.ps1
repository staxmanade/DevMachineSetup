function Find-Program($folderName)
{
    $p1 = "C:\Program Files\$folderName"
    if(!(test-path $p1))
    {
        $p2 = "C:\Program Files (x86)\$folderName"
        
        if(!(test-path $p2))
        {
            Write-Warning "Could not find program folder/path in either $p1 or $p2"
        }
        else
        {
            $p2
        }
    }
    else
    {
        $p1
    }
}
