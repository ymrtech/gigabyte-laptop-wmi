# SPDX-License-Identifier: GPL-2.0-or-later
#
# NixOS module for the aorus-laptop kernel module.
#
# The module is built against config.boot.kernelPackages, so it follows kernel
# upgrades automatically and never has to be rebuilt by hand.
{
  config,
  lib,
  ...
}:

let
  cfg = config.hardware.gigabyte-laptop;
in
{
  options.hardware.gigabyte-laptop = {
    enable = lib.mkEnableOption "the aorus-laptop kernel module, which exposes fan control, charging thresholds and sensors on Gigabyte AERO/AORUS laptops through sysfs and hwmon";

    package = lib.mkOption {
      type = lib.types.package;
      default = config.boot.kernelPackages.callPackage ./package.nix { };
      defaultText = lib.literalExpression "config.boot.kernelPackages.callPackage ./package.nix { }";
      description = ''
        The aorus-laptop kernel module to install. Defaults to the module built
        from this flake against your running kernel package set.
      '';
    };
  };

  config = lib.mkIf cfg.enable {
    boot.extraModulePackages = [ cfg.package ];
    # aorus_laptop, not aorus-laptop: the module name is the .ko file name.
    boot.kernelModules = [ "aorus_laptop" ];
  };
}
