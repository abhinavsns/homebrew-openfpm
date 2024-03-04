class Libhilbert < Formula
  desc "Library producing Hilbert indices for multidimensional data"
  homepage "https://github.com/pdebuyl/libhilbert"
  url "http://ppmcore.mpi-cbg.de/upload/libhilbert-master.tar.gz"
  version "1.0.0" # Replace with the actual version
  revision 1
  # Add any dependencies here, for example:
  depends_on "cmake" => :build

  def install
    # Create and move to the build directory
    build_dir = "build"
    mkdir build_dir do
      # Run cmake and make from within the build directory
      system "cmake", "..", *std_cmake_args, "-DBUILD_TESTING=OFF"
      system "make", "install"
    end
  end
end