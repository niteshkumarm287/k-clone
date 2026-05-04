class KClone < Formula
  desc "A script to clone Kubernetes cronjobs or jobs"
  homepage "https://github.com/niteshkumarm287/k-clone"
  url "https://github.com/niteshkumarm287/k-clone/archive/refs/tags/v1.0.0.tar.gz"
  sha256 "ca07a29c8d8aea99048ebe6534c4bb412e2d01b8f402d51a6c9b949ff220e390"
  license "MIT"
  version "1.0.0"

  uses_from_macos "zsh"

  def install
    bin.install "k-clone.zsh" => "k-clone"
  end

  test do
    system "#{bin}/k-clone", "--help"
  end
end