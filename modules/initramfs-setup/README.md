# `initramfs-setup` module for startingpoint

This `initramfs-setup` module is intended for including files into initramfs, which are useful for modifying hardware behavior.
It is similar to `rpm-ostree kargs` for this purpose, but `initramfs-setup` can load some modifications which are not possible to load with `rpm-ostree kargs`.

Currently, it supports including file locations from `/etc` directory only by internally using `rpm-ostree initramfs-etc` component.

Script which is responsible for this is located here:

- `/usr/bin/initramfs-setup`

It is run on every boot by this service:

- `/usr/lib/systemd/system/initramfs-setup.service`

Your modifications to initramfs are written to this file here:

- `/etc/ublue-os/initramfs/tracked`

`tracked` file won't get written if you did not include any initramfs modifications. This makes separation between OS & live-user modifications clearer.

`initramfs-setup` detects your modifications & redundant file arguments, so your modification output is exactly matched to `rpm-ostree initramfs-etc` output. When initramfs change is happening, you will see boot screen message which will say `Updating initramfs - System will reboot`.

To include your initramfs modifications, copy the modification files if you have those, than edit the "Example configuration" accordingly in `include`.
Do the otherwise for deleting.

## Example configuration

```yaml
type: initramfs-setup
include:
    - /etc/crypttab
    - /etc/vconsole.conf
    - /etc/modprobe.d/my_config.conf
```

Live-user modification is available too.

If live-user is not satisfied with initramfs modifications done by the OS, he can add them into this file here:

`/etc/ublue-os/initramfs/tracked-custom`

File contains explanation on what it does & how it should be used.
