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

function Get-UserAgent() {
	$version = getversion
	return ("Kombucha/v$version (+http://github.com/lptstr/kombucha/) PowerShell/$($PSVersionTable.PSVersion.Major).$($PSVersionTable.PSVersion.Minor) (Windows NT $([System.Environment]::OSVersion.Version.Major).$([System.Environment]::OSVersion.Version.Minor); $(if($env:PROCESSOR_ARCHITECTURE -eq 'AMD64'){'Win64; x64; '})$(if($env:PROCESSOR_ARCHITEW6432 -eq 'AMD64'){'WOW64; '})$PSEdition)")
}

# Test the internst connection
function test_internet() {
	$conn = $true
	try {
		$client = new-object System.Net.Sockets.TcpClient("www.google.com", 80)
	} catch {
		$conn = $false 
	}
	return $conn
}

