﻿function Send-NetMessage {
<#  
    .SYNOPSIS  
Sends a message to network computers
 
    .DESCRIPTION  
Allows the administrator to send a message via a pop-up textbox to multiple computers
 
    .EXAMPLE  
Send-NetMessage "This is a test of the emergency broadcast system.  This is only a test."
 
Sends the message to all users on the local computer.
 
    .EXAMPLE  
Send-NetMessage "Updates start in 15 minutes.  Please log off." -Computername testbox01 -Seconds 30 -VerboseMsg -Wait
 
Sends a message to all users on Testbox01 asking them to log off.  
The popup will appear for 30 seconds and will write verbose messages to the console. 
    
    .EXAMPLE
".",$Env:Computername | Send-NetMessage "Fire in the hole!" -Verbose
        
Pipes the computernames to Send-NetMessage and sends the message "Fire in the hole!" with verbose output
        
VERBOSE: Sending the following message to computers with a 5 delay: Fire in the hole!
VERBOSE: Processing .
VERBOSE: Processing MyPC01
VERBOSE: Message sent.
        
    .EXAMPLE
Get-ADComputer -filter * | Send-NetMessage "Updates are being installed tonight. Please log off at EOD." -Seconds 60
        
Queries Active Directory for all computers and then notifies all users on those computers of updates.  
Notification stays for 60 seconds or until user clicks OK.
        
    .NOTES  
Author: Rich Prescott  
Blog: blog.richprescott.com
Twitter: @Rich_Prescott
#>

  PARAM(
      [PARAMETER( Mandatory )]
      [string]
      $Message,

      [PARAMETER()]
      [string]
      $Session='*',
    
      [PARAMETER( ValueFromPipeline, ValueFromPipelineByPropertyName )]
      [ALIAS( 'Name' )]
      [string[]]
      $Computername=$env:computername,
    
      [int]
      $Seconds='5',

      [switch]
      $VerboseMsg,

      [switch]
      $Wait
  )
    
  
  
  BEGIN {
      Write-Verbose "Sending the following message to computers with a $Seconds second delay: $Message"
  }
    

  PROCESS {
      ForEach ($Computer in $ComputerName) {
          Write-Verbose "Processing $Computer"
          $cmd = "msg.exe $Session /Time:$($Seconds)"
          if ($Computername) { $cmd += " /SERVER:$($Computer)" }
          if ($VerboseMsg) { $cmd += ' /V' }
          if ($Wait) { $cmd +=  '/W' }
          $cmd += " $($Message)"

          Invoke-Expression $cmd
      }
  }
    
    
  END {
      Write-Verbose 'Message sent.'
  }

}

