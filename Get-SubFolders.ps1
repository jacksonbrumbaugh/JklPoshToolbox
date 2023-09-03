function Get-SubFolders {
    [CmdletBinding(DefaultParameterSetName = 'OnlyName')]
    param (
        [string]
        [Parameter(ValueFromPipeline)]
        $Path = (Get-Location),

        [switch]
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
        [Parameter(ParameterSetName = 'ShowBoth',
            Mandatory)]
        [Alias('B')]
        $Both
    )

    process {
        $Item = Get-Item -LiteralPath (Get-FolderFullName $Path)

        $Prms = @{
            LiteralPath = $Item.FullName
            Directory   = $true
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
            'OnlyName' {
                'Name',
                'Name'
            }
            'OnlyFull' {
                'FullName',
                'FullName'
            }
            'ShowBoth' {
                ('Name', 'FullName'),
                'FullName'
            }
        }

        $SubFolders = Get-ChildItem @Prms | Select-Object -Property $SelectProps | Sort-Object -Property $SortProp

        $SubFolders

    } # End process block

} # End function

('D') | ForEach-Object {
    Set-Alias -Name $_ -Value Get-SubFolders
}
