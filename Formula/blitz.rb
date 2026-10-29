class Blitz < Formula
  desc "Array utility"
  homepage "https://github.com/blitzpp/blitz"
  url "https://github.com/blitzpp/blitz/archive/refs/tags/1.0.2.tar.gz"
  sha256 "500db9c3b2617e1f03d0e548977aec10d36811ba1c43bb5ef250c0e3853ae1c2"

  bottle do
    root_url "https://github.com/abhinavsns/homebrew-openfpm/releases/download/blitz-1.0.2"
    rebuild 2
    sha256 cellar: :any, arm64_sequoia: "3795f3580027e8f669aaf327e94946c6484ef24fc41aa640411524f3e0283dbe"
    sha256 cellar: :any, arm64_linux:   "6d5d769752b58e146791c6b8acb1d165e20f22bcacaa4ec70eba67fd03be3255"
    sha256 cellar: :any, x86_64_linux:  "48032cb9b4b60a48b0fc449536d5958e4b5055568d395b4310aa31e7426a7da0"
  end

  depends_on "cmake" => :build
  depends_on "python" => :build

  def install
    # The project declares an old CMake policy version, which CMake 4 only accepts with a minimum
    system "cmake", "-S", ".", "-B", "build", "-DBUILD_TESTING=OFF", "-DCMAKE_POLICY_VERSION_MINIMUM=3.5",
                    *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    (testpath/"test.cpp").write <<~CPP
      #include <blitz/array.h>
      int main() {
        blitz::Array<double, 2> a(3, 3);
        a = 2.0;
        return blitz::sum(a) == 18.0 ? 0 : 1;
      }
    CPP
    system ENV.cxx, "-std=c++11", "test.cpp", "-I#{include}", "-L#{lib}", "-lblitz", "-o", "test"
    system "./test"
  end
end
