# Usage: kombucha status [options]
# Summary: Get the status of the current project.
# Help: Get a list of packages installed, with the current and lastest versions
#
# Options:
#     -l, --latest       Get the latest version of the package (may take longer)

. "$psscriptroot\..\lib\core.ps1"
. "$psscriptroot\..\lib\getopt.ps1"

$opt, $extra_args, $err = getopt $args 'l' 'latest'
$latest = $opt.latest -or $opt.l
$E = [char]27

trap { }

push-location

if (!(test-path '.\kombucha.json')) {
	error "440 Required file 'kombucha.json' not found."
	error "Make sure you are in the correct project directory, or run 'kombucha init'."
	break
}


pop-location
