# recipe taken from https://devblackops.io/building-a-simple-release-pipeline-in-powershell-using-psake-pester-and-psdeploy/

[CMDLETBINDING()]
PARAM(
    [String[]]$Task = 'default'
)


<#

if( !(Get-Module -Name PSDepend -ListAvailable) ) { 
  Install-Module PSDepend 
}  
    
$null = Invoke-PSDepend -Path "$psScriptRoot\build.requirements.psd1" -Install -Import -Force    

#>


#TODO(��������� �� ������ ���������� - ������������� �� PSDeploy ������������� ������?)
<#  ������ �� �����, PSDeploy ��� ������ ��� ���� ������������.
 
if (!(Get-Module -Name Pester -ListAvailable))    
    { Install-Module -Name Pester -Scope CurrentUser }
if (!(Get-Module -Name psake -ListAvailable))     
    { Install-Module -Name psake -Scope CurrentUser }
if (!(Get-Module -Name PSDeploy -ListAvailable))  
    { Install-Module -Name PSDeploy -Scope CurrentUser }
    
#>    

Invoke-Psake -buildFile "$psScriptRoot\psakeBuild.ps1" -taskList $Task -Verbose:$VerbosePreference
exit ( [int]( -not $psake.build_success ) )