
function create_shim($path) {
	if(!(test-path $path)) { "shim: couldn't find $path"; exit 1 }
	$path = resolve-path $path # ensure full path

	$shimdir = "~/.kombucha/bin/"
	if(!(test-path $shimdir)) { mkdir -p $shimdir > $null }
	$shimdir = resolve-path $shimdir
	ensure_in_path $shimdir

	$fname_stem = [io.path]::getfilenamewithoutextension($path).tolower()

	$shim = "$shimdir/$fname_stem"

	write-output "#!/usr/bin/env pwsh" > $shim
	write-output "`$path = '$path'" >> $shim
    write-output 'if($myinvocation.expectingInput) { $input | & $path @args } else { & $path @args }' >> $shim
    if ($PSVersionTable.Platform -eq 'Unix') {
		chmod +x $shim
	}
}

function env($name,$val='__get') {
	$target = 'User'
	if($val -eq '__get') { [environment]::getEnvironmentVariable($name,$target) }
	else { [environment]::setEnvironmentVariable($name,$val,$target) }
}

function ensure_in_path($dir) {
	$path = env 'path'
	$dir = resolve-path $dir
	if($path -notmatch [regex]::escape($dir)) {
		Write-Output "[kombucha] adding $dir to your path"
		
		env 'path' "$dir;$path" # for future sessions...
		$env:path = "$dir;$env:path" # for this session
	}
}
