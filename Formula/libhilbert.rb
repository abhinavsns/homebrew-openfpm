class Libhilbert < Formula
  desc "Library producing Hilbert indices for multidimensional data"
  homepage "https://github.com/pdebuyl/libhilbert"
  url "https://github.com/abhinavsns/libhilbert",
      using:    :git,
      branch:   "master",
      revision: "64efb35aa5d194ca3fec4c9d79e552838476e543"
  version "1.0.0"
  revision 1

  bottle do
    root_url "https://github.com/abhinavsns/homebrew-openfpm/releases/download/libhilbert-1.0.0_1"
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_sonoma: "76d8561bccf0ea35eec6dfaf8c16bf7479a6aee0a2e4ffbebf366c6b61e1c80c"
    sha256 cellar: :any_skip_relocation, ventura:      "b3107626e25e7e5bb82cf31c993588c7b9e200ad227748acfdcf1d875b703882"
    sha256 cellar: :any_skip_relocation, x86_64_linux: "be66f076c292fd48fa98fa496bec75e4561296a153c4248de7d34cbb217994fc"
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
