. "$psscriptroot/unix.ps1"

# core.ps1
function ensure($dir) {
    mkdir -p $dir > $null
    return resolve-path $dir
}

function get_tmp {
    if (is_unix) {
        return "/tmp/"
    }
    else {
        return ensure "~/.temp/"
    }
}

function get_pkgdir {
    return ensure "~/.kombucha/pkg/"
}