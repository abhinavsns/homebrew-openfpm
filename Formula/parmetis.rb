class Parmetis < Formula
  desc "MPI library for graph partitioning and fill-reducing orderings"
  homepage "http://glaros.dtc.umn.edu/gkhome/metis/parmetis/overview"
  url "http://ppmcore.mpi-cbg.de/upload/parmetis-4.0.3.tar.gz"
  sha256 "e7426c78e0ac12b3916e220766b19216ea93b93c049aedfcda4a9c742b4feb9b"
  revision 2

  depends_on "cmake" => :build
  depends_on "metis"
  depends_on "open-mpi"

  def install
    # The bundled METIS headers use 64-bit indices, but parmetis.h includes Homebrew's metis.h,
    # which uses 32-bit ones: programs then passed int32 arrays to a library expecting int64.
    # Build with the index width of Homebrew's METIS (as conda-forge does).
    inreplace "metis/include/metis.h", "#define IDXTYPEWIDTH 64", "#define IDXTYPEWIDTH 32"
    ENV["LDFLAGS"] = "-L#{formula_opt_lib("metis")} -lmetis -lm"
    ENV["CFLAGS"] = "-fPIC"
    # The build declares CMake 2.8, which CMake 4 only accepts with a policy minimum
    ENV["CMAKE_POLICY_VERSION_MINIMUM"] = "3.5"
    system "make", "config", "prefix=#{prefix}", "shared=1"
    system "make", "install"
    pkgshare.install "Graphs" # Sample data for test
  end

  test do
    (testpath/"test.c").write <<~C
      #include <mpi.h>
      #include <parmetis.h>
      int main(int argc, char **argv) {
        /* Partition a ring of 8 vertices into 2 parts */
        idx_t vtxdist[2] = {0, 8}, xadj[9], adjncy[16], part[8];
        for (idx_t i = 0; i < 8; i++) {
          xadj[i] = 2 * i;
          adjncy[2 * i] = (i + 7) % 8;
          adjncy[2 * i + 1] = (i + 1) % 8;
        }
        xadj[8] = 16;
        idx_t wgtflag = 0, numflag = 0, ncon = 1, nparts = 2, options[3] = {0, 0, 0}, edgecut = 0;
        real_t tpwgts[2] = {0.5, 0.5}, ubvec[1] = {1.05};
        MPI_Init(&argc, &argv);
        MPI_Comm comm;
        MPI_Comm_dup(MPI_COMM_WORLD, &comm);
        int status = ParMETIS_V3_PartKway(vtxdist, xadj, adjncy, NULL, NULL, &wgtflag, &numflag, &ncon,
                                          &nparts, tpwgts, ubvec, options, &edgecut, part, &comm);
        int used[2] = {0, 0};
        for (int i = 0; i < 8; i++) {
          if (part[i] < 0 || part[i] > 1) return 1;
          used[part[i]] = 1;
        }
        MPI_Finalize();
        return status == METIS_OK && used[0] && used[1] && edgecut >= 2 ? 0 : 1;
      }
    C
    system formula_opt_bin("open-mpi")/"mpicc", "test.c", "-I#{include}", "-I#{formula_opt_include("metis")}",
           "-L#{lib}", "-lparmetis", "-L#{formula_opt_lib("metis")}", "-lmetis", "-Wl,-rpath,#{lib}", "-o", "test"
    system formula_opt_bin("open-mpi")/"mpirun", "-np", "1", "./test"
  end
end
