class Blitz < Formula
  desc "Array utility"
  homepage "https://github.com/blitzpp/blitz"
  url "https://github.com/blitzpp/blitz/archive/refs/tags/1.0.2.tar.gz"
  sha256 "500db9c3b2617e1f03d0e548977aec10d36811ba1c43bb5ef250c0e3853ae1c2"

  depends_on "cmake" => :build
  depends_on "python"

  def install
    build_dir = "build"
    mkdir build_dir do
      system "cmake", "..", *std_cmake_args, "-DBUILD_TESTING=OFF"
      system "make", "install"
    end
  end
end
