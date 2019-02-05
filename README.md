
<p align="center">
<img src="https://raw.githubusercontent.com/lptstr/lptstr-images/master/proj/kombucha/kombucha-logo-github.png" alt="Kombucha for ever!"/></p>
<p align="center">
<b><a href="https://github.com/lptstr/mouse#features">Features</a></b>
|
<b><a href="https://github.com/lptstr/mouse#installation-requirements">Installation Requirements</a></b>
|
<b><a href="https://github.com/lptstr/mouse#installation">Installation</a></b>
|
<b><a href="https://github.com/lptstr/mouse/wiki">Usage</a></b>
|
<b><a href="https://github.com/lptstr/mouse#contributing">Contributing</a></b>
</p>

- - -
<p align="center" >
</p>
<p align="center"><a href="https://github.com/lptstr/kombucha"><img src="https://img.shields.io/github/languages/code-size/lptstr/kombucha.svg" alt="Code-Size" /></a>
<a href="https://github.com/lptstr/kombucha"><img src="https://img.shields.io/github/repo-size/lptstr/kombucha.svg" alt="Repository size" /></a>
 <a href="https://github.com/lptstr/kombucha"><img src="https://img.shields.io/badge/lines%20of%20code-1850%2B-green.svg" alt="Lines of code" /></a> <a href="https://travis-ci.org/lptstr/kombucha"><img src="https://travis-ci.org/lptstr/kombucha.svg?branch=master" alt="Travis-CI" /></a>
<a href="https://github.com/lptstr/kombucha/blob/master/LICENSE"><img src="https://img.shields.io/github/license/lptstr/kombucha.svg" alt="License" /></a></p>
</p><p align="center"><a href="http://spacemacs.org"><img src="https://cdn.rawgit.com/syl20bnr/spacemacs/442d025779da2f62fc86c2082703697714db6514/assets/spacemacs-badge.svg" /></a></p>

Kombucha is an extremely simple package manager for PowerShell.
It is designed so that you can distribute the PowerShell modules **with** your project, and makes it easy to import them when you are ready.

## Features
- :computer: Cross-platform - works on macOS, Windows, and Linux.
- :moneybag: Absolutely free!
- :clock130: Speed that is best measured by a stopwatch, not a calendar.

## Installation Requirements

- Windows 7 SP1+
- [PowerShell 3](https://www.microsoft.com/en-us/download/details.aspx?id=34595) (or later), PowerShell 5+ recommended 
- [.NET Framework 4.5+](https://www.microsoft.com/net/download)
- The PowerShellGet module must be installed.


## Installation

#### **Windows**
Try using [Scoop](https://scoop.sh).
```
scoop bucket add extras
scoop install kombucha
```

## Usage
First, `cd` into your project directory.
```
cd <blah>
```
Then, initialize the directory.
```
kombucha init
```
Then, install some packages :grin:
```
kombucha install burnttoast@0.6.3 pslogging
```
Then, in your PowerShell code, you can import the module using the `ko

## Easter eggs
I've buried around 8  easter eggs in Mouse. If you think you've found one, please file an issue with the `easter egg` label!

## Contributing
PR's are welcome, as long as they conform to the basic code style of this repository:
- In the command implementation files (e.g. `libexec/mouse-help.ps1`), the Powershell code should **NOT** use any aliases. (for example, type `Foreach-Object { ... }` instead of `% { ... }`.)
- In the supporting files, such as `lib/core.ps1`, code is expected to use every alias possible (type `gm` instead of `Get-Member`).
Remember to contribute all your work to branch `develop` - master is strictly for finished, tested, debugged code ready for deployment. Contributions to branch `master` **WILL NOT** be accepted.

### Setting up Mouse repository for development
When cloning the Mouse repository, use the `--recurse` parameter because the Mouse repository contains multiple submodules:

**Without SSH**
`git clone http://github.com/lptstr/mouse.git --recurse --verbose --progress`

**With SSH**
`git clone git@github.com:lptstr/mouse.git --recurse --verbose --progress`

Also, make sure when installing Mouse to test and debug new features pushed to the develop branch, to run `mouse develop` to switch to the devlop branch.


### Project Layout
```

source/mouse
| LICENSE			               	The license for Mouse  
| README.md				             The README                
|                                                    
+-------bin					            Main entrypoint for Mouse
|
+-------lib					            Utility scripts and dependencies
|     |                                                
|     +---cows			          	Dependency for cowsay.ps1 
|     |                                            
|     |
|     +---fonts			         	Dependency for figlet.exe 
|     |                                            
|     |                                            
|     \---lib                                       
|                                                  
+---libexec				             Mouse command implementations
|   
+---libsrc                  Mouse submodules and code for lib dependencies  
| 
\---share				              	Shared data
```

## Credits
Thanks to the maintainers of [Scoop](http://github.com/lukesampson/scoop), especially Luke Sampson, from whose repository I stole a lot of stuff.

