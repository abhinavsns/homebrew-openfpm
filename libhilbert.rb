class Libhilbert < Formula
  desc "Library producing Hilbert indices for multidimensional data"
  homepage "https://github.com/pdebuyl/libhilbert"
  url "http://ppmcore.mpi-cbg.de/upload/libhilbert-master.tar.gz"
  version "1.0.0" # Replace with the actual version
  revision 1

  bottle do
      root_url "https://github.com/abhinavsns/homebrew-openfpm/releases/tag/v5.0"
      rebuild 2
      sha256 cellar: :any_skip_relocation, arm64_sonoma: "2c0453e12df7e01558b110047ef2ddc23423ebd0889e30fcd8410fb1efceb77e"
      sha256 cellar: :any_skip_relocation, ventura: "358e724798a320bd99cc06631f44f24ef1e6c2135ce6b8d8f19e0d2281a84240"
      sha256 cellar: :any_skip_relocation, x86_64_linux: "0986e1edb3efdbd78c6cb7cb215926d25696a7b4be1f5279436c3a3ef8c95893"
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