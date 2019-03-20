function is_unix() { $PSVersionTable.Platform -eq 'Unix' }
function is_mac() { $PSVersionTable.OS.ToLower().StartsWith('darwin') }
function is_linux() { $PSVersionTable.OS.ToLower().StartsWith('linux') }

# install.ps1
function compute_hash($file, $algname) {
    if(is_mac) {
        switch ($algname)
        {
            "md5" { $result = (md5 -q $file) }
            "sha1" { $result = (shasum -ba 1 $file) }
            "sha256" { $result = (shasum -ba 256 $file) }
            "sha512" { $result = (shasum -ba 512 $file) }
            default { $result = (shasum -ba 256 $file) }
        }
    } else {
        switch ($algname)
        {
            "md5" { $result = (md5sum -b $file) }
            "sha1" { $result = (sha1sum -b $file) }
            "sha256" { $result = (sha256sum -b $file) }
            "sha512" { $result = (sha512sum -b $file) }
            default { $result = (sha256sum -b $file) }
        }
    }
    return $result.split(' ') | Select-Object -first 1
}
