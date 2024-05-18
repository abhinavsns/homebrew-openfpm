class Algoim < Formula
  desc "Levelset functionality"
  homepage "https://github.com/algoim/algoim"
  url "http://ppmcore.mpi-cbg.de/upload/algoim.tar.gz"
  version "1.0.0"
  sha256 "408e6dda7cae51c593c7cb264448de38d1b9fa1e2fc09e5dbac342970659a111"

  def install
    (include/"algoim").mkpath
    Dir["include/*"].each { |path| (include/"algoim").install path }
  end
end
