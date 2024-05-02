class Algoim < Formula
  desc "Algoim"
  homepage "https://github.com/algoim/algoim"
  url "http://ppmcore.mpi-cbg.de/upload/algoim.tar.gz"
  version "1.0.0"
  sha256 "408e6dda7cae51c593c7cb264448de38d1b9fa1e2fc09e5dbac342970659a111"

  bottle do
      root_url "https://github.com/abhinavsns/homebrew-openfpm/releases/tag/v5.0"
      rebuild 2
      sha256 cellar: :any_skip_relocation, arm64_sonoma: "6ef3ce08fd6f874a86ccf922c1b894baacffce56ec95a6bda835b05396dce86c"
      sha256 cellar: :any_skip_relocation, ventura: "5b6c31c74caccee8d817ccd67af9d21ecda272493489de8d54c1e598326ab773"
      sha256 cellar: :any_skip_relocation, x86_64_linux: "7285e6c4200a6737352dcb95152d3998d78f3abd6c4b6f37cc8014ff0f45f8c4"
  end


  depends_on "cmake" => :build

  def install
    (include/"algoim").mkpath
    Dir["include/*"].each { |path| (include/"algoim").install path }
  end
end