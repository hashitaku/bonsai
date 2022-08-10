chcp 65001 | Out-Null

$OutputEncoding = [System.Text.Encoding]::GetEncoding('utf-8')

Set-PSReadLineOption -BellStyle None
Set-PSReadLineKeyHandler -Key Tab -Function Complete
Set-PSReadLineKeyHandler -Chord 'Ctrl+[' -Function ViCommandMode

function Prompt {
    Write-Host "$(Get-Location)" `
    -NoNewLine `
    -ForegroundColor Green

    Write-Host ">" `
    -NoNewLine

    return " "
}
