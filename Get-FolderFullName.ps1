function Get-FolderFullName {
    param(
        [string[]]
        [Parameter(ValueFromPipeline)]
        $Path = (Get-Location)
    )

    process {
        foreach ($P in $Path) {
            $Item   = Get-Item -LiteralPath (Get-FullName $P)
            $Folder = if ($Item.PSIsContainer) {
                $Item.FullName
            } else {
                $Item.DirectoryName
            }            

            $Folder

        } # End foreach path

    } # End proces block

} # End function

('Get-FolderName', 'Get-Folder', 'Folder') | ForEach-Object {
    Set-Alias -Name $_ -Value Get-FolderFullName
}
