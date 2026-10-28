# Conda packages for OpenFPM

`recipes/` contains [rattler-build](https://rattler-build.prefix.dev) recipes for OpenFPM and
for the dependencies that conda-forge does not provide:

| Package | Contents |
|---|---|
| `openfpm` | OpenFPM 5.0.1, installed in `$PREFIX/openfpm` |
| `vcdevel` | Vc 1.4.5 (conda-forge's `vc` is the MSVC runtime) |
| `libhilbert` | libhilbert |
| `algoim` | the header-only algoim version OpenFPM uses |

Everything else (Open MPI, PETSc, HDF5, Boost 1.85, Eigen 3.4, ParMETIS, Blitz++, ...) comes
from conda-forge. The `openfpm` package fixes two upstream problems: it installs OpenFPM's
generated `config.h`, and its DCPSE operators keep their sign in an `int` instead of a plain
`char` (unsigned on Linux/ARM64, where it broke all even-order derivatives).

## Building

```bash
rattler-build build --recipe-dir conda/recipes -c conda-forge
```

builds all packages for the current platform into `output/`, which can be used as a local
channel.

## Publishing

`.github/workflows/conda.yml` builds the packages for linux-64, linux-aarch64, osx-64 and
osx-arm64 whenever `conda/` changes on `main`, adds them to the `conda-channel` branch and
indexes it. GitHub Pages serves that branch as the channel
https://abhinavsns.github.io/homebrew-openfpm. Packages are only ever added, so environments
locked to older builds keep working. To publish a rebuild of the same version, increase
`build.number` in the recipe.

One-time setup: in the repository settings, under *Pages*, deploy from the branch
`conda-channel` (folder `/ (root)`) after the workflow has created it.
