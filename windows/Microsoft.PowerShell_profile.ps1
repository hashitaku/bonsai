[Console]::OutputEncoding = [System.Text.Encoding]::UTF8
[Console]::InputEncoding = [System.Text.Encoding]::UTF8
$PSDefaultParameterValues["*:Encoding"] = "utf8"

$OnViModeChange = {
    if ($args[0] -eq "Command") {
        Write-Host -NoNewLine "`e[2 q"
    } else {
        Write-Host -NoNewLine "`e[0 q"
    }
}

Set-PSReadLineOption -BellStyle None
Set-PSReadLineOption -EditMode Vi
Set-PSReadLineOption -ViModeIndicator Script -ViModeChangeHandler $OnViModeChange

Set-PSReadLineOption -Colors @{ "InlinePrediction"="`e[38;2;153;169;179m" }

# Function List
# https://learn.microsoft.com/en-us/powershell/module/psreadline/about/about_psreadline_functions?view=powershell-7.4
Set-PSReadLineKeyHandler -Key Tab -Function Complete
# [Console]::ReadKey()
# https://github.com/PowerShell/PSReadLine/issues/906
Set-PSReadLineKeyHandler -Chord 'Ctrl+Oem4' -ViMode Insert -Function ViCommandMode
Set-PSReadLineKeyHandler -Chord 'Ctrl+Oem4' -ViMode Command -Function Abort

if (Get-Command -ErrorAction SilentlyContinue fnm) {
    fnm env --use-on-cd --shell power-shell | Out-String | Invoke-Expression
    fnm completions --shell power-shell | Out-String | Invoke-Expression
}

if (Get-Command -ErrorAction SilentlyContinue deno) {
    deno completions powershell | Out-String | Invoke-Expression
}

if (Get-Command -ErrorAction SilentlyContinue rustup) {
    rustup completions powershell rustup | Out-String | Invoke-Expression
}

if (Get-Command -ErrorAction SilentlyContinue uv) {
    uv generate-shell-completion powershell | Out-String | Invoke-Expression
}

if (Get-Command -ErrorAction SilentlyContinue uvx) {
    uvx --generate-shell-completion powershell | Out-String | Invoke-Expression
}

if (Get-Command -ErrorAction SilentlyContinue oh-my-posh) {
    $ENV:VIRTUAL_ENV_DISABLE_PROMPT=1
    oh-my-posh --config "${ENV:HOMEDRIVE}${ENV:HOMEPATH}\.config\oh-my-posh\config.toml" init pwsh | Invoke-Expression
}

if (Get-Command -ErrorAction SilentlyContinue himalaya) {
    himalaya completion powershell | Out-String | Invoke-Expression
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
    function ll_impl { ls.exe --color=auto -l $Args }
    function la_impl { ls.exe --color=auto -Al $Args }
    Set-Alias -Name "ls" -Value "ls_impl"
    Set-Alias -Name "ll" -Value "ll_impl"
    Set-Alias -Name "la" -Value "la_impl"

    # mkdirはPowershellでは組み込みの関数なのでエイリアスで上書き
    Set-Alias -Name "mkdir" -Value "mkdir.exe"
}

if (Get-Command -ErrorAction SilentlyContinue eza) {
    Remove-Alias -Name @(
        "ls"
    )

    function ls_impl { eza.exe --color=auto $Args }
    function ll_impl { eza.exe --color=auto -l $Args }
    function la_impl { eza.exe --color=auto -Al $Args }
    Set-Alias -Name "ls" -Value "ls_impl"
    Set-Alias -Name "ll" -Value "ll_impl"
    Set-Alias -Name "la" -Value "la_impl"
}
