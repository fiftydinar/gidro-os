# `initramfs-setup` module for startingpoint

This `initramfs-setup` module is intended for including files into initramfs, which are useful for modifying hardware behavior.
It is similar to `rpm-ostree kargs` for this purpose, but `initramfs-setup` can load some modifications which are not possible to load with `rpm-ostree kargs`.

Currently, it supports including file locations from `/etc` directory only by internally using `rpm-ostree initramfs-etc` component.

Script which is responsible for this is located here:

- `/usr/bin/initramfs-setup`

It is run on every boot by this service:

- `/usr/lib/systemd/system/initramfs-setup.service`

Your modifications are written to this file here:

- `/etc/ublue-os/initramfs/tracked`

`initramfs-setup` detects your modifications & file locations which are redundant, so your modification output is exactly matched in `rpm-ostree initramfs-etc` output. It also checks if `rebuild` is enabled & rebuilds initramfs. When initramfs change is happening, you will see boot screen message which will say `Updating initramfs - System will reboot` or `Updating initramfs - Manual rebuild process is running`, depending if `initramfs-setup` updates your modifications or rebuilds initramfs.

To include your modifications, copy the modification files if you have those, than edit the "Example configuration" accordingly in `include`.
Remember to delete the modification files if you have those too, when you want those modifications gone.

To include `dracut` files, just copy those files to `/etc/dracut.conf.d/` directory. There is no need to put them in `include`. Do it otherwise if you want them deleted.

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

Files contain explanations on what they do & how they should be used.

If live-user wants to include dracut files too, he can do that by copying them to `/etc/dracut.conf.d/`
& by modifying this file to be set to `true`:

`/etc/ublue-os/initramfs/rebuild`

One-liner command which handles that if OS does not have just script included for this:

`sudo grep -v -E '^#|^$' "/etc/ublue-os/initramfs/tracked-custom" | sed -i '/^[^#]/ s/false/true/g' "/etc/ublue-os/initramfs/tracked-custom"`
