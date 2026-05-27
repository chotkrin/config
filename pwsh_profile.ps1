# ============================================================================
# 1. Oh My Posh & Environment Initialization
# ============================================================================
oh-my-posh init pwsh --config "$env:POSH_THEMES_PATH\catppuccin_macchiato.omp.json" | Invoke-Expression

if (Get-Command zoxide -ErrorAction SilentlyContinue) {
    Invoke-Expression (zoxide init powershell | Out-String)
}

# ============================================================================
# 2. Linux Commands Aliases & Functions (全面平替 Linux 习惯)
# ============================================================================
Set-Alias vim nvim
Set-Alias ra yazi
Set-Alias ll ls
function grep { $args | Select-String }
function df { Get-Volume | Select-Object Letter, Label, @{Name="Size(GB)";Expression={[math]::round($_.Size/1GB,2)}}, @{Name="Free(GB)";Expression={[math]::round($_.SizeRemaining/1GB,2)}} }
function free { Get-CimInstance Win32_OperatingSystem | Select-Object @{Name="TotalMemory(GB)";Expression={[math]::round($_.TotalVisibleMemorySize/1MB,2)}}, @{Name="FreeMemory(GB)";Expression={[math]::round($_.FreePhysicalMemory/1MB,2)}} }

# 核心工具：which
Set-Alias which Get-Command

# ============================================================================
# 3. Modern Auto-Completion & Suggestions
# ============================================================================
Set-PSReadLineKeyHandler -Key Tab -Function MenuComplete

# 修复 2: 加上 Try-Catch 保护。确保只有在 PSReadLine >= 2.2.6 时才执行，完美向下兼容
try {
    Set-PSReadLineOption -PredictionSource History
    Set-PSReadLineOption -PredictionViewStyle InlineView
    # 使用正确的 Colors 参数，并配上与 Catppuccin 相搭的优雅暗紫色补全残影
    Set-PSReadLineOption -Colors @{ InlinePrediction = '#5b6078' }
} catch {
    # 如果在老版本 PowerShell 上运行，静默跳过高级补全，不报错
}

function yy {
    # 相当于 mktemp
    $tmp = [System.IO.Path]::GetTempFileName()
    
    # 执行 yazi 并传入所有参数 ($args)，同时指定 cwd 写入文件
    yazi $args --cwd-file="$tmp"
    
    # 读取文件内容并在退出时跳转
    if (Test-Path -Path $tmp) {
        $cwd = (Get-Content -Path $tmp | Out-String).Trim()
        if (![string]::IsNullOrEmpty($cwd) -and $cwd -ne $PWD.Path) {
            Set-Location -LiteralPath $cwd
        }
        # 相当于 rm -f
        Remove-Item -Path $tmp -Force -ErrorAction SilentlyContinue
    }
}
