class Parmetis < Formula
  desc "MPI library for graph partitioning and fill-reducing orderings"
  homepage "http://glaros.dtc.umn.edu/gkhome/metis/parmetis/overview"
  url "http://ppmcore.mpi-cbg.de/upload/parmetis-4.0.3.tar.gz"
  sha256 "e7426c78e0ac12b3916e220766b19216ea93b93c049aedfcda4a9c742b4feb9b"
  revision 1

  bottle do
    root_url "https://github.com/abhinavsns/homebrew-openfpm/releases/download/parmetis-4.0.3_1"
    rebuild 1
    sha256 cellar: :any,                 arm64_sonoma: "6e8d64eeebb32dc409d91f566ee76d1a951d9c0d0b2542df2bbf185eaf7ae6f4"
    sha256 cellar: :any,                 ventura:      "9d53ce1ccffecd9489fc92127d74ccec4c7649cce7b04d31b500afb29a2cf441"
    sha256 cellar: :any_skip_relocation, x86_64_linux: "9a39d342945c8ac0671286d88d63eb3321065d6d2186bfcc11592c4c3ecdbd1d"
  end

  depends_on "cmake" => :build

  depends_on "hdf5-mpi"
  depends_on "metis"
  depends_on "open-mpi"

  def install
    ENV["LDFLAGS"] = "-L#{Formula["metis"].lib} -lmetis -lm"
    ENV["CFLAGS"]="-fPIC"
    system "make", "config", "prefix=#{prefix}", "shared=1"
    system "make", "install"
    pkgshare.install "Graphs" # Sample data for test
  end

  # test do
  #  system "mpirun", "#{bin}/ptest", "#{pkgshare}/Graphs/rotor.graph"
  # end
end
