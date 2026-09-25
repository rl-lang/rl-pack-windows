$ErrorActionPreference = "Stop"

$toolsDir = Split-Path -Parent $MyInvocation.MyCommand.Definition
$installDir = Join-Path $toolsDir "bin"

foreach ($bin in @("rl.exe", "rlc.exe", "rlt.exe", "rlrepl.exe", "rlsp.exe", "rldocs.exe", "rlm.exe")) {
  Remove-Item (Join-Path $installDir $bin) -Force -ErrorAction SilentlyContinue
}
Remove-Item $installDir -Force -ErrorAction SilentlyContinue
