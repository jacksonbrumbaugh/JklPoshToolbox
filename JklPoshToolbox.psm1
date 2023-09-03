# $ExcludeList = "*.private.*"
Get-ChildItem $PSScriptRoot\*.ps1 -Exclude $ExcludeList | ForEach-Object {
    . $_.FullName
}
