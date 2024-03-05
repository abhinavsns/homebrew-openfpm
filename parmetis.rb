class Parmetis < Formula
  desc "MPI library for graph partitioning and fill-reducing orderings"
  homepage "http://glaros.dtc.umn.edu/gkhome/metis/parmetis/overview"
  url "http://ppmcore.mpi-cbg.de/upload/parmetis-4.0.3.tar.gz"
  sha256 "e7426c78e0ac12b3916e220766b19216ea93b93c049aedfcda4a9c742b4feb9b"
  revision 1

#  bottle do
#    root_url "https://archive.org/download/brewsci/bottles-num"
#    sha256 cellar: :any, sierra:       "ab6deec90cfb0c0c4b432f5e27e0f1c74624cdbf65e7d3bc50c438703588ab45"
#    sha256 cellar: :any, x86_64_linux: "11e90f57b7ffa6201007f5aed5eb747acb5234ed261f6e3fc4c0a2e1f9bb4bf5"
#  end

#  keg_only "formulae in Homebrew-openfpm are keg only"

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