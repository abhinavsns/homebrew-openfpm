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
    root_url "https://github.com/abhinavsns/homebrew-openfpm/releases/download/openfpm-5.0.1"
    rebuild 2
    sha256 cellar: :any,                 arm64_sonoma: "bfb2960e931c7252acf21760eec0199a58c372889a148902882384794470461f"
    sha256 cellar: :any,                 ventura:      "a9b4991554d0368ec4c315f4e45c048145fe3ba27ec53a7fec430c121ff2a3c9"
    sha256 cellar: :any_skip_relocation, x86_64_linux: "84b33926d3cae953fc1b2c8928a82821e24b10bbf7a5ff6a5b4a6be67fe060a2"
  end

  depends_on "cmake" => :build
  depends_on "abhinavsns/homebrew-openfpm/algoim"
  depends_on "abhinavsns/homebrew-openfpm/blitz"
  depends_on "abhinavsns/homebrew-openfpm/libhilbert"
  depends_on "abhinavsns/homebrew-openfpm/parmetis"
  depends_on "boost@1.85"
  depends_on "ccache"
  depends_on "eigen"
  depends_on "hdf5-mpi"
  depends_on "libomp"
  depends_on "open-mpi"
  depends_on "openblas"
  depends_on "petsc"
  depends_on "vc"

  def install
    ENV["CCACHE_DIR"] = "#{Dir.home}/.ccache"
    mkdir_p ENV["CCACHE_DIR"]
    ENV["CXX"] = "mpic++"
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
