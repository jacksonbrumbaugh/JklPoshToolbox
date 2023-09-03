$LoopAmt  = 4
$UpChar   = 'U'
$DownChar = 'B'

foreach ($Char in ($UpChar, $DownChar)) {
    $Action = Switch ($Char) {
        $UpChar   { 'Push-Location ..' }
        $DownChar { 'Pop-Location' }
    }        
    
    for ( $n = 1; $n -le $LoopAmt; $n++ ) {
        $Chars   = ''.PadLeft($n, $Char)
        $CharNum = $Char + $n
        $Move    = $Chars -replace $Char,"; $Action" -replace "^; ",''
        
        Invoke-Expression ("function Move-$CharNum { $Move }")
        Set-Alias -Name $Chars -Value Move-$CharNum
        Set-Alias -Name $CharNum -Value Move-$CharNum
    }
}
