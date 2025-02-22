class Keploy < Formula
  desc "Testing Toolkit creates test-cases and data mocks from API calls, DB queries"
  homepage "https://keploy.io"
  url "https://github.com/keploy/keploy/archive/refs/tags/v2.4.4.tar.gz"
  sha256 "e2e7a8c7b0cf70a495eacb6b9000150138fca20737447fc9b1d6918bdb828b6d"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "4bc535fdbdb5684eabca1a486b3e4a8cf4bd7de1fe6b96495b4c40b6f8b3d27d"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "4bc535fdbdb5684eabca1a486b3e4a8cf4bd7de1fe6b96495b4c40b6f8b3d27d"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "4bc535fdbdb5684eabca1a486b3e4a8cf4bd7de1fe6b96495b4c40b6f8b3d27d"
    sha256 cellar: :any_skip_relocation, sonoma:        "ce6f48f8cc3386054bbca79d32c24cd8bea840ac7616a81ed0951d1368afdeb0"
    sha256 cellar: :any_skip_relocation, ventura:       "ce6f48f8cc3386054bbca79d32c24cd8bea840ac7616a81ed0951d1368afdeb0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "0cb0ae4115a1b6775d39d5b378d06b780d3749925fa5e9743a8c3eec10e2c888"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w -X main.version=#{version}")
  end

  test do
    system bin/"keploy", "config", "--generate", "--path", testpath
    assert_match "# Generated by Keploy", (testpath/"keploy.yml").read

    output = shell_output("#{bin}/keploy templatize --path #{testpath}")
    assert_match "No test sets found to templatize", output

    assert_match version.to_s, shell_output("#{bin}/keploy --version")
  end
end
