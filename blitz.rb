class Blitz < Formula
  desc "Blitz"
  homepage "https://github.com/blitzpp/blitz"
  url "http://ppmcore.mpi-cbg.de/upload/blitz-1.0.2.tar.gz"
  version "1.0.2"

  bottle do
      root_url "https://github.com/abhinavsns/homebrew-openfpm/releases/tag/v5.0"
      rebuild 1
      sha256 arm64_sonoma: "18baabed322b46398f2dee957a66b19e93e8f7cda2c79c24409eba4a1bebd6c3"
      sha256 x86_64_linux: "f5ac60b4a687a8841ca2b777fbb56af0227a11e8621d9a037733c8aa319c9b04"
  end

  depends_on "cmake" => :build
  depends_on "python"

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