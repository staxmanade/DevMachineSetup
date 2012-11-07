function Find-Program($folderName)
{
    $p1 = "C:\Program Files\$folderName"
    if(!(test-path $p1))
    {
        $p2 = "C:\Program Files (x86)\$folderName"
        
        if((test-path $p2))
        {
            $p2
        }
    }
    else
    {
        $p1
    }
}
