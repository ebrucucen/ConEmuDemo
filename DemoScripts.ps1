################################
##Step1: Choco, ConEmu, Posh-Git
################################
#Check if you are running as Admin: 
function Test-Administrator {
    $user = [Security.Principal.WindowsIdentity]::GetCurrent();
    (New-Object Security.Principal.WindowsPrincipal $user).IsInRole([Security.Principal.WindowsBuiltinRole]::Administrator)
}

if (Test-Administrator){
    # Set your PowerShell execution policy
    Set-ExecutionPolicy -ExecutionPolicy RemoteSigned -Force

    # Install Chocolatey
    Invoke-WebRequest https://chocolatey.org/install.ps1 -UseBasicParsing | iex

    #Set Autoconfirmation for installs
    choco feature enable -name=allowGlobalConfirmation
    
    # Install Chocolatey packages
    choco install git.install -y
    choco install conemu -y

    # Install PowerShell modules
    Install-PackageProvider NuGet -MinimumVersion '2.8.5.201' -Force
    Set-PSRepository -Name PSGallery -InstallationPolicy Trusted
    Install-Module -Name 'posh-git'
}
else
{
    write-output "You need to Run as Administrator"
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
