# Simple Citrix Workspace overlay using local modified files
# This uses the local citrix-workspace files (which have webkitgtk_4_0 uncommented)
# and provides a compatibility wrapper for webkitgtk_4_1
#
# Why we need local files:
# - Nixpkgs citrix_workspace has webkitgtk_4_0 commented out in generic.nix
# - We cannot override commented-out function parameters
# - The local files have webkitgtk_4_0 uncommented, allowing us to pass it
final: prev:

let
  # Create a webkitgtk compatibility wrapper with backward-compatible symlinks
  # Citrix binaries expect libwebkit2gtk-4.0.so.37 and libjavascriptcoregtk-4.0.so.18
  # but webkitgtk_4_1 provides -4.1.so.0 versions
  webkitgtk_compat = prev.symlinkJoin {
    name = "webkitgtk-4.0-compat";
    paths = [ prev.webkitgtk_4_1 ];
    postBuild = ''
      ln -sf $out/lib/libwebkit2gtk-4.1.so.0 $out/lib/libwebkit2gtk-4.0.so.37
      ln -sf $out/lib/libjavascriptcoregtk-4.1.so.0 $out/lib/libjavascriptcoregtk-4.0.so.18
    '';
  };

  # Import version information from local sources
  sourcesData = prev.callPackage ./citrix-workspace/sources.nix { };

  # Build the latest stable version (25.05.0) with webkitgtk compatibility
  citrix_latest = prev.callPackage ./citrix-workspace/generic.nix (
    sourcesData.supportedVersions."25.05.0" // {
      webkitgtk_4_0 = webkitgtk_compat;
    }
  );

in
{
  # Provide citrix_workspace package
  citrix_workspace = citrix_latest;

  # Also provide version-specific name if needed
  citrix_workspace_25_05_0 = citrix_latest;
}
