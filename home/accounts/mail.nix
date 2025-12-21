{
  lib,
  pkgs,
  ...
}: {
  home.packages = with pkgs; [
    pass
  ];

  accounts.email.accounts = let
    getPass = address: "${lib.getExe pkgs.pass} show ${address}";
  in {
    "iCloud" = rec {
      primary = true;
      address = "dominik.bernroider@icloud.com";
      userName = address;
      realName = "Dominik Bernroider";

      passwordCommand = getPass address;

      imap = {
        host = "imap.mail.me.com";
        port = 993;
        tls.enable = true;
      };

      smtp = {
        host = "smtp.mail.me.com";
        port = 587;
        tls = {
          enable = true;
          useStartTls = true;
        };
      };

      thunderbird.enable = true;
    };

    "Gmail" = rec {
      address = "domerepu@gmail.com";
      userName = address;
      realName = "Dominik Bernroider";
      flavor = "gmail.com";

      passwordCommand = getPass address;

      imap = {
        host = "imap.gmail.com";
        port = 993;
        tls.enable = true;
      };

      smtp = {
        host = "smtp.gmail.com";
        port = 465;
        tls.enable = true;
      };

      thunderbird.enable = true;
    };

    "Uni-Ulm" = rec {
      address = "dominik.bernroider@uni-ulm.de";
      userName = "tct47";
      realName = "Dominik Bernroider";

      passwordCommand = getPass address;

      imap = {
        host = "imap.uni-ulm.de";
        port = 993;
        tls.enable = true;
      };

      smtp = {
        host = "mail.uni-ulm.de";
        port = 587;
        tls = {
          enable = true;
          useStartTls = true;
        };
      };

      thunderbird.enable = true;
    };

    "Self-hosted" = rec {
      address = "mail@demenik.dev";
      userName = address;
      realName = "Dominik Bernroider";

      passwordCommand = getPass address;

      imap = {
        host = "mail.demenik.dev";
        port = 993;
        tls.enable = true;
      };

      smtp = {
        host = "mail.demenik.dev";
        port = 587;
        tls = {
          enable = true;
          useStartTls = true;
        };
      };

      thunderbird.enable = true;
    };

    "Alte Gmail" = rec {
      address = "domemc.netzwerk@gmail.com";
      flavor = "gmail.com";
      userName = address;
      realName = "Dominik Bernroider";

      passwordCommand = getPass address;

      imap = {
        host = "imap.gmail.com";
        port = 993;
        tls.enable = true;
      };

      smtp = {
        host = "smtp.gmail.com";
        port = 465;
        tls.enable = true;
      };

      thunderbird.enable = true;
    };
  };
}
