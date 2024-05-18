class Blitz < Formula
  desc "Array utility"
  homepage "https://github.com/blitzpp/blitz"
  url "https://github.com/blitzpp/blitz/archive/refs/tags/1.0.2.tar.gz"
  sha256 "500db9c3b2617e1f03d0e548977aec10d36811ba1c43bb5ef250c0e3853ae1c2"

  bottle do
    root_url "https://github.com/abhinavsns/homebrew-openfpm/releases/download/blitz-1.0.2"
    rebuild 1
    sha256 cellar: :any,                 arm64_sonoma: "55b3c741637bf136a89d69953827840859f0b94b434b197848f3d9a0297b672f"
    sha256 cellar: :any,                 ventura:      "5390f60dad56d3f62a8e782aa53503099530a28063e51b672b005529a189f82e"
    sha256 cellar: :any_skip_relocation, x86_64_linux: "627434946ae60161a693a17e66066fb7dd36aec20318484157134a791bf120bf"
  end

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
