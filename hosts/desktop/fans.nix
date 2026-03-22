{config, ...}: {
  boot = {
    kernelModules = ["it87"];
    extraModulePackages = [config.boot.kernelPackages.it87];

    kernelParams = ["acpi_enforce_resources=lax" "amdgpu.ppfeaturemask=0xffffffff"];
    extraModprobeConfig = ''
      options it87 force_id=0x8628 ignore_resource_conflict=1
    '';
  };
}
