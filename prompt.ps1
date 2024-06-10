function prompt {
  $CurrentLocation = Get-Location

  $CurrentDrive = $CurrentLocation.Drive.Name
  $DrivePostFix = ":"

  if ( [string]::IsNullOrEmpty($CurrentDrive) ) {
    $CurrentDrive = "(Network)"

    $DrivePostFix += "/"

  } # End block:if no Drive letter

  $CurrentDrive += $DrivePostFix

  $DriveFolderDelimiter = if ( ($CurrentLocation.Path.split("\")).Count -gt 2 ) { "../" } else { $null }

  $CurrentFolder = Split-Path $CurrentLocation -Leaf

  ("{0}/{1}{2}> " -f $CurrentDrive, $DriveFolderDelimiter, $CurrentFolder)

} # End function Prompt
