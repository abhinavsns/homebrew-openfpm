class Algoim < Formula
  desc "Algoim"
  homepage "https://github.com/algoim/algoim"
  url "http://ppmcore.mpi-cbg.de/upload/algoim.tar.gz"
  version "1.0.0"
  sha256 "408e6dda7cae51c593c7cb264448de38d1b9fa1e2fc09e5dbac342970659a111"

  bottle do
      root_url "https://github.com/abhinavsns/homebrew-openfpm/releases/tag/v5.0"
      rebuild 2
      sha256 cellar: :any_skip_relocation, arm64_sonoma: "96f29e1610fe5e3d6c2182dcb62dc6ed76c9488962553409f9307adc07263d18"
      sha256 cellar: :any_skip_relocation, ventura: "5b6c31c74caccee8d817ccd67af9d21ecda272493489de8d54c1e598326ab773"
      sha256 cellar: :any_skip_relocation, x86_64_linux: "beba5011a07dfbc11a468cccdd38e5fbdc7a7260c5c2b8c17384c6186679ea54"
  end


  depends_on "cmake" => :build

  def install
    (include/"algoim").mkpath
    Dir["include/*"].each { |path| (include/"algoim").install path }
  end
end