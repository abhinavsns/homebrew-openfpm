class Openfpm < Formula
  desc "Open scalable framework simulations on heterogeneous architectures"
  homepage "https://openfpm.mpi-cbg.de"
  url "https://github.com/mosaic-group/openfpm.git",
      using:    :git,
      tag:      "v5.0",
      revision: "1c9ed20d1e8e42a571d1825f943991c34acacc74"
  license "BSD-3-Clause"
  head "https://github.com/mosaic-group/openfpm.git", branch: "master"

  depends_on "cmake" => :build
  depends_on "abhinavsns/homebrew-openfpm/algoim"
  depends_on "abhinavsns/homebrew-openfpm/blitz"
  depends_on "abhinavsns/homebrew-openfpm/libhilbert"
  depends_on "abhinavsns/homebrew-openfpm/parmetis"
  depends_on "boost"
  depends_on "ccache"
  depends_on "eigen"
  depends_on "hdf5-mpi"
  depends_on "petsc"
  depends_on "vc"

  def install
    clone_path = Pathname.new("#{Dir.home}/openfpm_src")

    clone_path.mkpath

    unless clone_path.exist? && !clone_path.children.empty?
      system "git", "clone", "--recursive", "https://github.com/mosaic-group/openfpm.git", clone_path
    end

    cd clone_path do
      ENV["CCACHE_DIR"] = "#{Dir.home}/.ccache"
      mkdir_p ENV["CCACHE_DIR"]
      ENV["CXX"] = "mpic++"
      FileUtils.mkdir_p "build"
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
               "-DBOOST_ROOT=#{Formula["boost"].opt_prefix}",
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
        system "make", "install"
      end
    end
  end
end
