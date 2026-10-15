{firefoxAddons, ...}: {
  programs.librewolf.profiles.default.extensions.packages = [
    (firefoxAddons.buildFirefoxXpiAddon {
      pname = "cookie-auto-decline";
      version = "7.7";
      addonId = "jobcentertycoon@gmail.com";
      url = "https://addons.mozilla.org/firefox/downloads/file/5035686/cookie_auto_decline-7.7.xpi";
      sha256 = "105ah9pawk0k851vr40r76bsiprfnj53whdq1g02vmm2mh9i4i6n";
      meta = {};
    })
  ];

  librewolf.extensionStorage."jobcentertycoon@gmail.com" = {
    cookieeinstellung.einstellung = "funktional";
    erweitertecookiebannererkennung.enabled = true;
  };
}
