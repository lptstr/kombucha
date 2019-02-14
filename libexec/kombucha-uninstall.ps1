# Usage: kombucha uninstall [package] [options]
# Summary: Remove a package from a project.
# Help: Delete a package from the project directory.

. "$psscriptroot\..\lib\core.ps1"
. "$psscriptroot\..\lib\network.ps1"
. "$psscriptroot\..\lib\filesys.ps1"
. "$psscriptroot\..\lib\getopt.ps1"

$opt, $pkg, $err = getopt $args '' ''

trap { }

if (!(test-path '.\kombucha.json')) {
	error "440 Required file 'kombucha.json' not found."
	error "Make sure you are in the correct project directory, or run 'kombucha init'."
	break
}

foreach ($_ in $pkg) {
	# Check that the package is installed
	if (!(is_installed $_)) {
		error "404 The package '$_' is not installed."
		error "Packages must be installed for Kombucha to delete it!!`n"
		continue
	}

	write-host "Deleting package '${_}'... " -nonewline
	# Delete the package folder
	cd packages
	remove-item -r -fo $_
	"$E[38;2;100;255;80mdone$E[38;2;150;150;150m"

	write-host "Updating manifest... " -nonewline
	# Update the manifest
	cd ..
	$i = 0
	$pos = 0
	$manifest = get-content './kombucha.json' | convertfrom-json
	foreach ($package in $manifest.packages.package) {
		if ($package -eq $pkg) {
			$pos = $i
			break
		}
		$i++
	}
	$manifest.packages = ($manifest.packages) | Where-Object { $_ -ne ($manifest.packages)[$pos] }
	set-content './kombucha.json' ($manifest | convertto-json)
	"$E[38;2;100;255;80mdone$E[38;2;150;150;150m`n"
}
