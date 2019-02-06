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

"$E(0lqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqk$E(B"
"$E(0x$E(B     [package]         $E[1m$E[38;2;110;140;253m[$E[4mcurrent$E[24m]`t$E[1m$E[38;2;253;140;110m[$E[4mlatest$E[24m]$E[0m $E(0x$E(B"
"$E(0xqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqx$E(B"

# Get list of packages and their current versions
$manifest = get-content './kombucha.json' | convertfrom-json
$i = 0
foreach ($package in $manifest.packages.package) {
	write-host "$E(0x$E(B ${i}." -nonewline
	$c = 0
	while ($c -lt (2 - ((($i.ToString()).Length)) + 1)) {
		write-host " " -nonewline
		$c++
	}
	write-host "$package" -nonewline
	$c = 0
	while ($c -lt (18 - ($package.Length))) {
		write-host " " -nonewline
		$c++
	}
	$version = ($manifest.packages.version[$i]).TrimStart("v")
	write-host "$E[1m$E[38;2;110;140;253m[v$E[4m${version}$E[24m]$E[0m`t" -nonewline
	if ($latest) {
		$latestv = (find-package $package).version
		write-host "$E[1m$E[38;2;253;140;110m[v$E[4m${latestv}$E[24m]$E[0m $E(0x$E(B"
	} else {
		"         $E(0x$E(B" # We need a newline
	}
	$i++
}

"$E(0mqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqj$E(B"

pop-location
