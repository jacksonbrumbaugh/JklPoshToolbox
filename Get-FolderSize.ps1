function Get-FolderSize {
    param(
        [string]
        $Path = (Get-Location),

        [int]
        $Places = 1
    )

    process {
        $Item = Get-Item -LiteralPath (Get-FolderFullName $Path)

        $TotalSize = 0
        Get-ChildItem -LiteralPath $Item.FullName -File -Recurse |
            Select-Object -ExpandProperty Length |
            ForEach-Object {
                $TotalSize += $_
            }

        $SizeGB = "{0:N$Places}" -f ($TotalSize / 1GB)
        $SizeMB = "{0:N$Places}" -f ($TotalSize / 1MB)
        $SizeKB = "{0:N$Places}" -f ($TotalSize / 1KB)

        $SizeObj = [PSCustomObject]@{
            Size = $TotalSize
            KB   = $SizeKB
            MB   = $SizeMB
            GB   = $SizeGB
        }

        $SizeObj

    } # End Process block

} # End function

( "Get-FS", "FS" ) | ForEach-Object { Set-Alias -Name $_ -Value Get-FolderSize }
