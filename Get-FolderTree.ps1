function Get-FolderTree {
    param(
        [string]
        [Parameter(ValueFromPipeline)]
        $Path = (Get-Location),

        [string]
        [ValidateLength(1, 1)]
        $IndentChar = ' ',

        [uint16]
        $IndentSize = 4,

        [string]
        $FileChar = '>',

        [string]
        $DirChar = '|',

        [string]
        $ParentChar = '\',

        [string]
        [ValidateLength(1, 1)]
        $UnderChar = '-',

        [string]
        $DividerChar = ' ',

        [uint16]
        $DividerSize = $IndentSize,

        [switch]
        [Alias('U', 'Under')]
        $ShowUnder,

        [uint16]
        $Depth,

        [string[]]
        $Exclude,

        [string[]]
        $Include,

        [string]
        $Filter,

        [switch]
        [Alias('J', 'Justified')]
        $Justify,

        [switch]
        [Alias('F', 'Files')]
        $File,

        [switch]
        [Alias('B')]
        $Before,

        [switch]
        [Alias('T')]
        $Tally
    )

    begin {
        foreach ($Var in ('DirChar', 'FileChar')) {
            $CurrentValue = (Get-Variable $Var).Value
            if ($CurrentValue -notmatch ' $') {
                Set-Variable -Name $Var -Value ($CurrentValue + ' ')
            }
        }

        $Indent  = $IndentChar  * $IndentSize
        $Divider = $DividerChar * $DividerSize
    }

    process {
        $Parent   = Get-FolderFullName $Path

        $Prms = @{
            LiteralPath = $Parent
            Recurse     = $true
            Directory   = $true
        }

        $Names = (
            'Depth',
            'Exclude',
            'Include',
            'Filter',
            'File'
        )

        foreach ($Name in $Names) {
            if ($Name -in $PSBoundParameters.Keys) {
                $Prms[$Name] = (Get-Variable $Name).Value

                if ($Name -eq 'File') {
                    $Prms['Directory'] = $false
                    $Prms['File']      = $false
                }
            }
        }

        $Children = Get-ChildItem @Prms | Select-Object -ExpandProperty FullName | Sort-Object

        $Items     = , $Parent + $Children
        $ItemStats = @()

        $ReferenceParents = Measure-Parents $Parent
        foreach ($Item in $Items) {
            $InfoItem = Get-Item -LiteralPath $Item

            $ChildChar, $Size = if ($InfoItem.PSIsContainer) {
                $DirChar, (Get-FolderSize $InfoItem).size
            } else {
                $FileChar, $InfoItem.length
            }

            $Name, $Marker = if ($Item -eq $Parent) {
                $Item, ''
            } else {
                (Split-Path $Item -Leaf), $ChildChar
            }

            $Parents    = (Measure-Parents $Item) - $ReferenceParents
            $ItemIndent = $Indent * $Parents
            $PrettySize = Get-PrettySize $Size

            $DisplayName = "$ItemIndent" + "$Marker" + "$Name"

            if ($ShowUnder) {
                $UnderItems  = (
                    ($UnderChar * $IndentSize),
                    $ChildChar.trim()
                )

                $UnderIndent = if ($Before) {
                    $UnderItems[1] + $UnderItems[0]
                } else {
                    $UnderItems[0] + $UnderItems[1]
                }

                $UnderIndent += ' '

                $DisplayName = $DisplayName.replace(($Indent + $ChildChar), $UnderIndent)
            }

            $ItemStats += [PSCustomObject]@{
                Name        = $Name
                Parents     = $Parents
                Size        = $PrettySize
                DisplayName = $DisplayName
            }
        }

        $MaxLen     = 0
        $MaxParents = 0
        foreach ($Stat in $ItemStats) {
            $TestLen     = $Stat.DisplayName.length
            $TestParents = $Stat.Parents

            if ($TestLen -gt $MaxLen) {
                $MaxLen = $TestLen
            }

            if ($TestParents -gt $MaxParents) {
                $MaxParents = $TestParents
            }
        }

        $MaxParents += 1

        if ($Justify) {
            $DisplayBuild = "{0, -$MaxLen}$Divider{1, -$MaxParents}$Divider{2}"
        } else {
            $DisplayBuild = "{0, -$MaxLen}$Divider{1}$Divider{2}"
        }

        foreach ($Stat in $ItemStats) {
            $ParentTally = $Stat.Parents + 1
            $ParentCount = $ParentChar * $ParentTally
            
            if ($Tally) {
                $Pad = if ($MaxParents -gt 9) {
                    2
                } else {
                    1
                }
                $ParentCount = ("{0:D$Pad} " -f $ParentTally) + $ParentCount
            }

            $Display = $DisplayBuild -f $Stat.DisplayName, $ParentCount, $Stat.Size

            Write-Output ($Display)
        }

    } # End process block

} # End function

('T', 'Tree', 'Get-Tree') | ForEach-Object {
    Set-Alias -Name $_ -Value Get-FolderTree
}
