function Get-SubFiles {
    [CmdletBinding(DefaultParameterSetName = 'OnlyName')]
    param (
        [string]
        [Parameter(ValueFromPipeline)]
        $Path = (Get-Location),

        [switch]
        [Alias('All')]
        $Recurse,

        [uint16]
        $Depth,

        [string[]]
        $Exclude,

        [string[]]
        $Include,

        [string]
        $Filter,

        [switch]
        [Parameter(ParameterSetName = 'OnlyFull',
            Mandatory)]
        [Alias('Full')]
        $FullName,

        [switch]
        [Parameter(ParameterSetName = 'Both',
            Mandatory)]
        $Both
    )

    process {
        $Item = Get-Item -LiteralPath (Get-FolderFullName $Path)

        $Prms = @{
            LiteralPath = $Item.FullName
            File        = $true
        }

        $Keys = (
            'Recurse',
            'Depth',
            'Exclude',
            'Include',
            'Filter'
        )

        foreach ($Key in $Keys) {
            if ($Key -in $PSBoundParameters.Keys) {
                $Prms[$Key] = (Get-Variable $Key).Value
            }
        }

        $SelectProps, $SortProp = switch ($PSCmdlet.ParameterSetName) {
            'Both' {
                ('Name', 'FullName'),
                'FullName'
            }
            'OnlyName' {
                'Name',
                'Name'
            }
            'OnlyFull' {
                'FullName',
                'FullName'
            }
        }

        $SubFiles = Get-ChildItem @Prms | Select-Object -Property $SelectProps | Sort-Object -Property $SortProp

        $SubFiles

    } # End process block

} # End function

('F') | ForEach-Object {
    Set-Alias -Name $_ -Value Get-SubFiles
}
