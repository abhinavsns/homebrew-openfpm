class Openfpm < Formula
  desc "Open scalable framework simulations on heterogeneous architectures"
  homepage "https://openfpm.mpi-cbg.de"
  url "https://github.com/mosaic-group/openfpm.git",
      using:    :git,
      tag:      "v5.0.1",
      revision: "bd6a861e206fb180743de3811f683a7dfc15cacf"
  license "BSD-3-Clause"
  revision 1
  head "https://github.com/mosaic-group/openfpm.git", branch: "master"

  depends_on "cmake" => :build
  depends_on "abhinavsns/homebrew-openfpm/algoim"
  depends_on "abhinavsns/homebrew-openfpm/blitz"
  depends_on "abhinavsns/homebrew-openfpm/libhilbert"
  depends_on "abhinavsns/homebrew-openfpm/parmetis"
  depends_on "boost"
  # OpenFPM 5.0.1 does not compile with Eigen 5
  depends_on "eigen@3"
  depends_on "hdf5-mpi"
  depends_on "metis"
  depends_on "open-mpi"
  depends_on "openblas"
  depends_on "petsc"
  depends_on "suite-sparse"
  depends_on "vc"

  # openfpm_numerics clones these headers while building, which Homebrew's sandbox does not allow
  resource "minter" do
    url "https://git.mpi-cbg.de/mosaic/software/math/minter.git",
        revision: "7dbb0b29f04cfe058b0cd3236636a169b359977b"
  end

  def install
    # The DCPSE operators keep a sign in a plain char, which is unsigned on Linux/ARM64: -1 becomes
    # 255 there and every even-order derivative is wrong
    inreplace %w[openfpm_numerics/src/DCPSE/Dcpse.hpp openfpm_numerics/src/DCPSE/Dcpse.cuh],
              "char sign = 1;", "int sign = 1;"
    # Boost.System is header-only, and Boost 1.89 removed its stub library
    inreplace "CMakeLists.txt", "program_options system filesystem", "program_options filesystem"
    # Boost.Odeint resizes states by dispatching on boost::true_type up to Boost 1.85, but on
    # std::true_type in current versions: programs using OpenFPM's ODE integrators did not compile
    inreplace "openfpm_numerics/src/OdeIntegrators/OdeIntegrators.hpp", "boost::true_type", "std::true_type"
    (buildpath/"minter").install resource("minter")
    inreplace "openfpm_numerics/CMakeLists.txt" do |s|
      s.sub! "GIT_REPOSITORY https://git.mpi-cbg.de/mosaic/software/math/minter.git",
             "SOURCE_DIR #{buildpath}/minter"
      s.sub! "GIT_TAG origin/header_only", 'DOWNLOAD_COMMAND ""'
    end

    ENV["CC"] = formula_opt_bin("open-mpi")/"mpicc"
    ENV["CXX"] = formula_opt_bin("open-mpi")/"mpicxx"
    args = %W[
      -DCMAKE_POLICY_VERSION_MINIMUM=3.5
      -DCMAKE_CXX_FLAGS=-fsigned-char
      -DSE_CLASS1=OFF
      -DSE_CLASS2=OFF
      -DSE_CLASS3=OFF
      -DTEST_COVERAGE=OFF
      -DSCAN_COVERTY=OFF
      -DTEST_PERFORMANCE=OFF
      -DENABLE_ASAN=OFF
      -DENABLE_NUMERICS=ON
      -DENABLE_GARBAGE_INJECTOR=OFF
      -DENABLE_VCLUSTER_GARBAGE_INJECTOR=OFF
      -DMPI_VENDOR=openmpi
      -DMPI_ROOT=#{formula_opt_prefix("open-mpi")}
      -DPETSC_ROOT=#{formula_opt_prefix("petsc")}
      -DBOOST_ROOT=#{formula_opt_prefix("boost")}
      -DBoost_NO_BOOST_CMAKE=ON
      -DHDF5_ROOT=#{formula_opt_prefix("hdf5-mpi")}
      -DLIBHILBERT_ROOT=#{formula_opt_prefix("abhinavsns/homebrew-openfpm/libhilbert")}
      -DBLITZ_ROOT=#{formula_opt_prefix("abhinavsns/homebrew-openfpm/blitz")}
      -DALGOIM_ROOT=#{formula_opt_prefix("abhinavsns/homebrew-openfpm/algoim")}
      -DPARMETIS_ROOT=#{formula_opt_prefix("abhinavsns/homebrew-openfpm/parmetis")}
      -DMETIS_ROOT=#{formula_opt_prefix("metis")}
      -DOPENBLAS_ROOT=#{formula_opt_prefix("openblas")}
      -DSUITESPARSE_ROOT=#{formula_opt_prefix("suite-sparse")}
      -DEIGEN3_ROOT=#{formula_opt_prefix("eigen@3")}
      -DVc_ROOT=#{formula_opt_prefix("vc")}
    ]
    system "cmake", "-S", ".", "-B", "build", *args, *std_cmake_args
    # Build only what is installed: the unit tests are most of the work. Each compiler process
    # needs several GB of memory for OpenFPM's templates.
    system "cmake", "--build", "build", "--parallel", [ENV.make_jobs, 2].min.to_s, "--target",
           "ofpmmemory", "ofpmmemory_dl", "vcluster", "vcluster_dl", "ofpm_pdata", "ofpm_pdata_dl", "minter"
    system "cmake", "--install", "build"
    # The headers include the generated config.h, which the install step does not copy
    (prefix/"openfpm_pdata/include/config").install "build/config/config.h"
  end

  test do
    # Distribute particles over two processes (decomposed with ParMETIS), exchange them, and
    # integrate dx/dt = -x on them with Boost.Odeint
    (testpath/"test.cpp").write <<~CPP
      #include "Vector/vector_dist.hpp"
      #include "Operators/Vector/vector_dist_operators.hpp"
      #include "OdeIntegrators/OdeIntegrators.hpp"
      struct Decay {
        void operator()(const state_type_1d_ofp& x, state_type_1d_ofp& dxdt, const double t) const {
          dxdt.data.get<0>() = -1.0 * x.data.get<0>();
        }
      };
      int main(int argc, char* argv[]) {
        openfpm_init(&argc, &argv);
        Box<2, double> domain({0.0, 0.0}, {1.0, 1.0});
        size_t bc[2] = {PERIODIC, PERIODIC};
        Ghost<2, double> ghost(0.1);
        vector_dist<2, double, aggregate<double>> particles(0, domain, bc, ghost);
        auto& v_cl = create_vcluster();
        if (v_cl.getProcessUnitID() == 0) {
          for (size_t i = 0; i < 100; i++) {
            particles.add();
            particles.getLastPos()[0] = (i % 10) / 10.0 + 0.05;
            particles.getLastPos()[1] = (i / 10) / 10.0 + 0.05;
            particles.getLastProp<0>() = 1.0;
          }
        }
        particles.map();
        particles.ghost_get<0>();
        size_t n = particles.size_local();
        size_t fewest = n;
        v_cl.sum(n);
        v_cl.min(fewest);
        auto x = getV<0>(particles);
        state_type_1d_ofp state;
        state.data.get<0>() = x;
        boost::numeric::odeint::runge_kutta4<state_type_1d_ofp, double, state_type_1d_ofp, double,
                                             boost::numeric::odeint::vector_space_algebra_ofp> rk4;
        for (int step = 0; step < 10; step++) rk4.do_step(Decay(), state, step * 0.1, 0.1);
        x = state.data.get<0>();
        double error = 0.0;
        for (size_t i = 0; i < particles.size_local(); i++) {
          error = std::max(error, std::abs(particles.getProp<0>(i) - std::exp(-1.0)));
        }
        v_cl.max(error);
        v_cl.execute();
        if (v_cl.getProcessUnitID() == 0) {
          std::cout << "particles: " << n << ", on each process: >= " << fewest << ", ODE error: " << error << std::endl;
        }
        openfpm_finalize();
        return n == 100 && fewest > 0 && error < 1e-5 ? 0 : 1;
      }
    CPP
    includes = %w[openfpm_numerics/include openfpm_pdata/include/config openfpm_pdata/include openfpm_data/include
                  openfpm_vcluster/include openfpm_io/include openfpm_devices/include].map { |d| "-I#{prefix}/#{d}" }
    deps = %w[boost hdf5-mpi petsc metis abhinavsns/homebrew-openfpm/parmetis
              abhinavsns/homebrew-openfpm/libhilbert vc suite-sparse]
    includes += deps.map { |d| "-I#{formula_opt_include(d)}" }
    includes += %W[-I#{formula_opt_include("eigen@3")}/eigen3 -I#{formula_opt_include("suite-sparse")}/suitesparse]
    lib_dirs = %w[openfpm_devices/lib openfpm_pdata/lib openfpm_vcluster/lib].map { |d| prefix/d }
    lib_dirs += deps.map { |d| formula_opt_lib(d) }
    libs = %w[-lvcluster -lofpm_pdata -lofpmmemory -lparmetis -lmetis -lboost_iostreams -lboost_program_options
              -lboost_filesystem -lhdf5 -llibhilbert -lVc -lpetsc]
    rpaths = OS.linux? ? lib_dirs.map { |d| "-Wl,-rpath,#{d}" } : []
    system formula_opt_bin("open-mpi")/"mpicxx", "-std=c++14", "-fsigned-char", "test.cpp", "-o", "test",
           *includes, *lib_dirs.map { |d| "-L#{d}" }, *libs, *rpaths
    assert_match "particles: 100", shell_output("#{formula_opt_bin("open-mpi")}/mpirun -np 2 ./test")
  end
end
