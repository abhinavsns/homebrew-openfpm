class Algoim < Formula
  desc "Levelset functionality"
  homepage "https://github.com/algoim/algoim"
  url "https://ppmcore.mpi-cbg.de/upload/algoim.tar.gz"
  version "1.0.0"
  sha256 "408e6dda7cae51c593c7cb264448de38d1b9fa1e2fc09e5dbac342970659a111"

  bottle do
    root_url "https://github.com/abhinavsns/homebrew-openfpm/releases/download/algoim-1.0.0"
    rebuild 2
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "14017342f6d6e00ddf74fd6ea13114b97f706d97d985cc37bb4199100b94a2ef"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "a7698dc569bee90cc7b880b91e44fecc54d4cb37bebb93e92d6d067e0865bf9b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d0e4858c90a96326942f6b15359e2f3b0192379491cad92224ff16352ae4e242"
  end

  def install
    include.install Dir["src/*"]
  end

  test do
    (testpath/"test.cpp").write <<~CPP
      #include <algoim_real.hpp>
      int main() {
        Algoim::Real x = 0.5;
        return x == 0.5 ? 0 : 1;
      }
    CPP
    system ENV.cxx, "test.cpp", "-I#{include}", "-o", "test"
    system "./test"
  end
end
