cask "pingviewscan" do
  version "1.5.3"
  sha256 "6aef2f61cf00931dc2f743b261b5487b432d87a85dfe7a9ebb3b7d14a96b3917"

  url "https://github.com/bejuwt/pingviewscan/releases/download/v#{version}/PingViewScan-macOS.zip"
  name "PingViewScan"
  desc "Multi-host ping monitor and graphical network scanner"
  homepage "https://github.com/bejuwt/pingviewscan"

  app "PingViewScan.app"

  # The app is ad-hoc signed and not notarized. Homebrew always applies the
  # quarantine flag (the old `--no-quarantine` option was removed), so clear it
  # here to avoid the "cannot verify ... is free of malware" Gatekeeper block.
  postflight do
    system_command "/usr/bin/xattr",
                   args: ["-dr", "com.apple.quarantine", "#{appdir}/PingViewScan.app"]
  end

  caveats <<~EOS
    PingViewScan is ad-hoc signed and not notarized, so macOS Gatekeeper blocks
    it on first launch. This cask clears the quarantine flag for you, so it
    should open normally. If it is ever re-quarantined, run:

      xattr -dr com.apple.quarantine "/Applications/PingViewScan.app"
  EOS
end
