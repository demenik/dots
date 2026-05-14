{
  pkgs,
  config,
  ...
}: let
  tailscaleIconPatch =
    pkgs.writeText "tailscale-icon.patch"
    # diff
    ''

      diff --git a/tailscale/BarWidget.qml b/tailscale/BarWidget.qml
      index 3a232a98..e8e3f0d0 100644
      --- a/tailscale/BarWidget.qml
      +++ b/tailscale/BarWidget.qml
      @@ -52,8 +52,9 @@ Item {
               applyUiScale: false
               crossed: !(mainInstance?.tailscaleRunning ?? false)
               color: {
      -          if (mainInstance?.tailscaleRunning ?? false) return Color.mOnPrimary
      -          return mouseArea.containsMouse ? Color.mOnHover : Color.mOnSurface
      +          if (mouseArea.containsMouse) return Color.mOnHover
      +          if (mainInstance?.tailscaleRunning ?? false) return Color.mPrimary
      +          return Color.mOnSurface
               }
               opacity: 1.0
             }
      diff --git a/tailscale/TailscaleIcon.qml b/tailscale/TailscaleIcon.qml
      index 379cafdd..af00da41 100644
      --- a/tailscale/TailscaleIcon.qml
      +++ b/tailscale/TailscaleIcon.qml
      @@ -20,9 +20,10 @@ Item {
           id: iconImage
           anchors.fill: parent
           source: Qt.resolvedUrl("icons/tailscale.svg")
      +    sourceSize: Qt.size(width, height)
           fillMode: Image.PreserveAspectFit
           smooth: true
      -    mipmap: true
      +    mipmap: false

           layer.enabled: true
           layer.effect: MultiEffect {
    '';
in {
  programs.noctalia-shell = {
    plugins.states.tailscale = {
      enabled = true;
      sourceUrl = "https://github.com/noctalia-dev/noctalia-plugins";
    };

    pluginSettings.tailscale = {
      compactMode = true;
      showIpAddress = false;
      showPeerCount = false;
      hideDisconnected = false;
      hideMullvadExitNodes = false;
      showSearchBar = false;

      refreshInterval = 5000;
      pingCount = 5;
      defaultPeerAction = "copy-ip";
      terminalCommand = config.terminal.command or "";

      taildropEnabled = true;
      taildropDownloadDir = "~/Downloads";
      taildropReceiveMode = "operator";
    };

    wrapper = {
      packages = with pkgs; [
        patch
      ];

      pluginPatches =
        # bash
        ''
          if [ -d "tailscale" ] && ! grep -q "Color.mPrimary" "tailscale/BarWidget.qml"; then
            patch -p1 --no-backup-if-mismatch <"${tailscaleIconPatch}"
          fi
        '';
    };
  };
}
