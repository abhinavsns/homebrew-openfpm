# homebrew-openfpm

Homebrew formulae for [OpenFPM](https://openfpm.mpi-cbg.de) 5.0.1 and the dependencies that
Homebrew itself does not provide (ParMETIS, libhilbert, Blitz++, algoim), and conda packages of
OpenFPM.

## Installation with Homebrew

```bash
brew tap abhinavsns/homebrew-openfpm
brew trust abhinavsns/openfpm   # Homebrew 7 loads formulae of third-party taps only after this
brew install abhinavsns/homebrew-openfpm/openfpm
```

Bottles (precompiled packages) exist for Apple Silicon Macs with macOS 15 or newer and for Linux
(x86-64 and ARM64). On Intel Macs, Homebrew compiles OpenFPM and most of its dependencies from
source, which takes hours.

OpenFPM is installed in `$(brew --prefix openfpm)` with its usual layout (`openfpm_pdata/include`,
`openfpm_pdata/lib`, ...), including the generated `openfpm_pdata/include/config/config.h`. It is
built with Homebrew's `boost`, `eigen@3` (OpenFPM 5.0.1 does not compile with Eigen 5), `hdf5-mpi`,
`petsc` and `open-mpi`, and programs using it need their include and library paths as well:
`Formula/createbrewenv.sh` writes them to `~/example.mk` (and `~/.ofpexample.mk`), which the
makefiles of OpenFPM's examples include. The `test do` block of `Formula/openfpm.rb` shows a
complete compile command.

## Conda packages

OpenFPM 5.0.1 is also available as a conda package for Linux (x86-64, ARM64) and macOS
(Intel, Apple Silicon), from the channel https://abhinavsns.github.io/homebrew-openfpm.
All other dependencies come from conda-forge, which keeps old versions available, so a
locked environment keeps installing as Homebrew moves on. With [pixi](https://pixi.sh):
```bash
pixi init myproject -c https://abhinavsns.github.io/homebrew-openfpm -c conda-forge
cd myproject
pixi add openfpm
```
OpenFPM is installed in `$CONDA_PREFIX/openfpm` (`openfpm_pdata/include`,
`openfpm_pdata/lib`, ...). See [conda/README.md](conda/README.md) for how the packages are built.

## Maintenance

The workflow "brew test-bot" checks the formulae on every push. For pull requests, and for pushes
to other branches than `main`, it also builds and tests the changed formulae as bottles on macOS 15
(Apple Silicon) and Linux (x86-64 and ARM64). Once a pull request passes, add the label `pr-pull`
to it (or run the "brew pr-pull" workflow with its number): this uploads the bottles to GitHub
Releases and pushes the commits, with the new bottle blocks, to `main`.

The bottles are built against the Homebrew versions of OpenFPM's dependencies. When Homebrew moves
one of them to a new major version (e.g. HDF5 or PETSc), increase `revision` in
`Formula/openfpm.rb` in a pull request to rebuild them.

## Troubleshooting

If CMake picks up the serial HDF5 instead of `hdf5-mpi`, unlink it and try again:
```bash
brew unlink hdf5
```
