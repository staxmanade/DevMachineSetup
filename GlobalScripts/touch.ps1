function touch($file) {
    if(test-path $file) {
        $f = get-item $file;
        $d = get-date
        $f.LastWriteTime = $d
    }
    else
    {
        "" | out-file -FilePath $file -Encoding ASCII
    }
}