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
      index 46e33952..368f761a 100644
      --- a/tailscale/BarWidget.qml
      +++ b/tailscale/BarWidget.qml
      @@ -55,7 +55,6 @@ Item {
               connected: root.tailscaleConnected
               connecting: root.tailscaleConnecting
               hovered: mouseArea.containsMouse
      -        litColor: Color.mPrimary
             }

             // Show details when not in compact mode and there's something to show
      diff --git a/tailscale/TailscaleIcon.qml b/tailscale/TailscaleIcon.qml
      index 2519b244..d5ad022b 100644
      --- a/tailscale/TailscaleIcon.qml
      +++ b/tailscale/TailscaleIcon.qml
      @@ -10,9 +10,13 @@ Item {
         property bool connected: false
         property bool connecting: false
         property bool hovered: false
      -  property color litColor: Color.mPrimary
      -  property color dimColor: Color.mOnSurface
      -  property real dimOpacity: hovered ? 0.78 : 0.38
      +  property color litColor: {
      +    if (hovered) return Color.mOnHover;
      +    if (connected) return Color.mPrimary;
      +    return Color.mOnSurface;
      +  }
      +  property color dimColor: hovered ? Color.mOnHover : Color.mOnSurface
      +  property real dimOpacity: 0.38

         readonly property real iconSize: Math.max(1, applyUiScale ? root.pointSize * Style.uiScaleRatio : root.pointSize)
         readonly property real dotSize: Math.max(3, iconSize * 0.22)
      @@ -43,20 +47,20 @@ Item {
             Rectangle {
               required property int index

      -        readonly property bool connectedLit: root.connected && (index === 3 || index === 4 || index === 5 || index === 7)
      -        readonly property bool connectingLit: root.connecting
      -          && !root.connected
      -          && (index === root.activeConnectingDot
      -            || index === (root.activeConnectingDot + 4) % 9
      -            || index === (root.activeConnectingDot + 7) % 9)
      -        readonly property bool lit: connectedLit || connectingLit
      +        readonly property bool isConnectingLit: root.connecting && !root.connected && (
      +          index === root.activeConnectingDot
      +          || index === (root.activeConnectingDot + 4) % 9
      +          || index === (root.activeConnectingDot + 7) % 9
      +        )
      +        readonly property bool isStaticLit: !root.connecting && (index === 3 || index === 4 || index === 5 || index === 7)
      +        readonly property bool lit: isConnectingLit || isStaticLit

               Layout.preferredWidth: root.dotSize
               Layout.preferredHeight: root.dotSize
               radius: width / 2
               color: lit ? root.litColor : root.dimColor
               opacity: lit ? 1.0 : root.dimOpacity
      -        scale: connectingLit ? 1.18 : 1.0
      +        scale: isConnectingLit ? 1.18 : 1.0
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
          if [ -d "tailscale" ] && [ -f "tailscale/TailscaleIcon.qml" ] && ! grep -q "if (hovered)" "tailscale/TailscaleIcon.qml"; then
            patch -p1 --no-backup-if-mismatch <"${tailscaleIconPatch}"
          fi
        '';
    };
  };
}
