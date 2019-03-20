# Usage: kombucha info [packages]
# Summary: Install packages in a project directory.
# Help: Create the appropriate directories and install packages
# for use in scripts or command-line usage.

. "$psscriptroot/../lib/core.ps1"
. "$psscriptroot/../lib/unix.ps1"
. "$psscriptroot/../lib/args.ps1"

$E = [char]27
$error_msg = "$E[1m$E[38;2;255;10;010merr!$E[0m"
$done_msg = "$E[1m$E[38;2;100;255;80mdone$E[0m"
$ok_msg = "$E[1m$E[38;2;100;255;80mok$E[0m"
$unknown_msg = "$E[1m$E[38;2;250;250;0m???$E[0m"
$warn_msg = "$E[1m$E[38;2;250;250;0mwarn$E[0m"
$info_msg = "$E[1m$E[38;2;120;120;255minfo$E[0m"

$key = "$E[1m$E[38;2;120;120;255m"
$off = "$E[0m"

$opt, $packages, $errors = getargs $args '' '',''

trap { }

function print ($name, $value) {
    $spc = 20
    0..($spc - $name.Length) | % {
        write-host " " -nonewline
    }
    write-host "${key}${name}${off}" -nonewline
    write-host "  ${value}`n" -nonewline
}

push-location
foreach ($_pkg in $packages) {
    # Retrieve manifest from online repository
    $_ = $_pkg
    printf "$info_msg retrieving manifest for '$_'... "
    $manifest_json = curl -sSL "https://raw.githubusercontent.com/lptstr/kombucha-registry/master/reg/$_.json"
    if ($manifest_json -like "404*") {
        $error_msg
        printf "$error_msg package '$package' does not exist. aborting.`n"
        continue
    }
    $manifest = $manifest_json | convertfrom-json
    $done_msg
    "$E[A$E[1M"

    if ($null -eq $manifest.platform) {
        $platform = "any"
    }
    else {
        $platform = $manifest.platform
    }

    # Display all values
    print name $manifest.name
    print vendor $manifest.vendor
    print description $manifest.description
    print license $manifest.license
    print platform $platform
    print global $manifest.global
    print "Git URL" $manifest.git_url
    print "File URL" $manifest.file_url
    print contents $($manifest.bin -join ', ')
}
""
Pop-Location