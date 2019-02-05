# Usage: kombucha install [packages@version] [options]
# Summary: Install packages in a project directory.
# Help: Create the appropriate directories and install packages.
#
# To install packages of a specific version, append '@<version>' to 
# the end of the package name. E.g.:
#     kombucha install burnttoast@0.6.1 
#
# Options:
#     -f, --force        Force the installation of the package, even if it is already installed.
#     -n, --nosave       Do not update the manifest with the package name.

. "$psscriptroot\..\lib\core.ps1"
. "$psscriptroot\..\lib\getopt.ps1"

$opt, $pkg, $err = getopt $args 'fn' 'force','nosave'
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

	if (!$force) {
		# Check that the package is not already installed
		if (is_installed $package) {
			error "416 The package '$_' is already installed."
			error "Try 'kombucha update $_' to update the package.`n"
			continue
		}
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
			$manifest = get-content '.\kombucha.json' -encoding utf8 | convertfrom-json -ea stop
			$pkginfo = new-object psobject
			$pkginfo | add-member package $package 
			$pkginfo | add-member version $version
			$manifest.packages += $pkginfo
			set-content -path '.\kombucha.json' -value ($manifest | convertto-json) -encoding utf8
			"$E[38;2;100;255;80mdone$E[38;2;150;150;150m`n"
		} 
	}
}

pop-location