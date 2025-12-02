# /etc/nixos/overlays/dj/development/zed-platformio.nix

self: super: {
  zed-platformio = super.buildGoModule {
    pname = "zed-platformio";
    version = "latest";
    src = super.fetchFromGitHub {
      owner = "igor-mauricio";
      repo = "zed-platformio";
      rev = "master"; # or use a tag or a pinned commit
      sha256 = "0or//tcp91RNJvXbeTYWMYdSBLWWhqCH+Huu2Zw5HM4="; # <<< let Nix tell you what to put the first time!
    };
    vendorHash = "sha256-hocnLCzWN8srQcO3BMNkd2lt0m54Qe7sqAhUxVZlz1k="; # will be filled after first build too!
    subPackages = [ "." ];

    # Ignore the vendor directory since it's out of sync
    buildFlags = [ "-mod=readonly" ];
  };
}
