# `initramfs-setup` module for startingpoint

This `initramfs-setup` module is intended for including files into initramfs, including dracut ones, which are useful for modifying hardware behavior.
It is similar to `rpm-ostree kargs` for this purpose, but `initramfs-setup` can load some modifications which are not possible to load with `rpm-ostree kargs`.

Currently, it supports including file locations from `/etc` directory only by internally using `rpm-ostree initramfs-etc` component.

Script which is responsible for this is located here:

- `/usr/bin/initramfs-setup`

It is run on every boot by this service:

- `/usr/lib/systemd/system/initramfs-setup.service`

Your modifications to initramfs are written to this file here:

- `/etc/ublue-os/initramfs/tracked`

Your modifications to dracut are written to this file here:

- `/etc/ublue-os/initramfs/dracut-tracked`

`tracked` & `dracut-tracked` files won't get written if you did not include modifications for those. This makes separation between OS & live-user modifications clearer.

`initramfs-setup` detects your modifications & redundant file locations, so your modification output is exactly matched to `rpm-ostree initramfs-etc` output. It also checks dracut configs the same way to trigger rebuild automatically only when necessary. When initramfs/dracut change is happening, you will see boot screen message which will say `Updating initramfs - System will reboot` or `Updating initramfs with dracut changes - System will reboot`, depending if `initramfs-setup` updates your initramfs or dracut modifications (or if it updates them both).

To include your initramfs modifications, copy the modification files if you have those, than edit the "Example configuration" accordingly in `include`.
Do the otherwise for deleting.

To include `dracut` files, just copy those files to `/etc/dracut.conf.d/` directory. Than put them in `dracut_include`. Do the otherwise for deleting.

## Example configuration

```yaml
type: initramfs-setup
include:
    - /etc/crypttab
    - /etc/vconsole.conf
    - /etc/modprobe.d/my_config.conf
dracut_include:
    - mydracut1.conf
    - mydracut2.conf
    - mydracut3.conf
```

Live-user modification is available too.

If live-user is not satisfied with initramfs modifications done by the OS, he can add them into this file here:

`/etc/ublue-os/initramfs/tracked-custom`

Files contain explanations on what those do & how those should be used.

If live-user wants to include dracut files too, he can do that by copying files to `/etc/dracut.conf.d/` & editing

`/etc/ublue-os/initramfs/dracut-tracked-custom`
