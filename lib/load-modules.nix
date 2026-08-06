{ lib }: let
  inherit (builtins) readDir attrNames;
in
dir:
  let
    # reads the files in the dir
    entries = readDir dir;
  in
    map (name: dir + "/${name}")
      # filters out save files and such
      (lib.filter (name:
        entries.${name} == "regular"
        && lib.hasSuffix ".nix" name
        && !(lib.hasSuffix ".nix~" name)
        && !(lib.hasPrefix "_" name)
        && name != "default.nix"
      ) (attrNames entries))
