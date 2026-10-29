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
    rebuild 2
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "d5b717cf3e0b3b1d63f7de077201797cd9e8d4559f08d84812ff15ddccd6f3af"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "b9cd53156d282f4ee63bd12d8fc6e464aa2f2960b2c26f0b09946037d77fedf8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "5a538f877f68ef9b668cf46ef64289721c96d8dba90b39104b5a05903cab7ae7"
  end

  depends_on "cmake" => :build

  def install
    # The project declares CMake 2.6, which CMake 4 only accepts with a policy minimum
    system "cmake", "-S", ".", "-B", "build", "-DBUILD_TESTING=OFF", "-DCMAKE_POLICY_VERSION_MINIMUM=3.5",
                    *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    (testpath/"test.c").write <<~C
      #include <stdint.h>
      #include <hilbertKey.h>
      int main(void) {
        /* The four cells of a 2x2 grid get the keys 0 to 3 */
        int seen[4] = {0, 0, 0, 0};
        for (uint64_t x = 0; x < 2; x++) {
          for (uint64_t y = 0; y < 2; y++) {
            uint64_t point[2] = {x, y};
            int err = 0;
            uint64_t key = getHKeyFromIntCoord(1, 2, point, &err);
            if (err != 0 || key > 3) return 1;
            seen[key] = 1;
          }
        }
        return seen[0] && seen[1] && seen[2] && seen[3] ? 0 : 1;
      }
    C
    system ENV.cc, "test.c", "-I#{include}", "-L#{lib}", "-llibhilbert", "-lm", "-o", "test"
    system "./test"
  end
end
