class Blitz < Formula
  desc "Levelset utility"
  homepage "https://github.com/blitzpp/blitz"
  url "http://ppmcore.mpi-cbg.de/upload/blitz-1.0.2.tar.gz"
  sha256 "500db9c3b2617e1f03d0e548977aec10d36811ba1c43bb5ef250c0e3853ae1c2"
  version "1.0.2"

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