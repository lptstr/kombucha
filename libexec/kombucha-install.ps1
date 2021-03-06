# Usage: kombucha install [packages] [options]
# Summary: Install packages in a project directory.
# Help: Create the appropriate directories and install packages
# for use in scripts or command-line usage.
#
# Options:
#     -g, --global       Install the package globally.
#     -f, --force        Force installation of package.

. "$psscriptroot/../lib/core.ps1"
. "$psscriptroot/../lib/unix.ps1"
. "$psscriptroot/../lib/shim.ps1"
. "$psscriptroot/../lib/path.ps1"
. "$psscriptroot/../lib/args.ps1"
. "$psscriptroot/../lib/filesys.ps1"

$E = [char]27
$error_msg = "$E[1m$E[38;2;255;10;010merr!$E[0m"
$done_msg = "$E[1m$E[38;2;100;255;80mdone$E[0m"
$ok_msg = "$E[1m$E[38;2;100;255;80mok$E[0m"
$unknown_msg = "$E[1m$E[38;2;250;250;0m???$E[0m"
$warn_msg = "$E[1m$E[38;2;250;250;0mwarn$E[0m"
$info_msg = "$E[1m$E[38;2;120;120;255minfo$E[0m"

$opt, $packages, $errors = getargs $args 'gf' 'global','force'
$global = $opt.global -or $opt.g
$force = $opt.force -or $opt.f

if ($errors) {
    printf "$error_msg argument error: $errors`n"
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
    $g_url = $manifest.git_url
    $f_url = $manifest.file_url
    $platform = $manifest.platform
    $done_msg

    if ($platform) {
        printf "$info_msg checking platform compatibility... "
        if ($platform -eq "win32") {
            if ($IsWindows) {
                $ok_msg
            } 
            else {
                if ($force) {
                    ""
                    printf "$warn_msg platform 'win32' does not match current platform, forcing install anyway.`n"
                }
                else {
                    $error_msg
                    printf "$error_msg platform 'win32' does not match current platform, skipping.`n"
                    continue
                }
            }
        }
        elseif ($platform -eq "linux") {
            if ($IsLinux) {
                $ok_msg
            } 
            else {
                if ($force) {
                    ""
                    printf "$warn_msg platform 'linux' does not match current platform, forcing install anyway."
                }
                else {
                    $error_msg
                    printf "$error_msg platform 'linux' does not match current platform, skipping."
                    continue
                }
            }
        }
        elseif ($platform -eq "darwin") {
            if ($IsMacOS) {
                $ok_msg
            } 
            else {
                if ($force) {
                    ""
                    printf "$warn_msg platform 'darwin' does not match current platform, forcing install anyway."
                }
                else {
                    $error_msg
                    printf "$error_msg platform 'darwin' does not match current platform, skipping."
                    continue
                }
            }
        }
        else {
            $unknown_msg
        }
    }

    if ($g_url) {
        printf "$info_msg checking repository $g_url... "
        git ls-remote "$g_url" -q 2> $null
        if (!$?) {
            $error_msg
            printf "$error_msg repository does not appear to exist. skipping.`n"
            continue
        }
        else {
            $done_msg
        }

        printf "$info_msg cloning package '${package}'... "
        if (test-path "$(get_tmp)/${vendor}-${package}") {
            remove-item -r -fo "$(get_tmp)/${vendor}-${package}"
        }
        git clone -q "$g_url" "$(get_tmp)/${vendor}-${package}" > $null
        $done_msg
    } elseif ($f_url) {
        if (test-path "$(get_tmp)/${vendor}-${package}") {
            remove-item -r -fo "$(get_tmp)/${vendor}-${package}"
        }
        mkdir -p "$(get_tmp)/${vendor}-${package}" > $null

        foreach ($url in $f_url) {
            printf "$info_msg downloading file from $f_url... "
            curl -sSL "$url" > "$(get_tmp)/${vendor}-${package}/$(url_fname $url)"
            $done_msg
        }
    } else {
        printf "$info_msg checking repository '$package' from '$vendor'... "
        git ls-remote "git@github.com:$vendor/$package" -q 2> $null
        if (!$?) {
            $error_msg
            printf "$error_msg repository does not appear to exist. skipping.`n"
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
    }

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