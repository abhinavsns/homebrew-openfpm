#! /bin/bash

# Function to find and add a dependency's include and lib paths
add_dependency_paths() {
  # Include paths
  if [[ -d "$(brew --prefix "$1" || true)/include" ]]
  then
    INCLUDE_PATH="${INCLUDE_PATH} -I$(brew --prefix "$1")/include"
  fi

  # Library paths
  if [[ -d "$(brew --prefix "$1" || true)/lib" ]]
  then
    LIBS_PATH="${LIBS_PATH} -L$(brew --prefix "$1")/lib"
    # Add library link flags as necessary. You might need a specific approach to determine the library names.
  fi
}

# Initialize variables
INCLUDE_PATH=""
LIBS_PATH=""
LIBS=""

# Dependencies array. Ensure these are the correct formula names in Homebrew.
depends=("petsc" "parmetis" "metis" "hdf5-mpi" "libhilbert" "boost@1.85" "vc" "blitz" "algoim" "suitesparse" "libomp")

# Add paths for each dependency
for dep in "${depends[@]}"
do
  add_dependency_paths "${dep}"
done

INCLUDE_PATH="${INCLUDE_PATH} -I$(brew --prefix eigen)/include/eigen3/"
INCLUDE_PATH="${INCLUDE_PATH} -I$(brew --prefix suitesparse)/include/suitesparse/"

# Additional dependencies or paths can be added directly. Adjust as necessary.
INCLUDE_PATH="${INCLUDE_PATH} -I. -I/usr/local/opt/libomp/include"
LIBS_PATH="${LIBS_PATH} -L/usr/local/opt/libomp/lib"
LIBS="${LIBS} -lvcluster -lofpm_pdata -lofpmmemory -lparmetis -lmetis -lboost_iostreams -lboost_program_options -lhdf5 -llibhilbert -lVc -lpetsc -lumfpack -lamd -lbtf -lcamd -lccolamd -lcholmod -lcolamd -lcxsparse -lklu -ldl -lrbio -lspqr -lsuitesparseconfig -lboost_filesystem"

# Assuming `openfpm` is a prefix for related paths, not a dependency to be iterated over.
dep_prefix=$(brew --prefix openfpm)
INCLUDE_PATH="${INCLUDE_PATH} -I${dep_prefix}/openfpm_numerics/include -I${dep_prefix}/openfpm_pdata/include/config -I${dep_prefix}/openfpm_pdata/include -I${dep_prefix}/openfpm_data/include -I${dep_prefix}/openfpm_vcluster/include -I${dep_prefix}/openfpm_io/include -I${dep_prefix}/openfpm_devices/include"
LIBS_PATH="${LIBS_PATH} -L${dep_prefix}/openfpm_devices/lib -L${dep_prefix}/openfpm_pdata/lib -L${dep_prefix}/openfpm_vcluster/lib"

# Generate example.mk
echo "INCLUDE_PATH=${INCLUDE_PATH}" >~/example.mk
echo "LIBS_PATH=${LIBS_PATH}" >>~/example.mk
echo "LIBS=${LIBS}" >>~/example.mk

# Handle CUDA_ON_CPU flag
CUDA_ON_CPU=NO # Default setting

echo "CUDA_ON_CPU=${CUDA_ON_CPU}" >>~/example.mk
cp ~/example.mk ~/.ofpexample.mk
