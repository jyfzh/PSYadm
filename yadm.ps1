
<#PSScriptInfo

.VERSION 1.3

.GUID efddd9c5-72e8-4eab-b5d7-abd9e968ca44

.AUTHOR jyf

.COMPANYNAME

.COPYRIGHT

.TAGS

.LICENSEURI https://github.com/jyfzh/PSYadm/blob/main/LICENSE

.PROJECTURI

.ICONURI

.EXTERNALMODULEDEPENDENCIES 

.REQUIREDSCRIPTS

.EXTERNALSCRIPTDEPENDENCIES

.RELEASENOTES


.PRIVATEDATA

#>

<# 

.DESCRIPTION 
 Yet Another Dotfiles Manager Write In Powershell 

#> 
Param()

$GlobalArgs = $args
$gitDir = "$HOME/.local/share/yadm/repo.git"
$workTree = "$HOME"
$bootstrapFile = "$HOME/.config/yadm/bootstrap.ps1"
$encryptFile = "$HOME/.config/yadm/encrypt"
$archiveFile = "$HOME/.local/share/yadm/archive"

function help
{
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

Files:
  $bootstrapFile  - Script run via: yadm bootstrap
  $gitDir  - yadm's Git repository "
  Write-Host $help
}

function bootstrap
{
    if (Test-Path -Path $bootstrapFile)
    {
        . $bootstrapFile
    } else
    {
        Write-Error "ERROR: Cannot execute bootstrap"
        Write-Error "$bootstrapFile is not an executable program."
    }
}

function init
{
    if ($GlobalArgs[$args.Count-1] -eq '-f')
    {
        Remove-Item -Recurse -Force $gitDir
        $GlobalArgs = $args[0..($args.Count-2)]
    } elseif (Test-Path -Path $gitDir -PathType Container)
    {
        Write-Error "ERROR: Git repo already exists."
        Write-Error "Use '-f' if you want to force it to be overwritten."
        exit
    }
    $command = "git --git-dir=$gitDir $GlobalArgs --bare"
    Invoke-Expression $command
    git --git-dir=$gitDir --work-tree=$workTree config --local status.showUntrackedFiles no
}

function clone
{
    if ($GlobalArgs[$args.Count-1] -eq '-f')
    {
        Remove-Item -Recurse -Force $gitDir
        $GlobalArgs = $args[0..($args.Count-2)]
    } elseif (Test-Path -Path $gitDir -PathType Container)
    {
        Write-Error "ERROR: Git repo already exists."
        Write-Error "Use '-f' if you want to force it to be overwritten."
        exit
    }
    $command = "git $GlobalArgs $gitDir --bare"
    Invoke-Expression $command
    git --git-dir=$gitDir --work-tree=$workTree reset --hard
    git --git-dir=$gitDir --work-tree=$workTree config --local status.showUntrackedFiles no
}

function list
{
    if ($GlobalArgs[$args.Count-1] -eq '-a')
    {
        $command = "git --git-dir=$gitDir ls-files"
        Invoke-Expression $command
    } else
    {
        $command = "git --git-dir=$gitDir --work-tree=$workTree ls-files"
        Invoke-Expression $command
    }
}

function encrypt
{
    $tempfile = New-TemporaryFile
    tar -cvzf $tempfile -T $encryptFile -C $HOME
    gpg -c --output $archiveFile $tempfile
}

function decrypt
{
    $tempfile = New-TemporaryFile
    gpg -o $tempfile -d $archiveFile
    tar -xvzf $tempfile -C $HOME
}


function default
{
    $command = "git --git-dir=$gitDir --work-tree=$workTree $GlobalArgs"
    Invoke-Expression $command
}

if ($GlobalArgs.Count -eq 0)
{
    help
} else
{
    switch ($GlobalArgs[0])
    {
        "help"
        {
            help
        }
        "bootstrap"
        {
            bootstrap
        }
        "init"
        {
            init
        }
        "clone"
        {
            clone
        }
        "list"
        {
            list
        }
        "encrypt"
        {
            encrypt
        }
        "decrypt"
        {
            decrypt
        }
        default
        {
            default
        }
    }
}
