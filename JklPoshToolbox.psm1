<#
.NOTES
Created by Jackson Brumbaugh on 2023.09.03
Version: 2023Sep03-JCB
#>

$ModuleLocation = $PSScriptRoot
$ModuleName = Split-Path $ModuleLocation -Leaf

# Remnant from JklFF
# enum Position {
#   QB
#   RB
#   WR
#   TE
# }

$DoNotExportFolderNameArray = @(
  "Help"
)

$ExportFolderNameArray = @(
  "Main",
  "Dev"
)

$LoadFromFolderNameArray = @(
  $ModuleLocation
)

foreach ( $ThisFolder in ($DoNotExportFolderNameArray + $ExportFolderNameArray) ) {
  $LocationName = Join-Path $ModuleLocation ("*" + $ThisFolder + "*")

  if ( Test-Path $LocationName ) {
    $LoadFromFolderNameArray += $LocationName
  } else {
    Write-Warning "Failed to locate $($LocationName)"
  } # End block:if-else LocationName was found

}# End block:foreach Folder (both Export + DoNotExport)

foreach ( $ThisFolderName in $LoadFromFolderNameArray ) {
  $isThisToBeExport = $true

  <#
  Use a match vs a hard -in check in case i got lazy with the folder names
  e.g. "Help" being listed in the array while the full folder name is HelperFuncs
  #>
  foreach ( $ThisDoNotExportKeyword in $DoNotExportFolderNameArray ) {
    if ( $ThisFolderName -match $ThisDoNotExportKeyword ) {
      $isThisToBeExport = $false
    }
  } # End block:foreach Do Not Export Keyword

  <#
  DO NOT USE -Recurse
  Otherwise the HelperCmds children will be exported
  #>
  foreach ( $ThisPs1File in ( Get-ChildItem $ThisFolderName\*.ps1 ) ) {
    # Dot-Sourcing "loads" the *.ps1 file into the module
    . $ThisPs1File.FullName

    if ( $isThisToBeExport ) {
      $FunctionName = $ThisPs1File.BaseName

      # Exporting the function from the file allows users of the module to run the function
      Export-ModuleMember -Function $FunctionName
    } # End block:if Export it

  } # End block:foreach *.ps1 file

} # End block:foreach Folder to Load


$Aliases = (Get-Alias).Where{ $_.Source -eq $ModuleName }
$AliasNames = $Aliases.Name -replace "(.*) ->.*","`$1"
foreach ( $Alias in $AliasNames ) {
  # Lets users use / see the alias
  Export-ModuleMember -Alias $Alias
}
