
<p align="center">
<img src="https://raw.githubusercontent.com/lptstr/lptstr-images/master/proj/kombucha/kombucha-logo-github.png" alt="Kombucha for ever!"/></p>
<!--<p align="center">
<b><a href="https://github.com/lptstr/kombucha#features">Features</a></b>
|
<b><a href="https://github.com/lptstr/kombucha#installation-requirements">Installation Requirements</a></b>
|
<b><a href="https://github.com/lptstr/kombucha#installation">Installation</a></b>
|
<b><a href="https://github.com/lptstr/mouse/kombucha#usage">Usage</a></b>
|
<b><a href="https://github.com/lptstr/kombucha#packages">Packages</a></b>
</p>

- - -
<p align="center" >
</p>
<p align="center"><a href="https://github.com/lptstr/kombucha"><img src="https://img.shields.io/github/languages/code-size/lptstr/kombucha.svg" alt="Code-Size" /></a>
<a href="https://github.com/lptstr/kombucha"><img src="https://img.shields.io/github/repo-size/lptstr/kombucha.svg" alt="Repository size" /></a>
 <a href="https://github.com/lptstr/kombucha"><img src="https://img.shields.io/badge/lines%20of%20code-1850%2B-green.svg" alt="Lines of code" /></a> <a href="https://travis-ci.org/lptstr/kombucha"><img src="https://travis-ci.org/lptstr/kombucha.svg?branch=master" alt="Travis-CI" /></a>
<a href="https://github.com/lptstr/kombucha/blob/master/LICENSE"><img src="https://img.shields.io/github/license/lptstr/kombucha.svg" alt="License" /></a></p>
</p><p align="center"><a href="http://spacemacs.org"><img src="https://cdn.rawgit.com/syl20bnr/spacemacs/442d025779da2f62fc86c2082703697714db6514/assets/spacemacs-badge.svg" /></a></p>-->

Kombucha is an extremely simple package manager for PowerShell.
It is designed so that you can distribute the PowerShell modules **with** your project, and makes it easy to import them into your code when you are ready.

## Features
- :computer: Cross-platform - works on macOS, Windows, and Linux.
- :moneybag: Absolutely free!
- :clock130: Speed that is best measured by a stopwatch, not a calendar.


Kombucha is currently WIP, so there isn't a way to install it yet.

<!--## Installation Requirements

- Windows 7 SP1+
- [PowerShell 3](https://www.microsoft.com/en-us/download/details.aspx?id=34595) (or later), PowerShell 5+ recommended 
- [.NET Framework 4.5+](https://www.microsoft.com/net/download)
- The PowerShellGet module must be installed.


## Installation

### **Windows**
Try using [Scoop](https://scoop.sh).
```
scoop install https://raw.githubusercontent.com/lptstr/kombucha/master/.scoop/kombucha.json
```

### **macOS / Linux**
Clone the repository into whatever directory you want, then add the `bin/kombucha.ps1` file to your PATH.
```
git clone https://github.com/lptstr/kombucha.git
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
Then, in your PowerShell code, you can import the module using the `kpm-client.ps1` file that the Kombucha CLI copied into your project directory on init.

First, import that file, the import the modules you installed using the `imports` function:
```powershell
. "$psscriptroot\kpm-client.ps1"
imports 'burnttoast'
imports 'pslogging'

# thousands of lines later...

New-BurntToastNotification # call a function in the 'burnttoast' module
```

Should you need to update or remove a module, you can use the `update` and `uninstall` commands.

Of course, you will not want all the packages to be tracked by Git. Then, after cloning the repository WITHOUT the packages, you can restore then with `kombucha restore`.

## Packages
All packages available on the official PowerShell gallery are available to install with the Kombucha CLI.

## Credits
Thanks to the maintainers of [Scoop](http://github.com/lukesampson/scoop), especially Luke Sampson, from whose repository I stole a lot of stuff.

-->
