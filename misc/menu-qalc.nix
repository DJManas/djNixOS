# menu-qalc-wayland: A calculator for Wofi/fuzzel/dmenu(2) using libqalculate
#
# This is a Wayland-compatible fork of menu-qalc that works with:
# - Wofi (preferred if available)
# - Fuzzel
# - dmenu/dmenu2
#
# Usage:
#   Add to environment.systemPackages or home.packages:
#     pkgs.menu-qalc
#
#   Run directly:
#     menu-qalc
#
#   Or use the shorthand:
#     = "4+4"
#     = "(4+2)/(4+3)"
#     = "sqrt(16)"
#     = "1000 EUR to USD"
#
# The package includes man pages: man menu-qalc
#
final: prev: {
  menu-qalc = prev.stdenv.mkDerivation rec {
    pname = "menu-qalc";
    version = "unstable-2025-04-18";

    src = prev.fetchFromGitHub {
      owner = "ClemaX";
      repo = "menu-qalc-wayland";
      rev = "fc9629e5f1fe77db92e9af02ea68878390792598";
      hash = "sha256-20QmEmzH0cEpbZVWleANge0oncCXhWR8MpqG9Xty+FI=";
    };

    buildInputs = with prev; [
      bash
      libqalculate
      wl-clipboard
    ];

    nativeBuildInputs = [ prev.makeWrapper ];

    dontBuild = true;

    installPhase = ''
      runHook preInstall

      # Install the main script
      install -Dm755 "=" "$out/bin/menu-qalc"

      # Install man pages
      install -Dm644 menu-qalc.1 "$out/share/man/man1/menu-qalc.1"
      install -Dm644 "=.1" "$out/share/man/man1/=.1"

      # Wrap the script to ensure dependencies are in PATH
      wrapProgram "$out/bin/menu-qalc" \
        --prefix PATH : ${prev.lib.makeBinPath [
          prev.libqalculate
          prev.wl-clipboard
          prev.wofi
          prev.gawk
        ]}

      runHook postInstall
    '';

    meta = with prev.lib; {
      description = "A calculator for Wofi/fuzzel/dmenu(2) using libqalculate";
      homepage = "https://github.com/ClemaX/menu-qalc-wayland";
      license = licenses.mit;
      maintainers = [ ];
      platforms = platforms.linux;
      mainProgram = "menu-qalc";
    };
  };
}
