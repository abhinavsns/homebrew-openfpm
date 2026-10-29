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
