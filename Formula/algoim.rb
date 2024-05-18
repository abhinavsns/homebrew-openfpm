class Algoim < Formula
  desc "Levelset functionality"
  homepage "https://github.com/algoim/algoim"
  url "http://ppmcore.mpi-cbg.de/upload/algoim.tar.gz"
  version "1.0.0"
  sha256 "408e6dda7cae51c593c7cb264448de38d1b9fa1e2fc09e5dbac342970659a111"

  bottle do
    root_url "https://github.com/abhinavsns/homebrew-openfpm/releases/download/algoim-1.0.0"
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_sonoma: "315056703cc0d16aa46bf1057a3169160d5ca792a37c315491b1d8410266925f"
    sha256 cellar: :any_skip_relocation, ventura:      "3bdf02812c54785587f5a58e6037bf0e277409f6e90e7786cd507939a5ca3405"
    sha256 cellar: :any_skip_relocation, x86_64_linux: "cd4a6eaa1db69a9ffc4c4b923f9ca909d60b2721068216c01cb0bcbd53bfe3ed"
  end

  def install
    include.install Dir["src/*"]
  end
end
