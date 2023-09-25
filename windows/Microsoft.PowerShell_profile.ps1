[Console]::OutputEncoding = [System.Text.Encoding]::UTF8

$OnViModeChange = {
    if ($args[0] -eq "Command") {
        Write-Host -NoNewLine "`e[1 q"
    } else {
        Write-Host -NoNewLine "`e[5 q"
    }
}

Set-PSReadLineOption -BellStyle None
Set-PSReadLineOption -EditMode Vi
Set-PSReadLineOption -ViModeIndicator Script -ViModeChangeHandler $OnViModeChange

Set-PSReadLineKeyHandler -Key Tab -Function Complete
# [Console]::ReadKey()
# https://github.com/PowerShell/PSReadLine/issues/906
Set-PSReadLineKeyHandler -Chord 'Ctrl+Oem4' -ViMode Insert -Function ViCommandMode

if (Get-Command -ErrorAction SilentlyContinue fnm) {
    fnm env --use-on-cd | Out-String | Invoke-Expression
    fnm completions --shell power-shell | Out-String | Invoke-Expression
}

if (Get-Command -ErrorAction SilentlyContinue rustup) {
    rustup completions powershell rustup | Out-String | Invoke-Expression
}

if (Get-Module -ListAvailable -Name posh-git) {
    Import-Module posh-git
}