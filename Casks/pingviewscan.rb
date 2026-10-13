cask "pingviewscan" do
  version "1.0.1"
  sha256 "80af2a2c4ab86bc0eb6b884f867d1f04c15c1e2bf3248aaa6524b4ea0dbb1d32"

  url "https://github.com/bejuwt/pingviewscan/releases/download/v#{version}/PingViewScan-macOS.zip"
  name "PingViewScan"
  desc "Multi-host ping monitor and graphical network scanner"
  homepage "https://github.com/bejuwt/pingviewscan"

  app "PingViewScan.app"

  caveats <<~EOS
    PingViewScan is ad-hoc signed and not notarized, so macOS Gatekeeper
    blocks it on first launch. Install without quarantine to skip the prompt:

      brew install --cask --no-quarantine bejuwt/tap/pingviewscan

    Or, after a normal install, clear the flag once:

      xattr -dr com.apple.quarantine "/Applications/PingViewScan.app"
  EOS
end
