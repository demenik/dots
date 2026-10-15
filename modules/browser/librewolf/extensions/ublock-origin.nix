{firefoxAddons, ...}: {
  programs.librewolf = {
    profiles.default.extensions.packages = [firefoxAddons.ublock-origin];

    policies."3rdparty".Extensions."uBlock0@raymondhill.net".toOverwrite.filterLists = [
      "user-filters"
      "ublock-filters"
      "ublock-badware"
      "ublock-privacy"
      "ublock-unbreak"
      "ublock-quick-fixes"
    ];
  };
}
