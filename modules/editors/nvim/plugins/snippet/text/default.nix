{
  mit = {
    template = builtins.readFile ./MIT.txt;
    placeholders = {
      "1" = "<YEAR>";
      "0" = "<COPYRIGHT HOLDER>";
    };
  };
}
