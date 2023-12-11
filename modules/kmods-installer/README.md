# `kmods-installer` Module for Startingpoint

The `kmods-installer` module is a powerful tool for managing and installing kernel modules. It simplifies the installation of kernel modules, improving the capabilities of your system.

To use `kmods-installer` module, specify the kernel modules you wish to install in the `install:` section of your configuration file.

## Example configuration
```yaml
type: kmods-installer
install:
    - openrazer
    - v4l2loopback
```

## Note

It should only be used for Fedora version 39 and above. Previous versions of Fedora on uBlueOS builds have already had kernel modifications installed.
