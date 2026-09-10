cask "local-servers" do
  version "1.0.0"
  sha256 "ae87985cffde5869d6b2e8faf21d0483b1c1b939923c5f81c8356ceb7cf80b55"

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

  postflight do
    # Gatekeeper blocks an unsigned app that arrived with a quarantine
    # attribute, which is every cask download: macOS reports "Apple could
    # not verify … is free of malware" and offers only Move to Bin.
    #
    # Removing the attribute is the standard remedy for an unsigned
    # open-source app, and it is a real trade-off: it skips the
    # notarisation check for this bundle. The honest fix is a Developer ID
    # signature and notarisation, which needs an Apple developer account.
    if system_command("/usr/bin/xattr", args: ["-h"]).exit_status == 0
      system_command "/usr/bin/xattr",
                     args: ["-dr", "com.apple.quarantine", "#{staged_path}/Local Servers.app"]
    end
  end

  uninstall quit: "com.marcomondini.localservers"

  zap trash: "~/Library/Preferences/com.marcomondini.localservers.plist"

  caveats <<~EOS
    Local Servers runs in the menu bar only — there is no dock icon.
    Launch it from Spotlight or /Applications, then look for the server icon
    at the top right.
  EOS
end
