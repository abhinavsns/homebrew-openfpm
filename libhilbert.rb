class Libhilbert < Formula
  desc "Library producing Hilbert indices for multidimensional data"
  homepage "https://github.com/pdebuyl/libhilbert"
  url "http://ppmcore.mpi-cbg.de/upload/libhilbert-master.tar.gz"
  version "1.0.0" # Replace with the actual version
  revision 1

  bottle do
      root_url "https://github.com/abhinavsns/homebrew-openfpm/releases/tag/v5.0"
      rebuild 1
      sha256 arm64_sonoma: "06f3f3f95e46bb0e2ee8e28074bfe32d7f6dac87a1a6878ea15d568db4867426"
      sha256 x86_64_linux: "3cdfeb404c36b9f80eb22ee9dc067ea5842cdb168084ab2f11e4f05de0fbfb0c"
  end
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