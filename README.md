# homebrew-openfpm

This repository contains the homebrew formula for OpenFPM and it dependencies.

## Installation
```bash
brew tap abhinavsns/homebrew-openfpm
brew install openfpm
```
After successful compilation, we have to create the example.mk file in the `$HOME` folder as `.ofpexample.mk`. This can be done by running `create_brew.mk.sh` from the repo. In a future release this will be eliminated via CMake:

and can be configured using the CMake command that brew outputs during the installation.

Whenever compiling an OpenFPM example, please edit the makefile to modify the line `include example.mk` with `include ~/example.mk`.
To compile again from a fresh clone but using brew dependencies, the following cmake command can be used inside a build folder.
```bash
cmake .. -DCMAKE_PREFIX_PATH=$(brew --prefix) -DCMAKE_CXX_COMPILER_LAUNCHER=ccache -DCMAKE_BUILD_TYPE=Release -DCMAKE_INSTALL_PREFIX=($HOME)/.local/ofp_install -DCMAKE_BUILD_TYPE=Debug -DSE_CLASS1=OFF -DSE_CLASS2=OFF -DSE_CLASS3=OFF -DTEST_COVERAGE=OFF -DSCAN_COVERTY=OFF -DTEST_PERFORMANCE=OFF -DENABLE_ASAN=OFF -DENABLE_NUMERICS=ON -DENABLE_GARBAGE_INJECTOR=OFF -DENABLE_VCLUSTER_GARBAGE_INJECTOR=OFF -DCUDA_ON_BACKEND=NONE -DMPI_VENDOR=openmpi -DMPI_ROOT=$(brew --prefix openmpi) -DPETSC_ROOT=$(brew --prefix petsc) -DBOOST_ROOT=$(brew --prefix boost@1.85) -DBoost_NO_BOOST_CMAKE=ON -DLIBHILBERT_ROOT=$(brew --prefix libhilbert) -DBLITZ_ROOT=$(brew --prefix blitz) -DALGOIM_ROOT=$(brew --prefix algoim) -DPARMETIS_ROOT=$(brew --prefix parmetis) -DMETIS_ROOT=$(brew --prefix metis) -DVc_ROOT=$(brew --prefix vc) -DOPENBLAS_ROOT=$(brew --prefix openblas) -DEIGEN3_ROOT=$(brew --prefix eigen) -DSUITESPARSE_ROOT=$(brew --prefix suitesparse) -DBLAS_ROOT=$(brew --prefix openblas) -DHDF5_ROOT=$(brew --prefix hdf5-mpi)
```

Only tested on MacOS Sonoma with Xcode 15 toolchain. Compiles the latest develop branch of OpenFPM.

## Useful Information

After successful compilation, it creates the example.mk file in the `$HOME` folder as `example.mk`. Whenever compiling an OpenFPM example, please edit the makefile to modify the line `include example.mk` with `include ~/.ofpexample.mk`
During the install, brew outputs the cmake command that could be used to reconfigure the retreived source.

Sourcing environment variables is not required for an homebrew installation.

## Troubleshoting

If you encouter issues with cmake and hdf5, please unlink hdf5 and try the installation again.
```bash
brew unlink hdf5
```
