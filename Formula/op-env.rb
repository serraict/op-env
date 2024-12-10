class OpEnv < Formula
  desc "Shell script to manage environment variables using 1Password"
  homepage "https://github.com/serraict/op-env"
  url "https://github.com/serraict/op-env.git",
      using: :git,
      branch: "main"
  version "0.1.0"
  license "MIT"

  depends_on "bash"
  depends_on "1password-cli"

  def install
    bin.install "bin/op-env"
  end

  test do
    assert_match "Usage: source op-env COMMAND [ARGS]", shell_output("#{bin}/op-env")
  end
end