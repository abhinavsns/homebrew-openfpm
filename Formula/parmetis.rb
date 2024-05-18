class Parmetis < Formula
  desc "MPI library for graph partitioning and fill-reducing orderings"
  homepage "http://glaros.dtc.umn.edu/gkhome/metis/parmetis/overview"
  url "http://ppmcore.mpi-cbg.de/upload/parmetis-4.0.3.tar.gz"
  version "4.0.3"
  sha256 "e7426c78e0ac12b3916e220766b19216ea93b93c049aedfcda4a9c742b4feb9b"

  depends_on "cmake" => :build

  depends_on "metis"
  depends_on "open-mpi"
  depends_on "hdf5-mpi"

  def install
    ENV["LDFLAGS"] = "-L#{Formula["metis"].lib} -lmetis -lm"
    ENV["CFLAGS"]="-fPIC"
    system "make", "config", "prefix=#{prefix}", "shared=1"
    system "make", "install"
    pkgshare.install "Graphs" # Sample data for test
  end

  test do
    system "mpirun", "#{bin}/ptest", "#{pkgshare}/Graphs/rotor.graph"
  end
end
