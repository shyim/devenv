{ pkgs, lib, config, ... }:

let
  types = lib.types;
  scriptType = types.submodule ({ config, ... }: {
    options = {
      exec = lib.mkOption {
        type = types.str;
        description = "Bash code to execute when the script is ran.";
      };
    };
  });
  toPackage = name: script: pkgs.writeShellScriptBin name ''
    #!${pkgs.bash}/bin/bash

    ${script.exec}
  '';
in
{
  options = {
    scripts = lib.mkOption {
      type = types.attrsOf scriptType;
      default = { };
      description = "A set of scripts available when the environment is active.";
    };
  };

  config = {
    packages = lib.mapAttrsToList toPackage config.scripts;
  };
}
