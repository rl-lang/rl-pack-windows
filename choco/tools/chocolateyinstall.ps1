$ErrorActionPreference = "Stop"

$toolsDir = Split-Path -Parent $MyInvocation.MyCommand.Definition
$version = $env:ChocolateyPackageVersion

$url = "https://github.com/rl-lang/rl-lang/releases/download/v$version/rl-windows-x86_64.zip"

$packageArgs = @{
  packageName    = $env:ChocolateyPackageName
  unzipLocation  = $toolsDir
  url            = $url
  url64bit       = $url
  checksum       = "e4358a441cbf993a342e3f9236532161a348012101022b960d7a71b5464c9bbf"
  checksumType   = "sha256"
  checksum64     = "e4358a441cbf993a342e3f9236532161a348012101022b960d7a71b5464c9bbf"
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
