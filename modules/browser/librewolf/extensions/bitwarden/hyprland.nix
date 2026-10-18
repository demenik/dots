{
  lib,
  config,
  ...
}: {
  wayland.windowManager.hyprland.extraConfig =
    lib.mkIf config.wayland.windowManager.hyprland.enable
    # lua
    ''
      local bitwarden = {
        width = 500,
        height = 700,
        focused = nil,
        parents = {},
        hidden = {},
      }

      local function bitwarden_show(w)
        if bitwarden.hidden[w.address] then
          bitwarden.hidden[w.address] = nil
          hl.dispatch(hl.dsp.window.set_prop({ prop = "opacity", value = "1.0", window = w }))
        end
      end

      local function bitwarden_place(w, parent)
        if parent and parent.mapped and parent.workspace and w.workspace and parent.workspace.id ~= w.workspace.id then
          hl.dispatch(hl.dsp.window.move({ workspace = parent.workspace, window = w }))
        end

        hl.dispatch(hl.dsp.window.set_prop({ prop = "no_anim", value = "1", window = w }))
        hl.dispatch(hl.dsp.window.float({ action = "enable", window = w }))
        hl.dispatch(hl.dsp.window.resize({ x = bitwarden.width, y = bitwarden.height, window = w }))

        if parent and parent.mapped then
          hl.dispatch(hl.dsp.window.move({
            x = parent.at.x + math.floor((parent.size.x - bitwarden.width) / 2),
            y = parent.at.y + math.floor((parent.size.y - bitwarden.height) / 2),
            window = w,
          }))
        else
          hl.dispatch(hl.dsp.window.center({ window = w }))
        end

        hl.dispatch(hl.dsp.focus({ window = w }))
      end

      hl.on("window.active", function(w)
        bitwarden.focused = w
      end)

      hl.on("window.open_early", function(w)
        if w.class ~= "librewolf" then
          return
        end
        -- Fallback for windows that skipped the pre-map title event
        if not bitwarden.parents[w.address] and bitwarden.focused and bitwarden.focused.address ~= w.address then
          bitwarden.parents[w.address] = bitwarden.focused
        end

        bitwarden.hidden[w.address] = true
        hl.dispatch(hl.dsp.window.set_prop({ prop = "opacity", value = "0.0", window = w }))
        hl.timer(function()
          if w.mapped then
            bitwarden_show(w)
          end
        end, { timeout = 500, type = "oneshot" })
      end)

      hl.on("window.title", function(w)
        if not w.mapped then
          if not bitwarden.parents[w.address] then
            bitwarden.parents[w.address] = bitwarden.focused
          end
          return
        end

        if w.class ~= "librewolf" or not bitwarden.hidden[w.address] then
          return
        end
        if w.title:find("^Extension: %(Bitwarden") then
          bitwarden_place(w, bitwarden.parents[w.address])
        end
        bitwarden.parents[w.address] = nil
        bitwarden_show(w)
      end)

      hl.on("window.close", function(w)
        bitwarden.parents[w.address] = nil
        bitwarden.hidden[w.address] = nil
      end)
    '';
}
