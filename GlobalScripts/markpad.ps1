
function markpad($file){

	$markpadExe = "$($env:HOME)\AppData\Local\MarkPad\MarkPad.exe"

	if( test-path $markpadExe) {
	
		& $markpadExe (get-item $file)
	}
	else {

		throw "markpad not found: cinst markpad"

	}

}
