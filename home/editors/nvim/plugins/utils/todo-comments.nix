{
  programs.nixvim = {
    plugins.todo-comments = {
      enable = true;
      settings.keywords = let
        word = icon: color: {inherit icon color;};
        hint = icon: word icon "hint";
        info = icon: word icon "info";
        test = icon: word icon "test";
      in {
        NOTE = hint "";
        TODO = hint "";
        REFACTOR = hint "";

        INFO = info "";
        DOCS = info "";
        LINK = info "";
        GITHUB = info "";

        TEST = test "󰙨";
      };
    };
  };
}
