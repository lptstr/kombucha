function filesize($length) {
    $gb = [math]::pow(2, 30)
    $mb = [math]::pow(2, 20)
    $kb = [math]::pow(2, 10)

    if($length -gt $gb) {
        "{0:n1} GB" -f ($length / $gb)
    } elseif($length -gt $mb) {
        "{0:n1} MB" -f ($length / $mb)
    } elseif($length -gt $kb) {
        "{0:n1} KB" -f ($length / $kb)
    } else {
        "$($length) B"
    }
}


function fname($path) { split-path $path -leaf }
function url_fname($url) { split-path (new-object uri $url).absolutePath -leaf }
function fname($path) { split-path $path -leaf }
function strip_ext($fname) { $fname -replace '\.[^\.]*$', '' }
function strip_filename($path) { $path -replace [regex]::escape((fname $path)) }
function strip_fragment($url) { $url -replace (new-object uri $url).fragment }

function is_directory([String] $path) {
	return (Test-Path $path) -and (Get-Item $path) -is [System.IO.DirectoryInfo]
}

function dl_file($src, $dest) {
	$wc = New-Object Net.Webclient
	$wc.Headers.add('Referer', (strip_filename $src))
	$wc.Headers.Add('User-Agent', (Get-UserAgent))
	$wc.downloadFile($url, $dest)
}
function dl_string($src) {
	$wc = New-Object Net.Webclient
	$wc.headers.add('Referer', (strip_filename $src))
	$wc.Headers.Add('User-Agent', (Get-UserAgent))
	return $wc.downloadString($src)
}

# The following functions convert Windows paths friendly paths and back
# Example,
# C:\Users\misspiggy\Documents\Work\mydocument.docx to ~\documents\work\mydocument.docx
function friendly_path($path) {
	$h = (Get-PsProvider 'FileSystem').home
	if(!$h.endswith('\')) { $h += '\' }
	if($h -eq '\') { return $path }
	return ("$path" -replace ([regex]::escape($h)), "~\").ToLower()
}
function unfriendly_path($path) { return "$path" -replace "~", "$((Get-PsProvider 'FileSystem').home)" }
function relpath($path) { "$($myinvocation.psscriptroot)\$path" } # relative to calling script
