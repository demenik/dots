{
  programs.noctalia-shell.settings = {
    audio = {
      preferredPlayer = "spotify";
      mprisBlacklist = [];

      visualizerType = "linear";
      spectrumFrameRate = 30;
      spectrumMirrored = false;

      volumeOverdrive = true;
      volumeStep = 5;
      volumeFeedback = false;
    };

    brightness = {
      enableDdcSupport = true;
      enforceMinimum = true;
      brightnessStep = 5;
      backlightDeviceMappings = [];
    };
    nightLight = {
      enabled = false;
      forced = false;
      autoSchedule = true;

      dayTemp = "6500";
      nightTemp = "4000";
    };

    network = {
      networkPanelView = "wifi";
      airplaneModeEnabled = false;

      wifiDetailsViewMode = "grid";

      bluetoothAutoConnect = true;
      bluetoothDetailsViewMode = "grid";
      disableDiscoverability = false;
      bluetoothHideUnnamedDevices = true;
      bluetoothRssiPollingEnabled = false;
      bluetoothRssiPollIntervalMs = 60000;
    };
  };
}
