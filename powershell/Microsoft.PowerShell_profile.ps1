### Version: 0.3.0
#Requires -Modules Environment

#region Setting messages
$__messages = @{
  welcome       = "Entering User profile script $profile ..."
}
#endregion


#region Public functions declaration

Function cppr { Copy-Item $__profileSource -Destination $__profileDir -Force -Verbose }


Function cpModules {
  $__modules = @{
    "Commands"    = "$__projects/dotfiles.windows/Powershell/Modules/Commands"
    "Environment" = "$__projects/dotfiles.windows/Powershell/Modules/Environment"
    "UtilsScoop"   = "$__projects/dotfiles.windows/Powershell/Modules/UtilsScoop"
  }
  $__destination = "$profileDir/Modules"

  $__modules.Keys | %{
    Write-Verbose "Copy $($__modules[$_]) to $__destination..."
    Copy-Item $__modules[$_] $__destination -Recurse -Force
  }

}


Function loadModules {

  #region Setting messages

  # Messages
  $__messages = @{
    moduleLoading = "Loading: {0}"
    moduleSuccess = "SUCCESS: {0} loaded"
    moduleFailure = "FAILURE: Sorry, no {0} found..."
  }

  # Vendor & user modules
  $__modules = @{
    "Chocolatey module"="$env:ChocolateyInstall/helpers/chocolateyProfile.psm1"
    "User module Commands"="$profileDir/Modules/Commands/Commands"
    "User module Environment"="$profileDir/Modules/Environment/Environment"
    "User module UtilsScoop"="$profileDir/Modules/UtilsScoop/UtilsScoop"
  }
  #endregion

  $__modules.Keys | % {
    if (Test-Path $__modules[$_])
      { $m = $__modules[$_] }
    else
      { $m = Split-Path -Leaf $__modules[$_] }

    Write-Verbose ($__messages.moduleLoading -f $_)
    Import-Module -force $m

    if( $? )
      { Write-Verbose ($__messages.moduleSuccess -f $_) }
    else
      { Write-Verbose ($__messages.moduleFailure -f $_) }
  }

  $_pshazz = "Pshazz"
  Write-Verbose ($__messages.moduleLoading -f $_pshazz)
  Try   { $null = gcm pshazz -ea stop; pshazz init 'default';  Write-Verbose ($__messages.moduleSuccess -f $_pshazz) }
  Catch { Write-Verbose ($__messages.moduleFailure -f $_pshazz) }
}


Function loadEnvironmentVariables {
  $environmentScript = "Set-Environment.ps1"
  Write-Verbose "Sourcing $environmentScript..."

  if (Test-Path "$profileDir/$environmentScript")
    { . "$profileDir/$environmentScript" }
  else
    { Write-Verbose "Sorry, no $environmentScript script found..." }
}


Function loadProfile {

  Function createUserSymlink {
    $_users = Resolve-Path "~\.."
    if ( !(Test-Path( Join-Path $_users $__user )) ) {
      Write-Verbose "Creating symlink directory $userAlias\ in $_users ..."
      New-SymLink -Path $env:USERPROFILE -SymName $userAlias -Directory
    }
  }


  Function applyRegistryTweaks {
    Write-Verbose "Applying some registry tweaks..."

    # Hide some icons from Explorer
    , "HideIconsFromThisPC.reg" | % {
      if (Test-Path ".\$_")
        { cmd /c regedit.exe /s $_ }
    }
  }


  Function loadThemes {
    Write-Verbose "Sourcing Solarized color theme files..."
    . (Join-Path -Path $profileDir -ChildPath $(switch($HOST.UI.RawUI.BackgroundColor.ToString()){'White'{'Set-SolarizedLightColorDefaults.ps1'}'Black'{'Set-SolarizedDarkColorDefaults.ps1'}default{return}}))
  }


  # TODO Update-Help make once a day
  Function Private:updateHelpFiles {
    Write-Verbose "Updating help files..."
    Start-Job -ScriptBlock { Update-Help }       # | out-null
  }


  #region Setting initial values
  $__assets = @{
    user          = "mao"
    projectDir    = $env:projects
    profileSource = "$env:projects/dotfiles.windows/powershell/Microsoft.PowerShell_profile.ps1"
  }

  $Global:__user =          $__assets.user
  $Global:__projects =      $__assets.projectDir
  $Global:__p =             $__assets.projectDir
  $Global:__profileSource = $__assets.profileSource

  $Global:__profileDir = $Global:profileDir = Split-Path -parent $profile

  # "SilentlyContinue", "Inquiry", "Stop"
  $Global:VerbosePreference = "Continue"
  #endregion


  loadModules
  createUserSymlink
  applyRegistryTweaks
  loadEnvironmentVariables
  loadThemes
  updateHelpFiles
}

#endregion


#region Execution

Write-Host $PSVersionTable.PSVersion.ToString()
Write-Host $__messages.welcome

loadProfile

#endregion
