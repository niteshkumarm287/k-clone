class KClone < Formula
  desc "A script to clone Kubernetes cronjobs or jobs"
  homepage "https://github.com/niteshkumarm287/k-clone"
  url "https://raw.githubusercontent.com/niteshkumarm287/k-clone/main/k-clone.zsh"
  sha256 "e73437e3467a86204be2b44a72d3a2f90e05c6fb0af76e4c3e5c656f36319cbf"
  license "MIT"
  def install
    bin.install "k-clone.zsh" => "k-clone"
  end
  test do
    system "#{bin}/k-clone", "--help"
  end                                                                                               ▄
end