# PSYadm - Yet Another Dotfiles Manager Write In Powershell

PSYadm is a tool for managing dotfiles.
PSYadm is [yadm](https://github.com/TheLocehiliosan/yadm) rewrite with powrshell
    - Based on Git, with full range of Git's features

## Install

```ps1
Install-Script -Name yadm
```

## A very quick tour

```ps1
# Initialize a new repository
yadm init

# Clone an existing repository
yadm clone <url>

# Add files/changes
yadm add <important file>
yadm commit
```

## Finished

the following commands are supported currently

```ps1
yadm init [-f]             - Initialize an empty repository
yadm clone <url> [-f]      - Clone an existing repository
yadm list [-a]             - List tracked files
yadm bootstrap             - Execute $HOME/.config/yadm/bootstrap.ps1
yadm enter [COMMAND]       - Run sub-shell with GIT variables set
yadm encrypt               - Encrypt files
yadm decrypt               - Decrypt files
```

> `yadm encrypt` and `yadm decrypt` only support `gpg` now

## Todo

the following command have not been finished

```ps1
yadm decrypt [-l]          - Decrypt files
yadm alt                   - Create links for alternates
yadm perms                 - Fix perms for private files
yadm enter [COMMAND]       - Run sub-shell with GIT variables set
yadm git-crypt [OPTIONS]   - Run git-crypt commands for the yadm repo
yadm transcrypt [OPTIONS]  - Run transcrypt commands for the yadm repo
```
