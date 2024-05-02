class Libhilbert < Formula
  desc "Library producing Hilbert indices for multidimensional data"
  homepage "https://github.com/pdebuyl/libhilbert"
  url "http://ppmcore.mpi-cbg.de/upload/libhilbert-master.tar.gz"
  version "1.0.0" # Replace with the actual version
  revision 1

  bottle do
      root_url "https://github.com/abhinavsns/homebrew-openfpm/releases/tag/v5.0"
      rebuild 2
      sha256 cellar: :any_skip_relocation, arm64_sonoma: "2d651f790b6352b5f4c39d51237cdc9a70bc86daed37a565bd1587b7569aac83"
      sha256 cellar: :any_skip_relocation, ventura: "358e724798a320bd99cc06631f44f24ef1e6c2135ce6b8d8f19e0d2281a84240"
      sha256 cellar: :any_skip_relocation, x86_64_linux: "aa8ff0b8d575c2d507f483924744d75f6015ef74beac4b4abce2957d771f14e9"
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