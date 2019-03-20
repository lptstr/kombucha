# Usage: kombucha install [packages@version] [options]
# Summary: Install packages in a project directory.
# Help: Create the appropriate directories and install packages
# for use in scripts or command-line usage.
#
# Options:
#     -g, --global       Install the package globally.

. "$psscriptroot/../lib/core.ps1"
. "$psscriptroot/../lib/unix.ps1"
. "$psscriptroot/../lib/shim.ps1"
. "$psscriptroot/../lib/path.ps1"
. "$psscriptroot/../lib/args.ps1"

$E = [char]27
$error_msg = "$E[1m$E[38;2;255;10;010merr!$E[0m"
$done_msg = "$E[1m$E[38;2;100;255;80mdone$E[0m"
$warn_msg = "$E[1m$E[38;2;250;250;0mwarn$E[0m"
$info_msg = "$E[1m$E[38;2;120;120;255minfo$E[0m"

$opt, $packages, $errors = getopt $args 'g' 'global'
$global = $opt.global -or $opt.g

if ($errors) {
    printf "$error_msg argument error: $err`n"
    exit 1
}

trap { }

push-location
foreach ($_pkg in $packages) {
    $_ = $_pkg
    printf "$info_msg retrieving manifest for '$_'... "
    $manifest_json = curl -sSL "https://raw.githubusercontent.com/lptstr/kombucha-registry/master/reg/$_.json"
    if ($manifest_json -like "404*") {
        $error_msg
        printf "$error_msg package '$package' does not exist. aborting.`n"
        continue
    }
    $manifest = $manifest_json | convertfrom-json
    $package = $manifest.name
    $vendor = $manifest.vendor
    $done_msg

	
    printf "$info_msg checking repository '$package' from '$vendor'... "
    git ls-remote "git@github.com:$vendor/$package" -q 2> $null
    if (!$?) {
        $error_msg
        printf "$error_msg repository does not appear to exist. aborting.`n"
        continue
    }
    else {
        $done_msg
    }

    printf "$info_msg cloning package '${package}'... "
    if (test-path "$(get_tmp)/${vendor}-${package}") {
        remove-item -r -fo "$(get_tmp)/${vendor}-${package}"
    }
    git clone -q "https://github.com/$vendor/$package" "$(get_tmp)/${vendor}-${package}" > $null
    $done_msg

    if ($manifest.global -eq "true" -and $global -eq $false) {
        $install_global = $true
        printf "$warn_msg installing this package as global!`n"
    }
    else {
        $install_global = $global
    }
	
    if ($install_global) {
        printf "$info_msg adding $package to your path... "
        copy-item -r -fo "$(get_tmp)/${vendor}-${package}" "$(get_pkgdir)/${vendor}-${package}"
        cd "$(get_pkgdir)/${vendor}-${package}"
        foreach ($file in $manifest.bin) {
            create_shim $file | out-null
        }
        $done_msg
    }
    else {
        printf "$info_msg copying $package to current dir... "
        ensure "./deps/" >  $null
        copy-item -r -fo "$(get_tmp)/${vendor}-${package}" "./deps/${vendor}-${package}"
        $done_msg
    }
    ""
}

pop-location