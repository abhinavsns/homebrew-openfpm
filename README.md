# homebrew-openfpm

This repository contains the homebrew formula for OpenFPM and it dependencies.

## Installation
```
brew tap abhinavsns/homebrew-openfpm
brew install abhinavsns/homebrew-openfpm/openfpm
```
After successful compilation, we have to create the example.mk file in the `$HOME` folder as `.ofpexample.mk`. This can be done by running `create_brew.mk.sh` from the repo. In a future release this will be eliminated via CMake:

and can be configured using the CMake command that brew outputs during the installation.

Whenever compiling an OpenFPM example, please edit the makefile to modify the line `include example.mk` with `include ~/.ofpexample.mk`.
The source code used for compilation can be retreived from `$HOME/Library/Caches/Homebrew/openfpm--git`

Only tested on MacOS Sonoma with Xcode 15 toolchain. Compiles the latest develop branch of OpenFPM.

## Useful Information

After successful compilation, it creates the example.mk file in the `$HOME` folder as `.ofpexample.mk`. Whenever compiling an OpenFPM example, please edit the makefile to modify the line `include example.mk` with `include ~/.ofpexample.mk`
During the install, brew outputs the cmake command that could be used to reconfigure the retreived source.

Sourcing environment variables is not required for an homebrew installation.

## Troubleshoting

If you encouter issues with cmake and hdf5, please unlink hdf5 and try the installation again.
```
brew unlink hdf5
```