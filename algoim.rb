class Algoim < Formula
  desc "Algoim"
  homepage "https://github.com/algoim/algoim"
  url "http://ppmcore.mpi-cbg.de/upload/algoim.tar.gz"
  version "1.0.0"
  sha256 "408e6dda7cae51c593c7cb264448de38d1b9fa1e2fc09e5dbac342970659a111"

  bottle do
      root_url "https://github.com/abhinavsns/homebrew-openfpm/releases/tag/v5.0"
      rebuild 1
      sha256 arm64_sonoma: "e92238b1d8fd5e23eebe1a025dd4decbe6224933a8e1c760e2574c116ffee6d7"
      sha256 x86_64_linux: "80f177dd547def4016006142e61d5ee8db9b67e336fd5febb1540be0918b63e3"
  end


  depends_on "cmake" => :build

  def install
    (include/"algoim").mkpath
    Dir["include/*"].each { |path| (include/"algoim").install path }
  end
end