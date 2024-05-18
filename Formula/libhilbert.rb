class Libhilbert < Formula
  desc "Library producing Hilbert indices for multidimensional data"
  homepage "https://github.com/pdebuyl/libhilbert"
  url "https://github.com/abhinavsns/libhilbert",
      using:    :git,
      branch:   "master",
      revision: "64efb35aa5d194ca3fec4c9d79e552838476e543"
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
