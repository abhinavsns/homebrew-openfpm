class Openfpm < Formula
  desc "Open scalable framework simulations on heterogeneous architectures"
  homepage "http://openfpm.mpi-cbg.de"
  url "https://github.com/mosaic-group/openfpm.git",
      using:    :git,
      tag:      "v5.0.1",
      revision: "bd6a861e206fb180743de3811f683a7dfc15cacf"
  license "BSD-3-Clause"
  head "https://github.com/mosaic-group/openfpm.git", branch: "master"

  bottle do
    root_url "https://github.com/abhinavsns/homebrew-openfpm/releases/download/openfpm-5.0"
    rebuild 1
    sha256 cellar: :any,                 arm64_sonoma: "3b15cc5eacec42d5f70eaeb59dc6fd2635a1c3ab523e95ad3a03eb0e0fb87453"
    sha256 cellar: :any,                 ventura:      "e66b8f431a7c4c83b8b8fcf65d3ae62e0b38725965501d1d1def7fff25844759"
    sha256 cellar: :any_skip_relocation, x86_64_linux: "dcecae12455b91a7ef92133f1e1ab8409cb840ef08f0c6b7251758f9c896dfef"
  end

  depends_on "cmake" => :build
  depends_on "abhinavsns/homebrew-openfpm/algoim"
  depends_on "abhinavsns/homebrew-openfpm/blitz"
  depends_on "abhinavsns/homebrew-openfpm/libhilbert"
  depends_on "abhinavsns/homebrew-openfpm/parmetis"
  depends_on "boost@1.85"
  depends_on "ccache"
  depends_on "eigen"
  depends_on "gcc@11"
  depends_on "hdf5-mpi"
  depends_on "libomp"
  depends_on "open-mpi"
  depends_on "openblas"
  depends_on "petsc"
  depends_on "vc"

  def install
    ENV["CCACHE_DIR"] = "#{Dir.home}/.ccache"
    ENV.prepend_path "PATH", Formula["open-mpi"].opt_bin
    ENV["CC"] = "gcc"
    ENV["CXX"] = "g++"
    ENV["HOMEBREW_CC"] = OS.linux? ? "gcc"
    ENV["HOMEBREW_CXX"] = OS.linux? ? "g++"

    mpi_prefix = Formula["open-mpi"].opt_prefix
    mkdir_p ENV["CCACHE_DIR"]
    mkdir_p "build"
    cd "build" do
      system "cmake", "..", *std_cmake_args,
              "-DCMAKE_PREFIX_PATH=$(brew --prefix)",
              "-DCMAKE_BUILD_TYPE=Release",
              "-DSE_CLASS1=OFF",
              "-DSE_CLASS2=OFF",
              "-DSE_CLASS3=OFF",
              "-DTEST_COVERAGE=OFF",
              "-DSCAN_COVERTY=OFF",
              "-DTEST_PERFORMANCE=OFF",
              "-DENABLE_ASAN=OFF",
              "-DENABLE_NUMERICS=ON",
              "-DENABLE_GARBAGE_INJECTOR=OFF",
              "-DENABLE_VCLUSTER_GARBAGE_INJECTOR=OFF",
              "-DMPI_VENDOR=openmpi",
              "-DMPI_CXX_COMPILER=#{Formula["petsc"].opt_bin}/mpic++",
              "-DMPI_C_COMPILER=#{Formula["petsc"].opt_bin}/mpicc",
              "-DMPI_ROOT=#{Formula["petsc"].opt_prefix}",
              "-DPETSC_ROOT=#{Formula["petsc"].opt_prefix}",
              "-DBOOST_ROOT=#{Formula["boost@1.85"].opt_prefix}",
              "-DBoost_NO_BOOST_CMAKE=ON",
              "-DHDF5_ROOT=#{Formula["hdf5-mpi"].opt_prefix}",
              "-DLIBHILBERT_ROOT=#{Formula["abhinavsns/homebrew-openfpm/libhilbert"].opt_prefix}",
              "-DBLITZ_ROOT=#{Formula["abhinavsns/homebrew-openfpm/blitz"].opt_prefix}",
              "-DALGOIM_ROOT=#{Formula["abhinavsns/homebrew-openfpm/algoim"].opt_prefix}",
              "-DPARMETIS_ROOT=#{Formula["abhinavsns/homebrew-openfpm/parmetis"].opt_prefix}",
              "-DMETIS_ROOT=#{Formula["metis"].opt_prefix}",
              "-DOPENBLAS_ROOT=#{Formula["openblas"].opt_prefix}",
              "-DSUITESPARSE_ROOT=#{Formula["suite-sparse"].opt_prefix}",
              "-DEIGEN3_ROOT=#{Formula["eigen"].opt_prefix}",
              "-DCMAKE_CXX_COMPILER_LAUNCHER=ccache",
              "-DCMAKE_C_COMPILER_LAUNCHER=ccache"
      system "make", "-j2", "install"
    end
  end
end
