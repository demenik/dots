{
  name = "mangohud";

  home = {
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
        frametime = true;
        fps_metrics = ["avg" "0.01" "0.001"];

        cpu_stats = true;
        cpu_temp = true;
        cpu_mhz = true;
        core_load = true;
        core_bars = true;

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
