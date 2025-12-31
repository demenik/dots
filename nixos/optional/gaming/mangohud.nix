{user, ...}: {
  home-manager.users.${user} = {
    programs.mangohud = {
      enable = true;
      settings = {
        no_display = true;
        toggle_hud = "Shift_R+F12";

        position = "top-left";
        text_outline = true;
        round_corners = 8.0;
        table_columns = 4;

        fps = true;
        framtime = true;

        cpu_stats = true;
        cpu_temp = true;
        cpu_mhz = true;

        gpu_stats = true;
        gpu_temp = true;
        gpu_core_clock = true;
        gpu_mem_clock = true;

        ram = true;
        vram = true;
      };
    };
  };
}
