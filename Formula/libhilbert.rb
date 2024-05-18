class Libhilbert < Formula
  desc "Library producing Hilbert indices for multidimensional data"
  homepage "https://github.com/pdebuyl/libhilbert"
  url "http://ppmcore.mpi-cbg.de/upload/libhilbert-master.tar.gz"
  sha256 "546d5dec403d7ed1e71706ee39e10d69496a6753eb7f116afe1089d85dc9c35a"
  version "1.0.0"
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