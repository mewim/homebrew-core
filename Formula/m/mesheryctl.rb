class Mesheryctl < Formula
  desc "Command-line utility for Meshery, the cloud native management plane"
  homepage "https://meshery.io"
  url "https://github.com/meshery/meshery.git",
      tag:      "v0.7.87",
      revision: "3b7410fabb9843ccaa547a489b8b4ac5a1204e73"
  license "Apache-2.0"
  head "https://github.com/meshery/meshery.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "f784b40c4d38670e01dbb45125aa745f9e7ec8a108734f6e8fe885a501243ae7"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "f784b40c4d38670e01dbb45125aa745f9e7ec8a108734f6e8fe885a501243ae7"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "f784b40c4d38670e01dbb45125aa745f9e7ec8a108734f6e8fe885a501243ae7"
    sha256 cellar: :any_skip_relocation, sonoma:         "770555768e32df4b7a2068abaf5cdc1733adf87fc8c903b2faca6079ecc56537"
    sha256 cellar: :any_skip_relocation, ventura:        "770555768e32df4b7a2068abaf5cdc1733adf87fc8c903b2faca6079ecc56537"
    sha256 cellar: :any_skip_relocation, monterey:       "770555768e32df4b7a2068abaf5cdc1733adf87fc8c903b2faca6079ecc56537"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "3eea363592f3da740b835e65b41fb400126a41fa81f11ccb55c6058cde0c84e1"
  end

  depends_on "go" => :build

  def install
    ENV["CGO_ENABLED"] = "0"

    ldflags = %W[
      -s -w
      -X github.com/layer5io/meshery/mesheryctl/internal/cli/root/constants.version=v#{version}
      -X github.com/layer5io/meshery/mesheryctl/internal/cli/root/constants.commitsha=#{Utils.git_short_head}
      -X github.com/layer5io/meshery/mesheryctl/internal/cli/root/constants.releasechannel=stable
    ]

    system "go", "build", *std_go_args(ldflags:), "./mesheryctl/cmd/mesheryctl"

    generate_completions_from_executable(bin/"mesheryctl", "completion")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/mesheryctl version 2>&1")
    assert_match "Channel: stable", shell_output("#{bin}/mesheryctl system channel view 2>&1")

    # Test kubernetes error on trying to start meshery
    assert_match "The Kubernetes cluster is not accessible.", shell_output("#{bin}/mesheryctl system start 2>&1", 1)
  end
end
