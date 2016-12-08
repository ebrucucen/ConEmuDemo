################################
##Step1: Choco, ConEmu, Posh-Git
################################
#Check if you are running as Admin: 
function Test-Administrator {
    $user = [Security.Principal.WindowsIdentity]::GetCurrent();
    (New-Object Security.Principal.WindowsPrincipal $user).IsInRole([Security.Principal.WindowsBuiltinRole]::Administrator)
}

if (!(Test-Administrator)){
    
   $Args = '-noprofile -nologo -executionpolicy bypass -file "{0}"' -f $MyInvocation.MyCommand.Path
    Start-Process -FilePath 'powershell.exe' -ArgumentList $Args -Verb RunAs
    exit
}
################################
Step2: ConEmu Features
################################
#Tabs
#FullScreen
#Jump List
#Inside/Context Menu
#Status Bar
#ANSI Escape Character

################################
Step3: Git Setup
################################

#----
# Permanently add C:\Program Files\Git\usr\bin to machine Path variable
[Environment]::SetEnvironmentVariable("Path", $env:Path + ";C:\Program Files\Git\usr\bin", "Machine")

##----## on mac: 
# bash-3.2$ which git                                                                                                                               
## should be :
#/usr/local/bin/git  
#-----

# Generate the key and put into the your user profile .ssh directory
ssh-keygen -t rsa -b 4096 -C "ebrugul@hotmail.com" -f $env:USERPROFILE\.ssh\id_rsa

##----##on mac:
## Ensure that you are in your ~/.ssh folder
#$ cd ~/.ssh

## Create a new ssh key using the 
## email address you used to log into Github.
#$ ssh-keygen -t rsa -C "your_email@domain.com"
#-----

# Copy the public key. Be sure to copy the .pub for the public key
Get-Content $env:USERPROFILE\.ssh\id_rsa.pub | clip

#----#on mac:
#$ pbcopy < ~/.ssh/id_rsa.pub
#-----

# List ssh keys
ssh-add -l

#----
# Test ssh connection to GitHub
ssh -T git@github.com

#---#on mac:
#bash-3.2$ ssh -T git@github.com                                                                                                                   
#The authenticity of host 'github.com (192.30.253.112)' can't be established.                                                                      
#RSA key fingerprint is SHA256:nThbg6kXUpJWGl7E1IGOCspRomTxdCARLviKw6E5SY8.                                                                        
#Are you sure you want to continue connecting (yes/no)? y                                                                                          
#Please type 'yes' or 'no': yes                                                                                                                    
#Warning: Permanently added 'github.com,192.30.253.112' (RSA) to the list of known hosts.                                                                                        
#Enter passphrase for key '/Users/demokritos/.ssh/id_rsa':                                                                                         
#Hi ebrucucen! You've successfully authenticated, but GitHub does not provide shell access.                                                        
##lets try again: 
#bash-3.2$ ssh -T git@github.com                                                                                                                   
#Hi ebrucucen! You've successfully authenticated, but GitHub does not provide shell access. 
#---end of mac

git config --global user.email "ebrugul@hotmail.com"
git config --global user.name "Ebru Cucen"
git config --global push.default simple
git config --global core.ignorecase false

# Configure line endings for windows
git config --global core.autocrlf true

# Get all configuration: 
git config --global --list
#---

#Navigate to the lication and git clone: 
New-Item -Path "C:\" -ItemType "Directory" -Name "Projects" -Force

######
################################
Step3: Profile Settings 
################################

# Creates profile if doesn't exist then edits it
if (!(Test-Path -Path $PROFILE))
{ 
    New-Item -Path $PROFILE -ItemType File 
} 
ise $PROFILE

#get the referenced libraries: 

Set-Location -Path "c:/projects"
git clone "https://github.com/joonro/Get-ChildItem-Color.git" Get-ChildItem-Color

#start of the profile file:
#---- These will be the basic of the profile
function Test-Administrator {
    $user = [Security.Principal.WindowsIdentity]::GetCurrent();
    (New-Object Security.Principal.WindowsPrincipal $user).IsInRole([Security.Principal.WindowsBuiltinRole]::Administrator)
}
function prompt {
    Write-Host
    $E=[char]0x001b; 
    Write-Host "$E`[1;33;40m $ENV:USERNAME@ $E`[0m" -NoNewline
    if(Test-Administrator) {
        write-host "$E[91;107m(Admin) $E`[0m" -NoNewline  
    }
    Write-Host "$E`[97;102m$ENV:COMPUTERNAME$E`[0m" -NoNewline
    Write-vcsStatus
    Write-Host ""
    Return "> "
}
#----
Import-Module -Name posh-git
Stop-SshAgent
Start-SshAgent
#end of profile file
