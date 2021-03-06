﻿@{Version=0.3.0}|Out-Null


function Main {
<# user profile tasks which should not affect Global namespace #>

  [CmdletBinding()] [OutputType([void])] 
  PARAM()

  # @TODO( Turn some Environment Variables On/Off using Hashtable or Array
  # $env.Blacklist = @( 'nodePath', 'nvm_Home' )

  #region constants
  #endregion

  Write-Host $psVersionTable.psVersion.ToString()
  Write-Host $__messages.welcome
}


#region Bootstrap

  $__includes = 
      "$psScriptRoot/profile/*.ps1", 
      "$psScriptRoot/profile/ISE/*.ps1", 
      "$psScriptRoot/profile/_international/*.ps1"

  . "$psScriptRoot/profile/__start/__start.ps1"

#endregion


#region Execution


  Main


#endregion

Import-Module Posh-Git -ErrorAction SilentlyContinue

. "$psScriptRoot/profile/__finish/__finish.ps1"
