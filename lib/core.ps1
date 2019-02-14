function getversion() {
	"0.3.0"
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


