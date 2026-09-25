# Publishing (Windows)

Run `./bump.sh <version>` and `./fetch-hashes.sh <version>` first,
then follow the section you need.

## Chocolatey

1. Checksums are already filled by `fetch-hashes.sh`; verify them
   against the release page.
2. Test locally in a Windows VM:
   `choco pack choco/rl-lang.nuspec` then install the result.
3. Push to the Chocolatey community repo. Human moderation takes a
   few days and is strict about install/uninstall correctness.
4. Users install: `choco install rl-lang`

## WinGet

Easiest with `komac`:

```
komac update rl-lang.rl --version <version> \
  --urls https://github.com/rl-lang/rl-lang/releases/download/v<version>/rl-windows-x86_64.zip \
        https://github.com/rl-lang/rl-lang/releases/download/v<version>/rl-windows-aarch64.zip
```

or by hand:

1. Hashes are already filled by `fetch-hashes.sh`.
2. Place the files in the `microsoft/winget-pkgs` directory structure:
   ```
   manifests/r/rl-lang/rl/<version>/
     rl-lang.rl.yaml              (version)
     rl-lang.rl.locale.en-US.yaml (locale)
     rl-lang.rl.installer.yaml    (installer)
   ```
3. Submit a PR to `microsoft/winget-pkgs`.
4. Users install: `winget install rl-lang.rl`
