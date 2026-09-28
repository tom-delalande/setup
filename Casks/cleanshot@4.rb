cask "cleanshot@4" do
  version "4.8.11"
  sha256 "298afb3d085ee6343dae954ba2a7429bd613e6ad9e942c8f79008688ceb11a81"

  url "https://updates.getcleanshot.com/v3/CleanShot-X-#{version}.dmg"
  name "CleanShot X 4"
  desc "Screen capturing tool"
  homepage "https://cleanshot.com/"

  depends_on macos: :ventura

  app "CleanShot X.app"

  postflight do
    system_command "/usr/bin/defaults", args: [
      "write", "pl.maketheweb.cleanshotx", "SUAutomaticallyUpdate", "-bool", "false",
    ]
    system_command "/usr/bin/defaults", args: [
      "write", "pl.maketheweb.cleanshotx", "SUEnableAutomaticChecks", "-bool", "false",
    ]
    system_command "/usr/bin/defaults", args: [
      "write", "pl.maketheweb.cleanshotx", "automaticallyCheckForUpdates", "-bool", "false",
    ]
  end

  uninstall quit: "pl.maketheweb.cleanshotx"
  zap trash: [
    "~/Library/Application Support/CleanShot",
    "~/Library/Caches/pl.maketheweb.cleanshotx",
    "~/Library/Caches/SentryCrash/CleanShot X",
    "~/Library/Preferences/com.getcleanshot.app.plist",
    "~/Library/Preferences/pl.maketheweb.cleanshotx.plist",
  ]
end
