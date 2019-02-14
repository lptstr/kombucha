# Usage: kombucha update [packages] [options]
# Summary: Updates packages in a project directory.
# Help: Update the specified the packages to a higher or a lower version.
#
# To update to a specific version, append '@<version>' to the package name:
#     kombucha update burnttoast@0.6.3
#
# Options:
#     -n, --nosave       Do not update the manifest with the package name.

. "$psscriptroot\..\lib\core.ps1"
. "$psscriptroot\..\lib\network.ps1"
. "$psscriptroot\..\lib\filesys.ps1"
. "$psscriptroot\..\lib\getopt.ps1"

$opt, $pkg, $err = getopt $args 'n' 'nosave'
$force = $opt.force -or $opt.f
$nosave = $opt.nosave -or $opt.n
$E = [char]27

trap { }

push-location

if (!(test-path '.\kombucha.json')) {
	error "440 Required file 'kombucha.json' not found."
	error "Make sure you are in the correct project directory, or run 'kombucha init'."
	break
}

foreach ($_pkg in $pkg) {
	$_ = $_pkg
	$package = (($_).Split('@'))[0]
	$version = (($_).Split('@'))[1]

	# Check that the package is not already installed
	if (!(is_installed $package)) {
		error "404 The package '$_' is not installed."
		error "Try 'kombucha install $_' to install the package first.`n"
		continue
	}

	write-host "Finding package '${package}'... " -nonewline
	$info = find-package $package

	if ($null -eq $info) { 
		"$E[38;2;255;10;010merror!$E[38;2;150;150;150m"
		error "404 Package '$_' was not found!" 
		continue
	}
	else {
		# Now the party starts
		"$E[38;2;100;255;80mdone$E[38;2;150;150;150m"
		$latestv = $info.version
		if ($version) {
			write-host "Retrieving versions... " -nonewline
			$info = find-package $package -requiredversion $version

			if ($null -eq $info) { 
				"$E[38;2;255;10;010merror!$E[38;2;150;150;150m" 
				error "404 Package $package of the version $version was not found!"
				continue
			} else { 
				"$E[38;2;100;255;80mdone$E[38;2;150;150;150m" 
			}
		} else {
			$version = $latestv
		}

		write-host "Downloading `'${_}`'... " -nonewline
		cd packages

		if ($force) {
			find-package $package -requiredversion $version | save-module -path (get-location) -force
		} else {
			find-package $package -requiredversion $version | save-module -path (get-location)
		}

		"$E[38;2;100;255;80mdone$E[38;2;150;150;150m"

		if (!$nosave) {
			write-host "Updating project manifest... " -nonewline
			cd ..
			update_manifest $package $version
			"$E[38;2;100;255;80mdone$E[38;2;150;150;150m`n"
		} 
	}
}

pop-location