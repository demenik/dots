{
  name = "vesktop";

  modules = [../wm];
  moduleConfig = {
    wm.windowrules = [
      {
        matchClass = "vesktop";
        matchTitle = "vesktop";
        noInitialFocus = true;
      }
      {
        matchClass = "vesktop";
        workspace = "3";
        noInitialFocus = true;
      }
      {
        matchClass = "vesktop";
        matchTitle = "Discord Popout";

        floating = true;
        size = [640 360];
        keepAspectRatio = true;
        pinned = true;
        position = ["100%-w-5" "100%-h-5"];
      }
    ];
  };

  home = {
    pkgs,
    lib,
    config,
    ...
  }: let
    inherit (config) colors;

    catppuccinNoctalia = pkgs.stdenv.mkDerivation {
      name = "catppuccin-noctalia-template";
      src = pkgs.fetchurl {
        url = "https://catppuccin.github.io/discord/dist/catppuccin-mocha.theme.css";
        sha256 = "1ql5id1xr2r45ahdpayhnfdsvj9nbr6whf3wkw1n1yc8zayzsnr9";
      };
      nativeBuildInputs = [pkgs.python3];
      dontUnpack = true;
      buildPhase = ''
        cat >replace_colors.py <<'EOF'
        import re
        import sys

        mapping = {
            "11111b": "surface_container_lowest",
            "181825": "surface_container_low",
            "1e1e2e": "surface",
            "313244": "surface_container",
            "45475a": "surface_container_high",
            "585b70": "surface_container_highest",
            "cdd6f4": "on_surface",
            "bac2de": "on_surface_variant",
            "a6adc8": "outline",
            "9399b2": "outline_variant",
            "7f849c": "surface_variant",
            "6c7086": "surface_dim",
            "cba6f7": "primary",
            "89b4fa": "secondary",
            "f5c2e7": "tertiary",
            "f38ba8": "error",
            "fab387": "tertiary_container",
            "f9e2af": "secondary_container",
            "a6e3a1": "primary_container",
            "94e2d5": "primary_fixed",
            "89dceb": "secondary_fixed",
            "74c7ec": "tertiary_fixed",
            "b4befe": "primary_fixed_variant",
            "f2cdcd": "error_container",
            "eba0ac": "error_container",
            "f5e0dc": "error_container",
        }

        def hex_to_rgb(h): return tuple(int(h[i:i+2], 16) for i in (0, 2, 4))
        def color_dist(c1, c2): return sum((a - b) ** 2 for a, b in zip(c1, c2))

        def get_closest_tag(hex_str):
            if hex_str in mapping: return mapping[hex_str]
            c1 = hex_to_rgb(hex_str)
            best_dist, best_tag = float('inf'), None
            for k, v in mapping.items():
                c2 = hex_to_rgb(k)
                d = color_dist(c1, c2)
                if d < best_dist:
                    best_dist, best_tag = d, v
            return best_tag

        with open(sys.argv[1], 'r') as f: content = f.read()

        def hex_replacer(match):
            hex_val = match.group(1).lower()
            if len(hex_val) == 3: hex_val = "".join(c+c for c in hex_val)
            tag = get_closest_tag(hex_val)
            return f"{{{{colors.{tag}.default.hex}}}}"

        content = re.sub(r'#([0-9a-fA-F]{3,6})\b', hex_replacer, content)

        def rgba_replacer(match):
            r, g, b, a = match.groups()
            hex_val = f"{int(r):02x}{int(g):02x}{int(b):02x}"
            tag = get_closest_tag(hex_val)
            return f"{{{{colors.{tag}.default.hex | set_alpha {a}}}}}"

        content = re.sub(r'rgba\s*\(\s*(\d+)\s*,\s*(\d+)\s*,\s*(\d+)\s*,\s*([0-9.]+)\s*\)', rgba_replacer, content)

        with open('patched.css', 'w') as f:
            f.write("/**\n * @name Catppuccin Noctalia\n * @description Dynamically patched theme\n * @author demenik\n */\n\n")
            f.write(content)
        EOF
        python3 replace_colors.py "$src"
      '';
      installPhase = ''
        cp patched.css "$out"
      '';
    };
  in {
    theme.templates.discord.enable = true;
    theme.templates.vesktop-catppuccin = {
      enable = true;
      target = "~/.config/vesktop/themes/noctalia-catppuccin.css";
      source = catppuccinNoctalia;
    };

    programs.vesktop = {
      enable = true;

      settings = {
        discordBranch = "stable";
        tray = false;
        minimizeToTray = false;
        arRPC = true;
        splashColor = colors.withHashtag.accent;
        splashBackground = colors.withHashtag.base00;
      };

      vencord.settings = {
        autoUpdate = true;
        autpUpdateNotification = true;
        useQuickCss = true;
        eagerPatches = false;
        enableReactDevtools = true;
        frameless = false;
        transparent = true;
        winCtrlQ = false;
        disableMinSize = true;
        winNativeTitleBar = false;

        themeLinks = lib.mkIf (config.theme.type == "colorScheme") [
          "https://catppuccin.github.io/discord/dist/catppuccin-mocha-mauve.theme.css"
        ];
        enabledThemes = lib.mkIf (config.theme.type == "template") [
          "noctalia-catppuccin.css"
        ];

        notifications = {
          timeout = 5000;
          position = "bottom-right";
          useNative = "not-focused";
          logLimit = 50;
        };

        cloud = {
          authenticated = false;
          url = "https://api.vencord.dev/";
          settingsSync = false;
          settingsSyncVersion = 0;
        };

        plugins = {
          ChatInputButtonAPI.enabled = true;
          CommandsAPI.enabled = true;
          DynamicImageModalAPI.enabled = true;
          MemberListDecoratorsAPI.enabled = true;
          MessageAccessoriesAPI.enabled = true;
          MessageDecorationsAPI.enabled = true;
          MessageEventsAPI.enabled = true;
          MessagePopoverAPI.enabled = true;
          UserSettingsAPI.enabled = true;
          AlwaysTrust = {
            enabled = true;
            domain = true;
            file = true;
          };
          AnonymiseFileNames = {
            enabled = false;
            anonymiseByDefault = true;
            method = 2;
            randomisedLength = 7;
            consistent = "image";
          };
          BetterFolders = {
            enabled = true;
            sidebarAnim = false;
            sidebar = true;
            closeAllFolders = false;
            closeAllHomeButton = false;
            closeOthers = false;
            forceOpen = false;
            keepIcons = false;
            showFolderIcon = 1;
          };
          BetterGifAltText.enabled = true;
          BetterGifPicker.enabled = true;
          BetterSettings = {
            enabled = true;
            disableFade = true;
            organizeMenu = true;
            eagerLoad = true;
          };
          BetterUploadButton.enabled = true;
          BiggerStreamPreview.enabled = true;
          BlurNSFW = {
            enabled = true;
            blurAmount = 10;
          };
          CallTimer = {
            enabled = true;
            format = "stopwatch";
          };
          ClearURLs.enabled = true;
          ConsoleJanitor = {
            enabled = true;
            disableLoggers = false;
            disableSpotifyLogger = true;
            whitelistedLoggers = "GatewaySocket; Routing/Utils";
          };
          CopyEmojiMarkdown.enabled = true;
          CopyFileContents.enabled = true;
          CopyUserURLs.enabled = true;
          CrashHandler.enabled = true;
          Decor.enabled = true;
          DisableCallIdle.enabled = true;
          DontRoundMyTimestamps.enabled = true;
          FakeNitro = {
            enabled = true;
            enableEmojiBypass = true;
            emojiSize = 48;
            transformEmojis = true;
            enableStickerBypass = true;
            stickerSize = 160;
            transformStickers = true;
            transformCompoundSentence = false;
            enableStreamQualityBypass = true;
            useHyperLinks = true;
            hyperLinkText = "{{NAME}}";
            disableEmbedPermissionCheck = false;
          };
          FakeProfileThemes = {
            enabled = true;
            nitroFirst = true;
          };
          FavoriteEmojiFirst.enabled = true;
          FavoriteGifSearch.enabled = true;
          FixCodeblockGap.enabled = true;
          FixImagesQuality.enabled = true;
          FixSpotifyEmbeds = {
            enabled = true;
            volume = 10;
          };
          ForceOwnerCrown.enabled = true;
          FriendInvites.enabled = true;
          FriendsSince.enabled = true;
          FullSearchContext.enabled = true;
          GameActivityToggle = {
            enabled = true;
            oldIcon = false;
          };
          GifPaste.enabled = true;
          GreetStickerPicker = {
            enabled = true;
            greetMode = "Greet";
          };
          iLoveSpam.enabled = true;
          IgnoreActivities = {
            enabled = false;
            listMode = 0;
            idsList = "";
            ignorePlaying = false;
            ignoreStreaming = false;
            ignoreListening = false;
            ignoreWatching = false;
            ignoreCompeting = false;
          };
          ImplicitRelationships = {
            enabled = true;
            sortByAffinity = true;
          };
          MemberCount = {
            enabled = true;
            toolTip = true;
            memberList = true;
          };
          MessageClickActions = {
            enabled = true;
            enableDeleteOnClick = true;
            enableDoubleClickToEdit = true;
            enableDoubleClickToReply = true;
            requireModifier = false;
          };
          MessageLogger.enabled = true;
          MoreCommands.enabled = true;
          MoreKaomoji.enabled = true;
          MutualGroupDMs.enabled = true;
          NewGuildSettings = {
            enabled = true;
            guild = true;
            messages = 3;
            everyone = true;
            role = true;
            highlights = true;
            events = true;
            showAllChannels = true;
          };
          NoDevtoolsWarning.enabled = true;
          NoMaskedUrlPaste.enabled = true;
          NoMosaic = {
            enabled = false;
            inlineVideo = true;
          };
          NoOnboardingDelay.enabled = true;
          NoPendingCount = {
            enabled = true;
            friendRequest = false;
            messageRequest = false;
          };
          NoUnblockToJump.enabled = true;
          NSFWGateBypass.enabled = true;
          OnePingPerDM = {
            enabled = true;
            channelToAffect = "both_dms";
            allowMentions = false;
            allowEveryone = false;
          };
          OpenInApp = {
            enabled = true;
            spotify = true;
            steam = true;
            epic = true;
            tidal = true;
            itunes = true;
          };
          PauseInvitesForever.enabled = true;
          PermissionFreeWill = {
            enabled = true;
            lockout = true;
            onboarding = true;
          };
          PermissionsViewer.enabled = true;
          petpet.enabled = true;
          PictureInPicture.enabled = true;
          PinDMs.enabled = true;
          PlatformIndicators = {
            enabled = true;
            colorMobileIndicator = true;
            list = true;
            badges = true;
            messages = true;
          };
          ReactErrorDecoder.enabled = true;
          ReadAllNotificationsButton.enabled = true;
          RelationshipNotifier = {
            enabled = true;
            offlineRemovals = true;
            groups = true;
            servers = true;
            friends = true;
            friendRequestCancels = true;
          };
          ReverseImageSearch.enabled = true;
          ReviewDB = {
            enabled = true;
            notifyReviews = true;
            showWarning = true;
            hideTimestamps = false;
            hideBlockedUsers = true;
          };
          ServerInfo.enabled = true;
          ShikiCodeblocks = {
            enabled = true;
            theme = "https://cdn.jsdelivr.net/gh/shikijs/textmate-grammars-themes@bc5436518111d87ea58eb56d97b3f9bec30e6b83/packages/tm-themes/themes/catppuccin-mocha.json";
            tryHljs = "SECONDARY";
            useDevIcon = "COLOR";
            bgOpacity = 100;
            customTheme = "";
          };
          ShowConnections.enabled = true;
          ShowHiddenChannels = {
            enabled = true;
            hideUnreads = true;
            showMode = 0;
            defaultAllowedUsersAndRolesDropdownState = true;
          };
          ShowTimeoutDuration = {
            enabled = true;
            displayStyle = "ssalggnikool";
          };
          SilentTyping = {
            enabled = true;
            showIcon = false;
            contextMenu = true;
            isEnabled = true;
          };
          SpotifyCrack = {
            enabled = true;
            noSpotifyAutoPause = true;
            keepSpotifyActivityOnIdle = false;
          };
          SpotifyShareCommands.enabled = true;
          TextReplace = {
            enabled = true;
            regexRules = [
              # === GitHub/Gitea ===
              {
                # Issue
                find = ''(https?:\/\/[a-zA-Z0-9.-]+\/(?:[^\/\s]+\/)*([^\/\s]+\/[^\/\s]+)\/issues\/(\d+)([?#][^\s"'<)]*)?)'';
                replace = "[$2#$3$4]($1)";
              }
              {
                # PR
                find = ''(https?:\/\/[a-zA-Z0-9.-]+\/(?:[^\/\s]+\/)*([^\/\s]+\/[^\/\s]+)\/pulls?\/(\d+)([?#][^\s"'<)]*)?)'';
                replace = "[$2!$3$4]($1)";
              }

              # === GitLab ===
              {
                # Issue
                find = ''(https?:\/\/[a-zA-Z0-9.-]+\/(?:[^\/\s]+\/)*(?:group-04\/([^\/\s]+)|([^\/\s]+\/[^\/\s]+))\/-\/(?:work_items|issues)\/(\d+)([?#][^\s"'<)]*)?)'';
                replace = "[$2$3#$4$5]($1)";
              }
              {
                # MR
                find = ''(https?:\/\/[a-zA-Z0-9.-]+\/(?:[^\/\s]+\/)*(?:group-04\/([^\/\s]+)|([^\/\s]+\/[^\/\s]+))\/-\/merge_requests\/(\d+)([?#][^\s"'<)]*)?)'';
                replace = "[$2$3!$4$5]($1)";
              }
            ];
          };
          ThemeAttributes.enabled = true;
          Translate = {
            enabled = true;
            showChatBarButton = true;
            service = "google";
            deeplApiKey = "";
            autoTranslate = false;
            showAutoTranslateTooltip = true;
            receivedInput = "auto";
            receivedOutput = "en";
            sentInput = "auto";
            sentOutput = "zh-CN";
            showAutoTranslateAlert = false;
          };
          TypingIndicator.enabled = true;
          Unindent.enabled = true;
          UnlockedAvatarZoom.enabled = true;
          UnsuppressEmbeds.enabled = true;
          UserMessagesPronouns = {
            enabled = true;
            pronounsFormat = "LOWERCASE";
            showSelf = true;
          };
          UserVoiceShow = {
            enabled = true;
            showInUserProfileModal = true;
            showInMemberList = true;
            showInMessages = true;
          };
          USRBG = {
            enabled = true;
            nitroFirst = true;
            voiceBackground = true;
          };
          ValidReply.enabled = true;
          ValidUser.enabled = true;
          ViewIcons.enabled = true;
          VoiceDownload.enabled = true;
          VoiceMessages = {
            enabled = true;
            noiseSuppression = true;
            echoCancellation = true;
          };
          VolumeBooster = {
            enabled = true;
            multiplier = 2;
          };
          WebKeybinds.enabled = true;
          WebScreenShareFixes.enabled = true;
          YoutubeAdblock.enabled = true;
          NoTrack = {
            enabled = true;
            disableAnalytics = true;
          };
          WebContextMenus = {
            enabled = true;
            addBack = true;
          };
          Settings = {
            enabled = true;
            settingsLocation = "aboveNitro";
          };
          SupportHelper.enabled = true;
          FullUserInChatbox.enabled = true;
          BadgeAPI.enabled = true;
        };
      };
    };
  };
}
