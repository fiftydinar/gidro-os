# `initramfs-setup`

The `initramfs-setup` module can be used to include file arguments into initramfs, which are useful for modifying hardware behavior.
It is similar to `rpm-ostree kargs` for this purpose, but `initramfs-setup` can load some modifications which are not possible to load with `rpm-ostree kargs`.
It is also a more reliable method of doing those type of changes, as modifications are file-based, compared to being argument-based.

Currently, it supports including file locations from `/etc` directory only by internally using `rpm-ostree initramfs-etc` component.

Script which is responsible for this is located here:

- `/usr/bin/initramfs-setup`

It is run on every boot by this service:

- `/usr/lib/systemd/system/initramfs-setup.service`

Your modifications to initramfs are written to this file here:

- `/usr/share/bluebuild/initramfs-setup/tracked`

`tracked` file won't get written if you did not include any initramfs modifications. This makes separation between OS & live-user modifications clearer.

`initramfs-setup` detects your modifications & redundant file arguments, so your modification output is exactly matched to `rpm-ostree initramfs-etc` output. When initramfs change is happening, you will see boot screen message which will say `Updating initramfs - System will reboot`.

To include your initramfs modifications, copy the modification files if you have those, than edit the "Example configuration" accordingly in `include`.
Do the otherwise for deleting.

# Local modification

If local user is not satisfied with default initramfs modifications in the image, it is possible for them to make modifications to the default configuration through the configuration file located here:

`/etc/bluebuild/initramfs-setup/tracked`

It contains the explanation on what it does & how it should be used.

If local user wants to include dracut configs from `/etc/dracut.conf.d/` to be recognized by initramfs, he needs to follow instructions bellow.

If local user wants to rebuild initramfs on system reboot, he can do that by issuing this command:

`sudo touch /etc/bluebuild/initramfs-setup/rebuild`
