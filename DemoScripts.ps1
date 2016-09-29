################################
##Step1: Choco, ConEmu, Posh-Git
################################
 
# Set your PowerShell execution policy
Set-ExecutionPolicy -ExecutionPolicy RemoteSigned -Force

# Install Chocolatey
iwr https://chocolatey.org/install.ps1 -UseBasicParsing | iex

# Install Chocolatey packages
choco install git.install -y
choco install conemu -y

# Install PowerShell modules
Install-PackageProvider NuGet -MinimumVersion '2.8.5.201' -Force
Set-PSRepository -Name PSGallery -InstallationPolicy Trusted
Install-Module -Name 'posh-git'

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
Step3: Profile Settings 
################################

# Creates profile if doesn't exist then edits it
if (!(Test-Path -Path $PROFILE)){ New-Item -Path $PROFILE -ItemType File } ; ise $PROFILE

#----
function prompt {
Write-Host
$E=[char]0x001b; 
Write-Host "$E`[1;33;40m $ENV:USERNAME@ $E`[0m" -NoNewline
if(Test-Administrator) {
write-host "$E[91;107m(Admin) $E`[0m" -NoNewline  }
Write-Host "$E`[97;102m$ENV:COMPUTERNAME$E`[0m" -NoNewline
write-vcsStatus
Write-Host ""
Return "> "

}
function Test-Administrator {
    $user = [Security.Principal.WindowsIdentity]::GetCurrent();
    (New-Object Security.Principal.WindowsPrincipal $user).IsInRole([Security.Principal.WindowsBuiltinRole]::Administrator)
}
#----
Import-Module -Name posh-git

Start-SshAgent

################################
Step4: Git Setup
################################

#----
# Permanently add C:\Program Files\Git\usr\bin to machine Path variable
[Environment]::SetEnvironmentVariable("Path", $env:Path + ";C:\Program Files\Git\usr\bin", "Machine")

#----

# Generate the key and put into the your user profile .ssh directory
ssh-keygen -t rsa -b 4096 -C "ebrugul@hotmail.com" -f $env:USERPROFILE\.ssh\id_rsa

#----
# Copy the public key. Be sure to copy the .pub for the public key
Get-Content $env:USERPROFILE\.ssh\id_rsa.pub | clip

#----

# List ssh keys
ssh-add -l

#----
# Test ssh connection to GitHub
ssh -T git@github.com

#---

git config --global user.email "ebrugul@hotmail.com"
git config --global user.name "Ebru Cucen"
git config --global push.default simple
git config --global core.ignorecase false

# Configure line endings for windows
git config --global core.autocrlf true

#---
#Navigate to the lication and git clone: 
New-Item -Path "C:\" -ItemType "Directory" -Name "Projects" -Force