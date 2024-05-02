class Blitz < Formula
  desc "Blitz"
  homepage "https://github.com/blitzpp/blitz"
  url "http://ppmcore.mpi-cbg.de/upload/blitz-1.0.2.tar.gz"
  version "1.0.2"

  bottle do
      root_url "https://github.com/abhinavsns/homebrew-openfpm/releases/tag/v5.0"
      rebuild 2
      sha256 cellar: :any, arm64_sonoma: "1b924d2f26e22fc9732491fd415ce9b99443f4d517453152fa0a5e5fbbf34a19"
      sha256 cellar: :any, ventura: "ed7d4486734f302f9a75412938a6b3ae6336e02618372b2a6400bdf44600b416"
      sha256 cellar: :any_skip_relocation, x86_64_linux: "5c237620f2d7a76fc83ec3a8296bf03f08943ab96a95a4972d5d1406abc9447a"
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