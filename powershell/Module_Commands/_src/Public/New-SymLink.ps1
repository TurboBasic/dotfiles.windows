﻿
Function New-SymLink {
    <#
        .SYNOPSIS
Creates a Symbolic link to a file or directory

        .DESCRIPTION
Creates a Symbolic link to a file or directory as an alternative to mklink.exe

        .PARAMETER Path
Name of the path that you will reference with a symbolic link.

        .PARAMETER SymName
Name of the symbolic link to create. Can be a full path/unc or just the name.
If only a name is given, the symbolic link will be created on the current directory that the
function is being run on.

        .PARAMETER File
Create a file symbolic link

        .PARAMETER Directory
Create a directory symbolic link

        .NOTES
Name: New-SymLink
Author: Boe Prox
Created: 15 Jul 2013


        .EXAMPLE
New-SymLink -Path "C:\users\admin\downloads" -SymName "C:\users\admin\desktop\downloads" -Directory

SymLink                             Target                      Type
-------                             ------                      ----
C:\Users\admin\Desktop\Downloads    C:\Users\admin\Downloads    Directory

Description
-----------
Creates a symbolic link to downloads folder that resides on C:\users\admin\desktop.

        .EXAMPLE
New-SymLink -Path "C:\users\admin\downloads\document.txt" -SymName "SomeDocument" -File

SymLink                                Target                                     Type
-------                                ------                                     ----
C:\users\admin\desktop\SomeDocument    C:\users\admin\downloads\document.txt      File

Description
-----------
Creates a symbolic link to document.txt file under the current directory called SomeDocument.
    #>

    [CMDLETBINDING( DefaultParameterSetName='Directory', 
                    SupportsShouldProcess )]
    PARAM (
        [PARAMETER( ParameterSetName='Directory', 
                    Mandatory, 
                    Position=0, 
                    ValueFromPipeline, 
                    ValueFromPipelineByPropertyName )]
        [PARAMETER( ParameterSetName='File', 
                    Mandatory, 
                    Position=0, 
                    ValueFromPipeline, 
                    ValueFromPipelineByPropertyName )]
        [VALIDATESCRIPT({ if (Test-Path $_) 
                            { $True } 
                          else  
                            { Throw "'$_' doesn't exist!" } })]
        [string] 
        $Path,

        [PARAMETER( ParameterSetName='FILE', 
                    Position=1 )]
        [PARAMETER( ParameterSetName='Directory', 
                    Position=1 )]
        [string] 
        $SymName,

        [PARAMETER( ParameterSetName='File', 
                    Position=2 )]
        [switch] 
        $File,

        [PARAMETER( ParameterSetName='Directory', 
                    Position=2 )]
        [switch] 
        $Directory
    )


    BEGIN {
        Try {
            $null = [mklink.symlink]
        } Catch {
            Add-Type @"
                using System;
                using System.Runtime.InteropServices;
     
                namespace mklink
                {
                    public class symlink
                    {
                        [DllImport("kernel32.dll")]
                        public static extern bool CreateSymbolicLink(string lpSymlinkFileName, string lpTargetFileName, int dwFlags);
                    }
                }
"@
        }
    }

    PROCESS {
        #Assume target Symlink is on current directory if not giving full path or UNC
        If ($SymName -notmatch '^(?:[a-z]:\\)|(?:\\\\\w+\\[a-z]\$)') {
            $SymName = '{0}\{1}' -f $pwd, $SymName
        }
        $Flag = @{
            File = 0
            Directory = 1
        }
        If ($PScmdlet.ShouldProcess($Path, 'Create Symbolic Link')) {
            Try {
                $return = [mklink.symlink]::CreateSymbolicLink(
                    $SymName, 
                    $Path, 
                    $Flag[$PScmdlet.ParameterSetName]
                )
                If ($return) {
                    $object = New-Object PSObject -Property @{
                        SymLink = $SymName
                        Target = $Path
                        Type = $PScmdlet.ParameterSetName
                    }
                    $object.pstypenames.insert(0, 'System.File.SymbolicLink')
                    $object
                } Else {
                    Throw 'Unable to create symbolic link!'
                }
            } Catch {
                Write-warning ('{0}: {1}' -f $path, $_.Exception.Message)
            }
        }
    }
 }

