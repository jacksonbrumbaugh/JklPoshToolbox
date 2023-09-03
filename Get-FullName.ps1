function Get-FullName {
    param(
        [string]
        [Parameter(ValueFromPipeline)]
        $Path = (Get-Location)
    )

    process {
        $Path = $Path -replace '"',""

        $Item = if (-not (Test-Path $Path)) {
            if (-not (Test-Path -LiteralPath $Path)) {
                throw "Cannot run $( $MyInvocation.MyCommand ).  Cannot locate $Path"
            } else {
                Get-Item -LiteralPath $Path
            }
        } else {
            Get-Item $Path
        }

        $Item.FullName

    } # End process block

} # End function
