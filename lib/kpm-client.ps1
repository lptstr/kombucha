function imports {
	param (
		[parameter(mandatory=$true,valuefrompipeline=$true)]
		[alias('p')]
		[string]$Module,
		[alias('d')]
		[string]$ProjectDir = "$($psscriptroot)"
	)
	push-location

	set-location $ProjectDir
	if (!(test-path '.\kombucha.json')) {
		throw [exception]::new("imports: Kombucha does not appear to be initialized in the specified project directory: '${ProjectDir}' .")
		break
	}

	# Get the module version 
	$pos = 0
	$i = 0
	$manifest = get-content '.\kombucha.json' -encoding utf8 | convertfrom-json
	foreach ($package in $manifest.packages.package) {
		if ($package -eq $Module) {
			$pos = $i
		}
		$i++
	}
	$version = ($manifest.packages.version)[$pos]

	set-location packages
	if (($version -eq $null)) {
		throw [exception]::new("imports: The module '$Module' is not installed.")
		break
	}

	set-location $Module
	set-location $version
	
	get-childitem .\*.psd1 | % {
		import-module $_
	}

	pop-location
}
