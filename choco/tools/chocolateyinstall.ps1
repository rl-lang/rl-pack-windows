$ErrorActionPreference = "Stop"

$toolsDir = Split-Path -Parent $MyInvocation.MyCommand.Definition
$version = $env:ChocolateyPackageVersion

$url = "https://github.com/rl-lang/rl-lang/releases/download/v$version/rl-windows-x86_64.zip"

$packageArgs = @{
  packageName    = $env:ChocolateyPackageName
  unzipLocation  = $toolsDir
  url            = $url
  url64bit       = $url
  checksum       = "1b5e68c287648be5709a24a5a6342435fdd4627170e7d56cb923f4997da759ef"
  checksumType   = "sha256"
  checksum64     = "1b5e68c287648be5709a24a5a6342435fdd4627170e7d56cb923f4997da759ef"
  checksumType64 = "sha256"
}

Install-ChocolateyZipPackage @packageArgs

$installDir = Join-Path $toolsDir "bin"
New-Item -ItemType Directory -Path $installDir -Force | Out-Null

Copy-Item (Join-Path $toolsDir "rl.exe") $installDir -Force
foreach ($bin in @("rlc.exe", "rlt.exe", "rlrepl.exe", "rlsp.exe", "rldocs.exe", "rlm.exe")) {
  Copy-Item (Join-Path $toolsDir $bin) $installDir -Force -ErrorAction SilentlyContinue
}

$machinePath = [Environment]::GetEnvironmentVariable("Path", "Machine")
if ($machinePath -notlike "*$installDir*") {
  [Environment]::SetEnvironmentVariable("Path", "$machinePath;$installDir", "Machine")
  Write-Host "Added $installDir to system PATH." -ForegroundColor Green
}
