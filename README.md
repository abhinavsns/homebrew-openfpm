# homebrew-openfpm

This repository contains the homebrew formula for OpenFPM and it dependencies.

## Installation
```
brew tap abhinavsns/homebrew-openfpm
brew install --verbose openfpm
```
After successful compilation, we have to create the example.mk file in the `$HOME` folder as `.ofpexample.mk`.   

```
$HOME/Library/Caches/Homebrew/openfpm--git/script/create_brew.mk.sh
```

Whenever compiling an OpenFPM example, please edit the makefile to modify the line `include example.mk` with `include ~/.ofpexample.mk`
The source code used for compilation can be retreived from `$HOME/Library/Caches/Homebrew/openfpm--git`



Only tested on MacOS. Compiles the latest develop branch of OpenFPM.

## Useful Information

After successful compilation, it creates the example.mk file in the `$HOME` folder as `.ofpexample.mk`. Whenever compiling an OpenFPM example, please edit the makefile to modify the line `include example.mk` with `include ~/.ofpexample.mk`   


Sourcing environment variables is not required for an homebrew installation.

## Troubleshoting

If you encouter issues with cmake and hdf5, please manually install petsc first and then unlink hdf5:
```
brew install petsc
brew unlink hdf5
brew install openfpm
```