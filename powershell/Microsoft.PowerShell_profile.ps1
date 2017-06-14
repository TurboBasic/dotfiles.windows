### Version: 0.2.0

$Global:__user = "mao"
$Global:__profileDir = Split-Path -parent $profile
$Global:profileDir = $__profileDir
$Global:__projects = "d:/0projects"
$Global:__p = $__projects
$Global:__profileSource = "${__projects}/dotfiles.windows/powershell/Microsoft.PowerShell_profile.ps1"
$VerbosePreference = "Continue"      # "SilentlyContinue", "Inquiry", "Stop"

Function cppr { Copy-Item $__profileSource -Destination $__profileDir -Force -Verbose }


Function loadModules {

  # Vendor modules
  $modules = @{
    "Chocolatey module"="$env:ChocolateyInstall\helpers\chocolateyProfile.psm1"
  } 
  
  # User modules
  "Commands", "Environment", "UtilsScoop" | % { 
    $modules.Add( "User module $_", "$profileDir/Modules/$_/$_" )
  }

  $modules.Keys | % { 
    if (Test-Path $modules[$_]) 
      { $m = $modules[$_] }
    else 
      { $m = Split-Path -Leaf $modules[$_] }
    
    Write-Verbose "Loading: $_" 
    Import-Module -force $m

    if( $? ) 
      { Write-Verbose "SUCCESS: Module $_ loaded" }
    else  
      { Write-Verbose "FAILURE: Sorry, no $_ Module found..." }
  }
   

  Write-Verbose "Load Pshazz..."
  Try   { $null = gcm pshazz -ea stop; pshazz init 'default';  Write-Verbose "SUCCESS: Loaded Pshazz"} 
  Catch { Write-Verbose "FAILURE: Sorry, there is no Pshazz here..."  }

}


Function Script:createUserSymlink {
  $_users = Resolve-Path "~\.."
  if ( !(Test-Path( Join-Path $_users $__user )) ) { 
    Write-Verbose "Create symlink directory $userAlias\ in $_users"
    New-SymLink -Path $env:USERPROFILE -SymName $userAlias -Directory
  }
}


Function Script:applyRegistryTweaks {
  Write-Verbose "Applying some registry tweaks..."

  # Hide some icons from Explorer
  , "HideIconsFromThisPC.reg" | % {
    if (Test-Path ".\$_")
      { cmd /c regedit.exe /s $_ }
  }
}


Function loadEnvironmentVariables {
  $environmentScript = "Set-Environment.ps1"
  Write-Verbose "Sourcing $environmentScript..."

  if (Test-Path "$profileDir/$environmentScript")
    { . "$profileDir/$environmentScript" } 
  else  
    { Write-Verbose "Sorry, no $environmentScript script found..." }
}



Function Script:loadThemes {
  Write-Verbose "Sourcing Solarized color theme files..."
  . (Join-Path -Path $profileDir -ChildPath $(switch($HOST.UI.RawUI.BackgroundColor.ToString()){'White'{'Set-SolarizedLightColorDefaults.ps1'}'Black'{'Set-SolarizedDarkColorDefaults.ps1'}default{return}}))
}


# TODO Update-Help make once a day
Function Script:updateHelpFiles {
  Write-Verbose "Updating help files..."
  Start-Job -ScriptBlock { Update-Help }       # | out-null
}


Write-Host $PSVersionTable.PSVersion.ToString()
Write-Host "Entering User profile script $profile ..."


loadModules
createUserSymlink
applyRegistryTweaks
loadEnvironmentVariables
loadThemes
updateHelpFiles
