# /etc/nixos/overlays/dj/consoleTools/iso2god-rs.nix

self: super: {
  iso2god-rs = super.rustPlatform.buildRustPackage {
    pname = "iso2god-rs";
    version = "unstable-latest";

    src = super.fetchFromGitHub {
      owner = "iliazeus";
      repo = "iso2god-rs";
      rev = "master"; # tracks latest master branch
      sha256 = "sha256-Rp3ob6Ff41FiYYaDcxDYzo8/0q3Q65FWfAw7tTCWEKc="; # let Nix tell you the correct hash on first build
    };

    cargoHash = "sha256-1q2ruR2FFtIjBBR4E9Z/icbeVaec2QzWWXbHouJ2+do="; # Nix will fill this after first build attempt

    nativeBuildInputs = with super; [ pkg-config ];
    buildInputs = with super; [ openssl ];

    meta = with super.lib; {
      description = "A tool to convert Xbox 360 ISOs to GOD format";
      homepage = "https://github.com/iliazeus/iso2god-rs";
      license = licenses.mit;
      maintainers = [ ];
      platforms = platforms.all;
    };
  };
}
