function Measure-Parents {
    param (
        [string[]]
        [Parameter(ValueFromPipeline)]
        $Path = (Get-Location)
    )

    process {
        foreach ($P in $Path) {
            $FullName     = Get-FullName $P
            $FullPath     = $FullName.replace('/','\').replace('\\','\')
            $PathNoDelims = $FullPath.replace('\','')
            $Parents      = $FullPath.length - $PathNoDelims.length

            # Check if the path is a drive
            $Item = Get-Item -LiteralPath $FullName
            if ( $Item.Name -eq $Item.PSDrive.Root ) {
                $Parents = 0
            }

            $Parents

        }  # End foreach path

    } # End process block

} # End function
