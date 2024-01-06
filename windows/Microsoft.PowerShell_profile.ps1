[Console]::OutputEncoding = [System.Text.Encoding]::UTF8
[Console]::InputEncoding = [System.Text.Encoding]::UTF8
$PSDefaultParameterValues["*:Encoding"] = "utf8"

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

Set-PSReadLineOption -Colors @{ "InlinePrediction"="`e[38;2;153;169;179m" }

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

if (Get-Command -ErrorAction SilentlyContinue oh-my-posh) {
    oh-my-posh --config "${ENV:HOMEDRIVE}${ENV:HOMEPATH}\.config\oh-my-posh\config.toml" init pwsh | Invoke-Expression
}

if (Get-Command -ErrorAction SilentlyContinue uutils) {
    Remove-Alias -Name @(
        "cat"
        "cp"
        "echo"
        "ls"
        "mv"
        "pwd"
        "rm"
        "rmdir"
    )

    function ls_impl { ls.exe --color=auto $Args }
    Set-Alias -Name "ls" -Value "ls_impl"

    # mkdirはPowershellでは組み込みの関数なのでエイリアスで上書き
    Set-Alias -Name "mkdir" -Value "mkdir.exe"
}
