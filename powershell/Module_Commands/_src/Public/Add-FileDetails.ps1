Function Add-FileDetails {

  PARAM(
    [PARAMETER( ValueFromPipeline )]
    $fileobject,

    $hash = @{ 
        Artists = 13
        Album   = 14
        Year    = 15
        Genre   = 16
        Title   = 21
        Length  = 27
        Bitrate = 28 
    }
  )



  BEGIN {
    $shell = New-Object -ComObject Shell.Application
  }

  
  PROCESS {
  
    if( !$_.psIsContainer ) {
      $folder = Split-Path $fileobject.FullName
      $file = Split-Path $fileobject.FullName -Leaf
      $shellfolder = $shell.Namespace($folder)
      $shellfile = $shellfolder.ParseName($file)
      Write-Progress 'Adding Properties' $fileobject.FullName
      
      $hash.Keys |
          ForEach-Object {
            $property = $_
            $value = $shellfolder.GetDetailsOf( $shellfile, $hash.$property )
            if( $value -as [Double] ) { 
              $value = [Double]$value 
            }
            $fileobject | 
                Add-Member NoteProperty "Extended_$property" $value -Force
          }
    }
    $fileobject
    
  }

  END {}
  
}