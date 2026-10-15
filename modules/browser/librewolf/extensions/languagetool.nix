{firefoxAddons, ...}: {
  programs.librewolf.profiles.default.extensions.packages = [firefoxAddons.languagetool];

  librewolf.extensionStorage."languagetool-webextension@languagetool.org" = {
    apiServerUrl = "https://languagetool.demenik.dev/v2";
    allowRemoteCheck = true;

    preferredLanguages = ["en" "de"];
    enVariant = "en-US";
    deVariant = "de-DE";
    ptVariant = "pt-BR";
    caVariant = "ca-ES";

    hasPickyModeEnabledGlobally = false;
    hasSynonymsEnabled = false;
    hasRephrasingEnabled = true;
    hasContextMenuOptionEnabled = true;
    hasLollipopEnabled = false;
    isDarkModeEnabled = true;
  };
}
