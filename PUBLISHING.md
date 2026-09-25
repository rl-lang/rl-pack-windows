# Publishing (Windows)

Run `./bump.sh <version>` first, then follow the section you need.

## Chocolatey

1. Update checksums in `choco/tools/chocolateyinstall.ps1` with the
   real SHA256 of the release zip.
2. Test locally: `choco pack choco/rl-lang.nuspec` then install the
   resulting package.
3. Push to the Chocolatey community repo.
4. Users install: `choco install rl-lang`

## WinGet

1. Update the three YAML files in `winget/` with the correct version
   and SHA256 hashes.
2. Place them in the `microsoft/winget-pkgs` directory structure:
   ```
   manifests/r/rl-lang/rl/<version>/
     rl-lang.rl.yaml              (version)
     rl-lang.rl.locale.en-US.yaml (locale)
     rl-lang.rl.installer.yaml    (installer)
   ```
3. Submit a PR to `microsoft/winget-pkgs`.
4. Users install: `winget install rl-lang.rl`
