# Usage: kombucha init [options]
# Summary: Initialize Kombucha in a directory.
# Help: Create the appropriate directories and files for Kombucha to function properly.

. "$psscriptroot\..\lib\core.ps1"
. "$psscriptroot\..\lib\getopt.ps1"

#$opt, $files, $err = getopt $args '' ''

trap { }

mkdir packages | out-null
set-content -path "kombucha.json" -value "{`n`t`"packages`": []`n}" | out-null

copy-item "$psscriptroot\..\libsrc\kpm-client.ps1" ".\kpm-client.ps1"
