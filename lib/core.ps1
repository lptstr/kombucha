function getversion() {
	"1.0.0"
}

# Test the internst connection
function test_internet() {
	$conn = (Test-Connection -ComputerName google.com -Count 2 -Quiet)
	return $conn
}

function is_installed($pkg) {
	$isin = $false
	$packages = @()	
	$manifestobj = get-content './kombucha.json' | convertfrom-json
	$manifest = @{}
	$manifestobj.psobject.properties | Foreach { $manifest[$_.Name] = $_.Value }
	foreach ($package in $manifest.packages.package) {
		$packages += $package
	}
	foreach ($package in $packages) {
		if ($pkg -eq $package) {
			$isin = $true
		}
	}
	return $isin
}

function update_manifest($pkg, $ver) {
	$i = 0
	$pos = 0
	$manifest = get-content './kombucha.json' | convertfrom-json
	foreach ($package in $manifest.packages.package) {
		if ($package -eq $pkg) {
			$pos = $i
			break
		}
		$i++
	}
	($manifest.packages[$pos]).version = $ver
	set-content './kombucha.json' ($manifest | convertto-json)
}

# Get's the User Agent, if your program downloads something from the internet.
function Get-UserAgent() {
	$version = getversion
	return ("Kombucha/v$version (+http://github.com/lptstr/kombucha/) PowerShell/$($PSVersionTable.PSVersion.Major).$($PSVersionTable.PSVersion.Minor) (Windows NT $([System.Environment]::OSVersion.Version.Major).$([System.Environment]::OSVersion.Version.Minor); $(if($env:PROCESSOR_ARCHITECTURE -eq 'AMD64'){'Win64; x64; '})$(if($env:PROCESSOR_ARCHITEW6432 -eq 'AMD64'){'WOW64; '})$PSEdition)")
}


function abort($msg, [int] $exit_code=1) { write-host $msg -f red; exit $exit_code }
function error($msg) { write-host "ERROR $msg" -f darkred }
function warn($msg) {  write-host "WARN  $msg" -f darkyellow }
function info($msg) {  write-host "INFO  $msg" -f darkgray }
function debug($obj) {
    if((get_config 'debug' $false) -ine 'true') {
        return
    }

    $prefix = "DEBUG[$(Get-Date -UFormat %s)]"
    $param = $MyInvocation.Line.Replace($MyInvocation.InvocationName, '').Trim()
    $msg = $obj | Out-String -Stream

    if($null -eq $obj -or $null -eq $msg) {
        Write-Host "$prefix $param = " -f DarkCyan -NoNewline
        Write-Host '$null' -f DarkYellow -NoNewline
        Write-Host " -> $($MyInvocation.PSCommandPath):$($MyInvocation.ScriptLineNumber):$($MyInvocation.OffsetInLine)" -f DarkGray
        return
    }

    if($msg.GetType() -eq [System.Object[]]) {
        Write-Host "$prefix $param ($($obj.GetType()))" -f DarkCyan -NoNewline
        Write-Host " -> $($MyInvocation.PSCommandPath):$($MyInvocation.ScriptLineNumber):$($MyInvocation.OffsetInLine)" -f DarkGray
        $msg | Where-Object { ![String]::IsNullOrWhiteSpace($_) } |
            Select-Object -Skip 2 | # Skip headers
            ForEach-Object {
                Write-Host "$prefix $param.$($_)" -f DarkCyan
            }
    } else {
        Write-Host "$prefix $param = $($msg.Trim())" -f DarkCyan -NoNewline
        Write-Host " -> $($MyInvocation.PSCommandPath):$($MyInvocation.ScriptLineNumber):$($MyInvocation.OffsetInLine)" -f DarkGray
    }
}
function success($msg) { write-host $msg -f darkgreen }

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

