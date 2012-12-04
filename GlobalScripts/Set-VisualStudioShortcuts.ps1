function Set-VisualStudioShortCuts(){

	if(!($DTE)){
		throw "This function must be executed within the Nuget Package Manager to work correctly.";
	}

	$DTE.Commands.Item("File.Close").Bindings = "Global::Ctrl+W";

}
