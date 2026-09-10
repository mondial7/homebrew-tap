cask "local-servers" do
  version "1.0.1"
  sha256 "1f1a0b92a31eadea9d1fe659daa49888fdeb388538ea1809cc11d8b59dd4064d"

  url "https://github.com/mondial7/local-servers/releases/download/v#{version}/LocalServers_#{version}_universal.zip"
  name "Local Servers"
  desc "Menu bar app listing the servers running on your machine"
  homepage "https://github.com/mondial7/local-servers"

  livecheck do
    url :url
    strategy :github_latest
  end

  depends_on macos: :ventura

  app "Local Servers.app"

  postflight_steps do
    # Gatekeeper blocks an unsigned app that arrived with a quarantine
    # attribute, which is every cask download: macOS reports "Apple could
    # not verify … is free of malware" and offers only Move to Bin.
    #
    # Removing the attribute is the standard remedy for an unsigned
    # open-source app, and it is a real trade-off: it skips the
    # notarisation check for this bundle. The honest fix is a Developer ID
    # signature and notarisation, which needs an Apple developer account —
    # tracked in mondial7/local-servers#1.
    run "/usr/bin/xattr",
        args:         ["-dr", "com.apple.quarantine", "{{appdir}}/Local Servers.app"],
        must_succeed: false
  end

  uninstall quit: "com.marcomondini.localservers"

  zap trash: "~/Library/Preferences/com.marcomondini.localservers.plist"

  caveats <<~EOS
    Local Servers runs in the menu bar only — there is no dock icon.
    Launch it from Spotlight or /Applications, then look for the server icon
    at the top right.
  EOS
end
