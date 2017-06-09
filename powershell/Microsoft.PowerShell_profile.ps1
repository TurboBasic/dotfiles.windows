### Version: 0.2.0

$__user = "mao"
$__verbose = $False




Function _executeProfile {



  Function _createUserSymlink {
    [cmdletbinding()]
    Param()

    $_users = Resolve-Path "~\.."
    if ( !(Test-Path( Join-Path $_users $userAlias )) ) { 

      Write-Verbose "Create symlink directory $userAlias\ in $_users"
      New-SymLink -Path "$env:USERPROFILE" -SymName $userAlias -Directory

    }
  }




  Function _loadModules {
    [cmdletbinding()]
    Param()

    # Chocolatey profile
    $ChocolateyProfile = "$env:ChocolateyInstall\helpers\chocolateyProfile.psm1"

    Write-Verbose "Load ChocolateyProfile Module..."
    if (Test-Path $ChocolateyProfile) {
      Import-Module "$ChocolateyProfile" -verbose:$__verbose
    } else {
      Write-Verbose "Sorry, no ChocolateyProfile Module found..."
    }



    $m = Join-Path (Split-Path -Parent $Profile) "Modules"

    "Commands", "Environment", "UtilsScoop" | % { 
      Write-Verbose "Load $_ User Module..."
      if (Test-Path(Join-Path $m "$_\$_.psm1")) {
        Import-Module $_ -verbose:$__verbose
      } else {
        Write-Verbose "Sorry, no $_ User Module found..."
      }
    }

  }




  Function _initialize {
    [cmdletbinding()]
    Param()

    $profileDir = Split-Path -Parent $Profile
    Write-Verbose "Profile directory found at $profileDir"


    Write-Verbose "Sourcing Solarized color theme files..."
    . (Join-Path -Path $profileDir -ChildPath $(switch($HOST.UI.RawUI.BackgroundColor.ToString()){'White'{'Set-SolarizedLightColorDefaults.ps1'}'Black'{'Set-SolarizedDarkColorDefaults.ps1'}default{return}}))


    _loadModules -verbose:$__verbose


    Try { 
      Write-Verbose "Load Pshazz..."
      $null = gcm pshazz -ea stop; pshazz init 'default' 
    } Catch { 
      Write-Verbose "Sorry, there is no Pshazz here..."
    }

    _createUserSymlink -verbose:$__verbose


    # Hide some icons from Explorer

    Write-Verbose "Applying some registry tweaks..."
    @("HideIconsFromThisPC.reg") | % {
      if (Test-Path ".\$_") { 
        cmd /c regedit.exe /s $_
      }
    }


    $environmentScript = "Set-Environment.ps1"
    Write-Verbose "Sourcing $environmentScript..."

    $environmentScript = Join-Path $profileDir $environmentScript

    if (Test-Path $environmentScript) {
      . $environmentScript 
    } else {  
      Write-Verbose "Sorry, no $environmentScript script foound..."
    }


  }




  # TODO Update-Help make once a day
  Function _updateHelpFiles {
    [cmdletbinding()]
    Param()

    Write-Verbose "Updating help files..."
    Start-Job -ScriptBlock { Update-Help }       # | out-null

  }





  Set-Variable -Name userAlias -Value $__user -Scope Global
  write-host $PSVersionTable.PSVersion.ToString()

  Write "Entering $profile User profile script..."

  _updateHelpFiles -verbose:$__verbose

  _initialize -verbose:$__verbose



}


_executeProfile
