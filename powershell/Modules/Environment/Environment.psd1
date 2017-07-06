@{
  # Script module or binary module file associated with this manifest
  RootModule = 'Environment.psm1'

  # Version number of this module.
  ModuleVersion = '1.0.5'

  # ID used to uniquely identify this module
  GUID = '59aa5901-f7fa-4f03-b0db-b6156cb3807a'

  # Author of this module
  Author = 'Andriy Melnyk'

  # Company or vendor of this module
  CompanyName = 'private'

  # Copyright statement for this module
  Copyright = 'Andriy Melnyk, 2017'

  # Description of the functionality provided by this module
  Description = 'Utilities to manage Environment variables. Support variable expansion, User and Machine scopes'

  # Minimum version of the Windows PowerShell engine required by this module
  PowerShellVersion = '3.0.0'

  # Name of the Windows PowerShell host required by this module
  PowerShellHostName = ''

  # Minimum version of the Windows PowerShell host required by this module
  PowerShellHostVersion = ''

  # Minimum version of the .NET Framework required by this module
  DotNetFrameworkVersion = ''

  # Minimum version of the common language runtime (CLR) required by this
  # module
  CLRVersion = ''

  # Processor architecture (None, X86, Amd64, IA64) required by this module
  ProcessorArchitecture = ''

  # Modules that must be imported into the global environment prior to
  # importing this module
  RequiredModules = @()

  # Assemblies that must be loaded prior to importing this module
  RequiredAssemblies = @()

  # Script files (.ps1) that are run in the caller's environment prior to
  # importing this module
  ScriptsToProcess = @()

  # Type files (.ps1xml) to be loaded when importing this module
  TypesToProcess = @()

  # Format files (.ps1xml) to be loaded when importing this module
  FormatsToProcess = @()

  # Modules to import as nested modules of the module specified in RootModule
  NestedModules = @()

  # Functions to export from this module
  FunctionsToExport = '*'

  # Cmdlets to export from this module
  CmdletsToExport = ''

  # Variables to export from this module
  VariablesToExport = ''

  # Aliases to export from this module
  AliasesToExport = '*'

  # List of all modules packaged with this module
  ModuleList = @()

  # List of all files packaged with this module
  # TODO rename RegistryFunctions
  # TODO rename  ExpandNameInScope
  # TODO rename  Variables
  FileList = @( 'Environment.psd1', 
                'Environment.psm1', 
                'include/Get-Environment.ps1', 
                'include/ExpandNameInScope.ps1'
                'include/Export-Environment.ps1', 
                'include/RegistryFunctions.ps1', 
                'include/Set-Environment.ps1', 
                'include/Set-MachineEnvironment.ps1', 
                'include/Set-UserEnvironment.ps1', 
                'include/Variables.ps1'
  )

  # Private data to pass to the module specified in ModuleToProcess
  PrivateData = @{
    PSData = @{

            # Tags applied to this module. These help with module discovery in online galleries.
            Tags = @(
                "GitHub",
                "Gist",
                "REST",
                "OAuth",
                "Environment"
            )

            # A URL to the license for this module.
            # LicenseUri = ""

            # A URL to the main website for this project.
            ProjectUri = "https://github.com/TurboBasic/dotfiles.windows/tree/master/powershell"

            # A URL to an icon representing this module.
            IconUri = "https://gist.githubusercontent.com/TurboBasic/9dfd228781a46c7b7076ec56bc40d5ab/raw/03942052ba28c4dc483efcd0ebf4bfc6809ed0d0/hexagram3D.png"

            # ReleaseNotes of this module
            ReleaseNotes = ""

        }
  }
}