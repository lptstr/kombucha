
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
It is designed so that you can distribute any dependencies **with** your project, and also allows for global installs, like npm or pip.

Kombucha is currently rough-around-the-edges and still in alpha stage.

## Features
- :computer: Cross-platform - works on macOS, Windows, and Linux.
- :moneybag: Absolutely free!
- :clock130: Speed that is best measured by a stopwatch, not a calendar.

## Installation
Kombucha is currently WIP, so there isn't an **(official)** way to install it yet. If you're just dying to try it out, there are to ways to install it:

**NOTE**: Before installing, make sure that you have at least PowerShell 5 (or later) installed with .NET 4+.

- Using [Scoop](https://scoop.sh). Use this method if you are on Windows. Make sure that you have the `extras` bucket installed:
    ```
    $ scoop bucket list
    main
    java
    ...
    extras
    ```
    Then install kombucha:
    ```
    $ scoop install kombucha
    ```
- Using `git`. use this method if you are macOS/Linux.
    ```
    $ git clone git@github.com:lptstr/kombucha.git kombucha
    $ chmod +x bin/kombucha.ps1    # just in case
    $ ln ./bin/kombucha.ps1 ~/bin/kombucha


<!--
## Installation Requirements

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
-->

## TODO
Do you want to contribute? Try implementing these features:
- [x] `install` command
- [x] `info` command
- [ ] `list` command (list globally installed packages)
- [ ] `search` command (which also lists all available packages)
- [ ] `uninstall` command (remove globally installed packages)

## Credits
Thanks to the maintainers of [Scoop](http://github.com/lukesampson/scoop), especially Luke Sampson, from whose repository I stole a lot of stuff.

