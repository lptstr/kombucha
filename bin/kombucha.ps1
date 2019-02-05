#requires -version 3
# AGPL-v3.0 (c) 2019 all Kombucha contributers

param(
	$cmd
)
set-strictmode -off

# Escape character, needed for ANSI terminal sequences
[char]$global:E = [char]27

# Load files with helper functions
# Also load the commands file which loads
# command implementations
. "$psscriptroot\..\lib\core.ps1"
. "$psscriptroot\..\lib\commands"

#	. "$psscriptroot\..\lib\ravenclient.ps1"
#	$ravenClient = New-RavenClient -SentryDsn $dsn
#	[string]$dsn = "blah blah"
#	$global:cmd = $cmd
#	$global:args = $args

# Load commands
$commands = commands
if ('--version' -contains $cmd -or (!$cmd -and '-v' -contains $args)) {
    write "$E[38;2;150;150;150mkombucha version $E[1m$E[38;2;110;140;253mv$E[4m1.0.0$E[0m$E[24m"
}

# Show help message if command list is null,
# the command is `/?`, or the arguement list contains
# `--help` or `-h`
elseif (@($null, '--help', '/?') -contains $cmd -or $args[0] -contains '-h') {
	exec 'help' $args		
}
# Execute appropriate command
elseif ($commands -contains $cmd) {
	try {
		exec $cmd $args
	}
	catch {
		#	$ravenClient.CaptureException($_)
	}
	finally { }
}
else {
	Write-Host "kombucha: '$cmd' isn't a valid command. Try 'kombucha help'." 
	exit 12
}
