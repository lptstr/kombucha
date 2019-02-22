# Usage: kombucha restore
# Summary: Re-install all previously installed packages.
# Help: Get a list of packages installed from the kombucha.json file and re-installs them.
#
# Options:
#     -l, --latest       Get the latest version of the package (may take longer)

. "$psscriptroot\..\lib\core.ps1"
. "$psscriptroot\..\lib\network.ps1"
. "$psscriptroot\..\lib\filesys.ps1"

$E = [char]27

trap { }

push-location

if (!(test-path '.\kombucha.json')) {
	error "440 Required file 'kombucha.json' not found."
	error "Make sure you are in the correct project directory, or run 'kombucha init'."
	break
}

# Get list of packages and their current versions
$manifest = get-content './kombucha.json' | convertfrom-json
$i = 0
foreach ($package in $manifest.packages.package) {
	$version = ($manifest.packages.version[$i]).TrimStart("v")
     kombucha install "${_}@${version}"
	$i++
}

write-host "Restored $i packages."

pop-location
