function Get-PrettySize {
    param(
        [long[]]
        [Parameter(
            Mandatory,
            ValueFromPipeline)]
        [Alias('Length')]
        $Size
    )

    process {
        foreach ($S in $Size) {
            $PrettySize = Switch ($S) {
                { $_ / 1TB -gt 0.95 } {
                    $Unit = "TB"
                    $_ / 1TB
                    break
                }
                { $_ / 1GB -gt 0.95 } {
                    $Unit = "GB"
                    $_ / 1GB
                    break
                }
                { $_ / 1MB -gt 0.95 } {
                    $Unit = "MB"
                    $_ / 1MB
                    break
                }
                { $_ / 1KB -gt 0.95 } {
                    $Unit = "KB"
                    $_ / 1KB
                    break
                }
                Default {
                    $Unit = "B"
                    $_
                    break
                }
            }

            $PrettySize = (("{0:N1}" -f $PrettySize) -replace "^0.0$",'0') + " $Unit"

            $PrettySize

        } # End foreach Size

    } # End process block

} # End function
