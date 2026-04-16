class Agix < Formula
  desc "Agent Graph IndeX — universal package manager for AI CLI tools"
  homepage "https://github.com/fantoine/agix"
  version "0.1.3"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/fantoine/agix/releases/download/v0.1.3/agix-aarch64-apple-darwin.tar.xz"
      sha256 "4b340420525ca90ed25fa4f895db3674edc0d780f6ae81a4548f30a66b79c626"
    end
    if Hardware::CPU.intel?
      url "https://github.com/fantoine/agix/releases/download/v0.1.3/agix-x86_64-apple-darwin.tar.xz"
      sha256 "9f2e16b95a03e6c1d99887d14e84e11522742b34d265658626e249e9765ddc00"
    end
  end
  if OS.linux? && Hardware::CPU.intel?
    url "https://github.com/fantoine/agix/releases/download/v0.1.3/agix-x86_64-unknown-linux-gnu.tar.xz"
    sha256 "7fd3f518a4962e36fefbda148c6daccc88c0086f6b5a5ba1f4bc4fd3e5eafd93"
  end
  license "MIT"

  BINARY_ALIASES = {
    "aarch64-apple-darwin":     {},
    "x86_64-apple-darwin":      {},
    "x86_64-pc-windows-gnu":    {},
    "x86_64-unknown-linux-gnu": {},
  }.freeze

  def target_triple
    cpu = Hardware::CPU.arm? ? "aarch64" : "x86_64"
    os = OS.mac? ? "apple-darwin" : "unknown-linux-gnu"

    "#{cpu}-#{os}"
  end

  def install_binary_aliases!
    BINARY_ALIASES[target_triple.to_sym].each do |source, dests|
      dests.each do |dest|
        bin.install_symlink bin/source.to_s => dest
      end
    end
  end

  def install
    bin.install "agix" if OS.mac? && Hardware::CPU.arm?
    bin.install "agix" if OS.mac? && Hardware::CPU.intel?
    bin.install "agix" if OS.linux? && Hardware::CPU.intel?

    install_binary_aliases!

    # Homebrew will automatically install these, so we don't need to do that
    doc_files = Dir["README.*", "readme.*", "LICENSE", "LICENSE.*", "CHANGELOG.*"]
    leftover_contents = Dir["*"] - doc_files

    # Install any leftover files in pkgshare; these are probably config or
    # sample files.
    pkgshare.install(*leftover_contents) unless leftover_contents.empty?
  end
end
