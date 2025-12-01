pkgs: let
  build = {
    version,
    owner,
    name,
    rev,
    hash,
  }:
    pkgs.vimUtils.buildVimPlugin {
      pname = name;
      inherit version;
      src = pkgs.fetchFromGitHub {
        repo = name;
        inherit owner rev;
        sha256 = hash;
      };
    };
in {
  # INFO: Last update: 18. Aug. 2025 | Sort latest -> oldest

  # https://github.com/SCJangra/table-nvim
  table-nvim = build {
    version = "27-09-2024";
    owner = "SCJangra";
    name = "table-nvim";
    rev = "c044fd37169eb10376962b0d0cec5f94d58ca626";
    hash = "1ygn4bvnpbd49gcgbkh0cdj3p75jsmwi87hby78w0fd22205pvmi";
  };

  # https://github.com/michaelrommel/nvim-silicon
  silicon = build {
    version = "09-01-2025";
    owner = "michaelrommel";
    name = "nvim-silicon";
    rev = "7f66bda8f60c97a5bf4b37e5b8acb0e829ae3c32";
    hash = "1zk6lgghvdcys20cqvh2g1kjf661q1w97niq5nx1zz4yppy2f9jy";
  };

  # https://github.com/b0o/incline.nvim
  incline = build {
    version = "05-06-2025";
    owner = "b0o";
    name = "incline.nvim";
    rev = "0fd2d5a27504dba7fdc507a53275f22c081fe640";
    hash = "19x35z2sj3hl3icrxzbs67xhxgq9d237vhgzqrz8ppdc74p8wgaz";
  };

  # https://github.com/Aasim-A/scrollEOF.nvim
  scrollEOF = build {
    version = "31-05-2025";
    owner = "Aasim-A";
    name = "scrollEOF.nvim";
    rev = "2575109749b4bf3a0bf979a17947b3c1e8c5137e";
    hash = "1s66v9n0arg81wgw1z8iv9s304j78cd506z522avpc88d3ji4yl4";
  };
}
