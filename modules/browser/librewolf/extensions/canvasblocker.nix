{firefoxAddons, ...}: {
  programs.librewolf.profiles.default.extensions.packages = [firefoxAddons.canvasblocker];

  librewolf.extensionStorage."CanvasBlocker@kkapsner.de" = {
    blockMode = "fake";
    blockDataURLs = false;
    protectedCanvasPart = "input";
    rng = "persistent";
    storePersistentRnd = true;
    ignoreFrequentColors = 3;
    minColors = 3;
    minFakeSize = 10;
    maxFakeSize = 1000000;
    fakeMinimalScreenSize = false;
    allowWindowNameInFrames = true;
    showNotifications = false;
  };
}
