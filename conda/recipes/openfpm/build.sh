#!/bin/bash
set -euxo pipefail

# The DCPSE operators keep a sign in a plain char, which is unsigned on Linux/ARM64: -1
# becomes 255 there and every even-order derivative is wrong. Use an int.
for header in openfpm_numerics/src/DCPSE/Dcpse.hpp openfpm_numerics/src/DCPSE/Dcpse.cuh; do
  grep -q "char sign = 1;" "$header"
  sed -i.orig 's/char sign = 1;/int sign = 1;/' "$header"
  rm "$header.orig"
done

# Compile through Open MPI's wrappers, which call the conda compilers
export OMPI_CC="$CC" OMPI_CXX="$CXX"
export CC="$PREFIX/bin/mpicc" CXX="$PREFIX/bin/mpicxx"

cmake -S . -B build ${CMAKE_ARGS:-} \
  -DCMAKE_INSTALL_PREFIX="$PREFIX/openfpm" \
  -DCMAKE_PREFIX_PATH="$PREFIX" \
  -DCMAKE_BUILD_TYPE=Release \
  -DCMAKE_POLICY_VERSION_MINIMUM=3.5 \
  -DSE_CLASS1=OFF -DSE_CLASS2=OFF -DSE_CLASS3=OFF \
  -DTEST_COVERAGE=OFF -DSCAN_COVERTY=OFF -DTEST_PERFORMANCE=OFF -DENABLE_ASAN=OFF \
  -DENABLE_NUMERICS=ON -DENABLE_GARBAGE_INJECTOR=OFF -DENABLE_VCLUSTER_GARBAGE_INJECTOR=OFF \
  -DMPI_VENDOR=openmpi -DMPI_ROOT="$PREFIX" \
  -DPETSC_ROOT="$PREFIX" \
  -DBOOST_ROOT="$PREFIX" -DBoost_NO_BOOST_CMAKE=ON \
  -DHDF5_ROOT="$PREFIX" \
  -DLIBHILBERT_ROOT="$PREFIX" \
  -DBLITZ_ROOT="$PREFIX" \
  -DALGOIM_ROOT="$PREFIX" \
  -DPARMETIS_ROOT="$PREFIX" -DMETIS_ROOT="$PREFIX" \
  -DOPENBLAS_ROOT="$PREFIX" \
  -DSUITESPARSE_ROOT="$PREFIX" \
  -DEIGEN3_ROOT="$PREFIX" \
  -DVc_ROOT="$PREFIX"

# Each compiler process needs several GB for OpenFPM's templates
cmake --build build --parallel 2
cmake --install build

# OpenFPM's headers include the generated config.h, but its install step does not copy it
mkdir -p "$PREFIX/openfpm/openfpm_pdata/include/config"
cp build/config/config.h "$PREFIX/openfpm/openfpm_pdata/include/config/config.h"
