# consoleTools/default.nix

self: super: {
  # Import all console tool overlays and merge them
  inherit ((import ./iso2god-rs.nix self super)) iso2god-rs;
}
