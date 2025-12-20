{config, ...}: let
  inherit (config.lib.stylix) colors;
in {
  wayland.windowManager.hyprland.settings.windowrulev2 =
    [
      "workspace 4, class:^(vesktop)$"
    ]
    ++ map (rule: "${rule}, class:^(vesktop)$, title:^(Discord Popout)$") [
      "float"
      "size 640 360"
      "keepaspectratio"
      "pin"
      "move 100%-w-5 100%-w-5"
    ];

  programs.vesktop = {
    enable = true;

    settings = {
      discordBranch = "stable";
      minimizeToTray = false;
      arRPC = true;
      splashColor = "#${colors.base0E}";
      splashBackground = "#${colors.base00}";
    };

    vencord = {
      settings = {
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

        themeLinks = [
          "https://catppuccin.github.io/discord/dist/catppuccin-mocha-mauve.theme.css"
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
            enabled = true;
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
            theme = "https://raw.githubusercontent.com/shikijs/shiki/0b28ad8ccfbf2615f2d9d38ea8255416b8ac3043/packages/shiki/themes/dark-plus.json";
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
