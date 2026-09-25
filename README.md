# rl-pack-windows

Windows packaging for [rl-lang](https://github.com/rl-lang/rl-lang):
Chocolatey and WinGet.

## For users

```powershell
choco install rl-lang
winget install rl-lang.rl
```

Both ship the full binary set:
`rl`, `rlc`, `rlt`, `rlrepl`, `rlsp`, `rldocs`, `rlm`.

## For maintainers

One command bumps both targets:

```bash
./bump.sh 2.3.0
./bump.sh --check   # CI runs this
```

Then fill in the real checksums, test, and submit per
[PUBLISHING.md](PUBLISHING.md).

## Layout

| Dir | Target |
|-----|--------|
| `choco/` | Chocolatey nuspec plus install/uninstall scripts |
| `winget/` | WinGet version, installer, and locale manifests |

## License

MIT or Apache 2.0 at your option.
