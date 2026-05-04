class KClone < Formula
  desc "A script to clone Kubernetes cronjobs or jobs"
  homepage "https://github.com/niteshkumarm287/k-clone"
  url "https://github.com/niteshkumarm287/k-clone/archive/refs/tags/v1.0.0.tar.gz"
  sha256 "PLACEHOLDER_SHA256"
  license "MIT"
  version "1.0.0"

  depends_on "kubectl"
  depends_on "jq"

  def install
    bin.install "k-clone.zsh" => "k-clone"
  end

  test do
    system "#{bin}/k-clone", "--help"
  end
end