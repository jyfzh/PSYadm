
<#PSScriptInfo

.VERSION 1.1

.GUID efddd9c5-72e8-4eab-b5d7-abd9e968ca44

.AUTHOR jyf

.COMPANYNAME

.COPYRIGHT (c) 2023 jyf

.TAGS

.LICENSEURI https://github.com/jyf-111/PSYadm/blob/main/LICENSE

.PROJECTURI

.ICONURI

.EXTERNALMODULEDEPENDENCIES 

.REQUIREDSCRIPTS

.EXTERNALSCRIPTDEPENDENCIES

.RELEASENOTES


.PRIVATEDATA

#> 



<# 

.DESCRIPTION Yet Another Dotfiles Manager Write In Powershell

#> 

Param()

$gitDir = "$HOME/.local/share/yadm/repo.git"
$workTree = "$HOME"

# before exec command 
if ($args.Count -eq 0) {
    $help = "
Usage: yadm <command> [options...]

Manage dotfiles maintained in a Git repository.

Git Commands:
Any Git command or alias can be used as a <command>. It will operate
on yadm's repository and files in the work tree (usually $HOME).

Commands:
  yadm init [-f]             - Initialize an empty repository
  yadm clone <url> [-f]      - Clone an existing repository
  yadm list [-a]             - List tracked files
  yadm bootstrap             - Execute $HOME/.config/yadm/bootstrap.ps1
  yadm enter [COMMAND]       - Run sub-shell with GIT variables set

Files:
  $HOME/.config/yadm/bootstrap.ps1     - Script run via: yadm bootstrap
  $HOME/.local/share/yadm/repo.git - yadm's Git repository "
    Write-Host $help
    exit
}elseif ($args[0] -eq "bootstrap") {
    if (Test-Path -Path "$HOME/.config/yadm/bootstrap.ps1"){
        . $HOME/.config/yadm/bootstrap.ps1
    }else{
        Write-Host "ERROR: Cannot execute bootstrap"
        Write-Host "$HOME/.config/yadm/bootstrap.ps1' is not an executable program."
    }
    exit
}elseif ($args[0] -eq "init") {
    if ($args[$args.Count-1] -eq '-f'){
        Remove-Item -Recurse -Force $gitDir
        $args = $args[0..($args.Count-2)]
    }elseif (Test-Path -Path $gitDir -PathType Container) {
        Write-Host "ERROR: Git repo already exists."
        Write-Host "Use '-f' if you want to force it to be overwritten."
        exit
    } 
    $command = "git --git-dir=$gitDir $args --bare"
    iex $command
}elseif ($args[0] -eq "clone") {
    if ($args[$args.Count-1] -eq '-f'){
        Remove-Item -Recurse -Force $gitDir
        $args = $args[0..($args.Count-2)]
    }elseif (Test-Path -Path $gitDir -PathType Container) {
        Write-Host "ERROR: Git repo already exists."
        Write-Host "Use '-f' if you want to force it to be overwritten."
        exit
    }
    $command = "git $args $gitDir --bare"
    iex $command
}elseif ($args[0] -eq "list"){
    if ($args[$args.Count-1] -eq '-a'){
        $command = "git --git-dir=$gitDir ls-files"
        iex $command
    }else{
        $command = "git --git-dir=$gitDir --work-tree=$workTree ls-files"
        iex $command
    }
}else{
    $command = "git --git-dir=$gitDir --work-tree=$workTree $args"
    iex $command
}


# after exec command
if ($args[0] -eq "init") {
    git --git-dir=$gitDir --work-tree=$workTree config --local status.showUntrackedFiles no
}elseif ($args[0] -eq "clone") {
    git --git-dir=$gitDir --work-tree=$workTree reset --hard
    git --git-dir=$gitDir --work-tree=$workTree config --local status.showUntrackedFiles no
}

