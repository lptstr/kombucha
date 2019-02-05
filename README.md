
<p align="center">
<img src="https://raw.githubusercontent.com/lptstr/lptstr-images/master/proj/mouse/mouse-logos.png" alt="Long live the Ascii Mouse!"/></p>
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
<p align="center"><a href="https://github.com/lptstr/mouse"><img src="https://img.shields.io/github/languages/code-size/lptstr/mouse.svg" alt="Code-Size" /></a>
<a href="https://github.com/lptstr/mouse"><img src="https://img.shields.io/github/repo-size/lptstr/mouse.svg" alt="Repository size" /></a>
 <a href="https://github.com/lptstr/mouse"><img src="https://img.shields.io/badge/lines%20of%20code-3000%2B-yellow.svg" alt="Lines of code" /></a> <a href="https://travis-ci.org/Kiedtl/mouse"><img src="https://travis-ci.org/Kiedtl/mouse.svg?branch=master" alt="Travis-CI" /></a>
<a href="https://github.com/lptstr/mouse/blob/master/LICENSE"><img src="https://img.shields.io/github/license/lptstr/mouse.svg" alt="License" /></a></p>
</p><p align="center"><a href="http://spacemacs.org"><img src="https://cdn.rawgit.com/syl20bnr/spacemacs/442d025779da2f62fc86c2082703697714db6514/assets/spacemacs-badge.svg" /></a></p>


Mouse is a simple, cross-platform way to manage, store, and backup your configuration files using GitHub repositories. Mouse tries to make it easy to manage your configuration files (e.g., like your Powershell profile or your `.vimrc`). It backs up your configuration file by uploading to a GitHub repository. 

## Features
- :computer: (Almost!) completely cross-platform - works on macOS, Windows, and Linux.
- :moneybag: Absolutely free!
- :closed_lock_with_key: AES-256 encryption with Git-Crypt, so you can add your `.authinfo` file to Mouse without any worry.
- :wrench: <del>Mouse worries about updating itself and downloading patches, so you won't have to.</del> **Removed in commit [`598f14e`](https://github.com/lptstr/mouse/commit/598f14e707ef7e28876ead6c14c942dc201b2f95)**
- :sparkles: Intuitive and memorable commands.
- :clock130: Speed that is best measured by a stopwatch, not a calendar.
- Automatically uploads everything to GitHub, so you can take your data to another computer as well.

## Installation Requirements

- Windows 7 SP1+
- [PowerShell 3](https://www.microsoft.com/en-us/download/details.aspx?id=34595) (or later) 
- [.NET Framework 4.5+](https://www.microsoft.com/net/download)
- The Powershell execution policy must be set to RemoteSigned or ByPass.
- [Git](http://git-scm.com) installed and configured.
- [Git LFS](http://github.com/git-lfs/git-lfs) must be installed.
- [Hub](http://github.com/github/hub) must installed and configured.
- [GnuPG](https://gnupg.org/) must be installed (for Git-Crypt)
- [Git-Crypt](http://github.com/agwa/git-crypt/) must be installed.

Most of the above can be installed with [Scoop](http://github.com/lukesampson/scoop) on Windows, and Homebrew on macOS. For example, on Windows one could run:

```powershell
scoop install pwsh git gpg
scoop install git-lfs hub git-crypt
```
...and Scoop would automatically download, install, and add each of these programs to your PATH.

## Installation

#### **Windows**
- Simply run this command in PowerShell:<br>
      ```powershell
      curl 'https://getmouse.surge.sh/' | iex
      ```  
- Or, if you are scared of piping things into `iex`, you can just download the <br>installer instead (check the releases section).

#### **macOS, Linux**
Because the installer is not completely compatible with \*nix systems, I'd recommend that you manually install Mouse using the following steps:
- go to your home directory in a terminal.
- run `mkdir .mouse`, then `cd .mouse`.
- run `mkdir dat`.
- clone this repository into the app directory: `git clone git@github.com:lptstr/mouse.git app`
- `cd` into the dat directory, then run the following commands:
    - `git init `
    - `hub create my-mouse-repo -d "My personal Mouse repository"`
    - `git lfs track "*.zip"` 
    - `git add .gitattributes`
    - `git commit -a -q -m "Initialized Git LFS"`
    - `git-crypt init`
    - `echo "* filter=git-crypt diff=git-crypt" >> .gitattributes`
    - `echo ".gitattributes !filter !diff" >> .gitattributes`
    - `mkdir info`
    - `git add .gitattributes`
    - `git commit -a -q -m "Initialized Git-Crypt"`
    - `git-crypt export-key $HOME/.mouse/git_crypt_key.key`
    - `git-crypt lock`

Once the Mouse installer has completed, you can run `mouse --version` to check that it installed successfully. Try typing `mouse help` for help. By default, Mouse is installed in `$HOME\.mouse\`, and unfortunately this cannot be changed in the current version of Mouse.

**NOTE**: Mouse will automatically export the Git-Crypt key to `$HOME/.mouse/git_crypt_key.key`. It is highly recommended that this file is backed up somewhere safe - if this key is lost, you will lose all your data in Mouse.

## Usage
See the wiki.

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

