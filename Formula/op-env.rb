class OpEnv < Formula
  desc "Shell script to manage environment variables using 1Password"
  homepage "https://github.com/serraict/op-env"
  url "https://github.com/serraict/op-env.git",
      using: :git,
      branch: "main"
  version "0.1.0"
  license "MIT"

  depends_on "bash"

  def install
    if !system("op --version >/dev/null 2>&1")
      odie "1Password CLI (op) is required but not installed. Please install it with: brew install --cask 1password-cli"
    end
    bin.install "bin/op-env"
  end

  test do
    assert_match "Usage: source op-env COMMAND [ARGS]", shell_output("#{bin}/op-env")
  end
end
