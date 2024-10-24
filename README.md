# Gidro-OS

![](assets/bg.webp)

My customized image, based on slightly customized [Silverblue-main](https://universal-blue.discourse.group/docs?topic=868) base image, which is derived from the amazing [Universal Blue](https://universal-blue.org/) project.  
Thanks to Fedora for developing the original [Fedora Silverblue](https://fedoraproject.org/atomic-desktops/silverblue/) Linux distribution.

This image is created using the easy & robust [BlueBuild](https://blue-build.org/) tooling for creating & maintaining container-based Linux desktop images.  
It is similar to making custom ROMs in the Android community, but in a much easier & more reliable way.

[**Why did I make the custom image?**](https://github.com/fiftydinar/gidro-os/wiki/1.-OS-Scope-&-Vision)

## Modifications

Removed packages (RPMs):
- [Gnome Software rpm-ostree package](https://packages.fedoraproject.org/pkgs/gnome-software/gnome-software-rpm-ostree/) (it makes Gnome Software better + more reliable to use & it's not needed since Gidro-OS uses included [ublue-os rpm-ostree auto-updater](https://github.com/ublue-os/config/blob/main/rpmspec/ublue-os-update-services.spec))
- [Gnome classic session](https://help.gnome.org/users/gnome-help/stable/gnome-classic.html.en)
- Gnome system extensions (some are from Fedora, some are from Gnome classic session, which are not needed)
- [Gnome Tweaks](https://gitlab.gnome.org/GNOME/gnome-tweaks) (It's lowly maintained & It's not officially supported by Gnome)

Replaced packages (RPMs):
- [Yafti](https://github.com/ublue-os/yafti) instead of [Gnome Initial Setup](https://gitlab.gnome.org/GNOME/gnome-initial-setup) & [Gnome Tour](https://gitlab.gnome.org/GNOME/gnome-tour)  
   (for better, more suitable first-time install experience)

Replaced packages (RPMs) with flatpaks:
- [LibreWolf](https://flathub.org/apps/io.gitlab.librewolf-community) instead of [Firefox](https://www.mozilla.org/en-US/firefox/)  
   (it has better defaults, like Ublock Origin out-of-the-box, doesn't send telemetry & it offers easy customization to fix some LibreWolf quirks)
- [Mission Center](https://flathub.org/apps/io.missioncenter.MissionCenter) instead of [Gnome System Monitor](https://gitlab.gnome.org/GNOME/gnome-system-monitor), [nvtop](https://github.com/Syllo/nvtop) & [htop](https://github.com/htop-dev/htop)  
   (it's a much better looking task manager with more useful functionality)

Installed packages (RPMs):
- [Additional Game ROM Properties for Nautilus](https://github.com/GerbilSoft/rom-properties)
- [Nautilus Python](https://github.com/GNOME/nautilus-python) (for Python Nautilus extensions)
- [Python3-icoextract](https://github.com/jlu5/icoextract) (for .exe icons thumbnailing support)
- [Gnome-randr-rust](https://github.com/maxwellainatchi/gnome-randr-rust) (xrandr equivalent for Gnome Wayland)
- [Langpacks-EN](https://packages.fedoraproject.org/pkgs/langpacks/langpacks-en/) (for avoiding Gnome Software's message about it & for potentially solving flatpak mixed locale issues)
- [Zsync](https://web.archive.org/web/20240215223506/http://zsync.moria.org.uk/index) (Needed dependency for some AppImage auto-updates)
- [Miniaturo](https://github.com/dbrgn/miniaturo) (RAW pictures thumbnailing for Nautilus)
- [BrLaser](https://github.com/Owl-Maintain/brlaser) (Driver which supports additional Brother printers)
- Epson-inkjet-printer-escpr 1 & 2 (Driver which supports some additional Epson printers)
- [HPlip](https://developers.hp.com/hp-linux-imaging-and-printing) (Driver which supports some additional HP printers)
- [Foo2zjs](https://www.openprinting.org/driver/foo2zjs/) (Driver which supports some additional Konica Minolta printers)
- [Uld](https://www.bchemnet.com/suldr/) (Driver which supports some additional Samsung printers)
- [sg3_utils](https://sg.danny.cz/sg/sg3_utils.html) (Package which contains utilities that send SCSI commands to devices - used by Apple SuperDrive)
- [bootc](https://github.com/containers/bootc) (Required package for the bootloader update when using ISO)
- [rar](https://www.win-rar.com/rar-linux-mac.html?&L=0) (RAR CLI package)

Installed akmods:
- [NCT6687D](https://github.com/Fred78290/nct6687d) (AMD B550 chipset temperature driver)
- [OpenRazer](https://openrazer.github.io/) (for supporting Razer devices)
- [V4L2-loopback](https://github.com/umlaeute/v4l2loopback) (for allowing you to create virtual video devices to apply some cool effects to real video devices)
- [XOne](https://github.com/medusalix/xone) (Xbox One RF driver)
- [XPadNeo](https://github.com/atar-axis/xpadneo) (Xbox One Bluetooth driver)
- [XPad](https://github.com/paroj/xpad) (Xbox/Xbox 360 USB & RF driver + Xbox One USB driver - built-in into upstream kernel)
- [Zenergy](https://github.com/BoukeHaarsma23/zenergy) (AMD Ryzen/Threadripper CPU sensor reading driver)

Installed extensions:
- [Blur my Shell](https://github.com/aunetx/blur-my-shell)
- [Caffeine](https://github.com/eonpatapon/gnome-shell-extension-caffeine)
- [Quick Close in Overview](https://github.com/p91paul/middleclickclose)
- [OpenWeather Refined](https://github.com/penguin-teal/gnome-openweather)
- [Notifications Alert](https://extensions.gnome.org/extension/258/notifications-alert-on-user-menu/)
- [Bluetooth Battery Meter](https://maniacx.github.io/Bluetooth-Battery-Meter/)
- [Night Theme Switcher](https://gitlab.com/rmnvgr/nightthemeswitcher-gnome-shell-extension)
- [RebootToUEFI](https://github.com/UbayGD/reboottouefi)
- [Gnome 4x UI Improvements](https://github.com/axxapy/gnome-ui-tune)
- [Quick Settings Audio Devices Renamer](https://extensions.gnome.org/extension/6000/quick-settings-audio-devices-renamer/) (disabled by default)
- [Quick Settings Audio Devices Hider](https://extensions.gnome.org/extension/5964/quick-settings-audio-devices-hider/) (disabled by default)
- [Remove World Clocks](https://extensions.gnome.org/extension/6973/remove-world-clocks/) (disabled by default)
- [Sleep Through Notifications](https://gitlab.gnome.org/rhendric/sleep-through-notifications) (disabled by default, useful for setups where screen wake on new notifications is annoying, while retaining notifications functionality)
- [Unblank lock screen](https://github.com/sunwxg/gnome-shell-extension-unblank) (disabled by default, useful if you don't want the behavior of locking the screen to also turn off your screen)

Installed flatpaks:
- [Boxes](https://apps.gnome.org/en/Boxes/)
- [Calculator](https://apps.gnome.org/en/Calculator/)
- [Calendar](https://apps.gnome.org/en/Calendar/)
- [Camera](https://apps.gnome.org/en/Snapshot/)
- [Contacts](https://apps.gnome.org/en/Contacts/)
- [Clocks](https://apps.gnome.org/en/Clocks/)
- [Decoder](https://flathub.org/apps/com.belmoussaoui.Decoder)
- [Papers](https://apps.gnome.org/en/Papers/)
- [Maps](https://apps.gnome.org/en/Maps/)
- [Text Editor](https://apps.gnome.org/en/TextEditor/)
- [Gapless Music Player](https://flathub.org/apps/com.github.neithern.g4music)
- [Clapper Video Player](https://flathub.org/apps/com.github.rafostar.Clapper)
- [Image Viewer](https://apps.gnome.org/en/Loupe/)
- [Fotema](https://flathub.org/apps/app.fotema.Fotema)
- [Secrets](https://apps.gnome.org/en/Secrets/)
- [Authenticator](https://flathub.org/apps/com.belmoussaoui.Authenticator)
- [Sticky Notes](https://flathub.org/apps/com.vixalien.sticky)
- [Folio](https://flathub.org/apps/com.toolstack.Folio)
- [Rnote](https://flathub.org/apps/com.github.flxzt.rnote)
- [LocalSend](https://flathub.org/apps/org.localsend.localsend_app)
- [GPU Screen Recorder](https://flathub.org/apps/com.dec05eba.gpu_screen_recorder)
- [Flatseal](https://flathub.org/apps/com.github.tchx84.Flatseal)
- [Warehouse](https://flathub.org/apps/io.github.flattool.Warehouse)
- [Extension Manager](https://flathub.org/apps/com.mattjakeman.ExtensionManager)
- [Easy Effects](https://flathub.org/apps/com.github.wwmm.easyeffects)

Optional just config:
- [Hide close button from windows](https://github.com/fiftydinar/gidro-os/wiki/6.-Gidro%E2%80%90OS-Config#how-to-apply-hide-close-button-from-windows-config) (useful for mouses which have a special key for closing applications window)
- [Scheduled nightly reboot](https://github.com/fiftydinar/gidro-os/wiki/6.-Gidro%E2%80%90OS-Config#how-to-apply-scheduled-nightly-reboot-config) (useful for applying system updates if you're leaving your PC turned on 24/7)
- [Management of official Android platform-tools](https://github.com/fiftydinar/gidro-os/wiki/6.-Gidro%E2%80%90OS-Config#how-to-manage-android-platform-tools) (useful for easy installing, updating & removing of Android platform-tools pulled from official Google source. `android-tools` official package is broken, so relying on this solution is better + it pairs nicely with existing Android udev rules)
- [Disable Bluetooth headset profile (HSP/HFP)](https://github.com/fiftydinar/gidro-os/wiki/6.-Gidro%E2%80%90OS-Config#how-to-disable-bluetooth-headset-profile) (useful if you don't use mic from Bluetooth headphones, so you don't get surprisingly switched to lower audio quality headset profile)

Settings applied by default:
- [Enabled experimental support for Variable Refresh Rate on supported screens](https://global.samsungdisplay.com/31137) (improves video & gaming experience by dynamically matching screen refresh rate with the content framerate)
- [Enabled Vulkan support for AMD GCN 1.0 & GCN 2.0 GPUs](https://thespecter.net/blog/technology/enabling-amdgpu-on-fedora-31-for-using-vulkan-with-r7-and-r9-radeon-cards/) (for better performance & compatibility with those GPUs)
- [Kyber I/O scheduler for SSDs/NVMEs, BFQ I/O scheduler for HDDs/microSDs/eMMCs](https://github.com/pop-os/default-settings/pull/149) (for improved responsiveness under I/O load)
- [ZSTD I/O scheduler for ZRAM & better ZRAM values suited for desktop](https://github.com/pop-os/default-settings/pull/163) (avoids OOM situations better & it also improves responsiveness under I/O load. Also thanks to [MaxPerfWiz](https://gitlab.com/cscs/maxperfwiz) & [@ahydronous](https://gist.github.com/ahydronous/7ceaa00df96ef99131600edd4c2c73f2) for some good research & values.)
- [Set memlock limit from 64kb to 2GB](https://github.com/RPCS3/rpcs3/issues/9328#issuecomment-732712084) (maps maximum locked value of 2GB per operation, needed for RPCS3 emulator)
- [Increased vm.max_map_count value to match SteamOS](https://www.reddit.com/r/linux_gaming/comments/10x1e6u/fix_hogwarts_legacy_loading_screen_crash/) (to allow some memory-hungry applications such as games to use more memory maps, which allows them to run & not crash)
- [Disabled kernel split-lock mitigate](https://github.com/doitsujin/dxvk/issues/2938) (for restoring performance of affected games)
- [Reduced dirty pages for USB devices](https://gitlab.manjaro.org/fhdk/udev-usb-sync) (for showing real transfer speed of USB devices, rather than speed of writing to cache. Thanks to the user Megavolt from Manjaro forums for the [useful benchmark](https://forum.manjaro.org/t/strict-limit-of-write-cache-0s-sync-time-policy-for-usb-devices-by-default/166934))
- [Enabled Nvidia GSP firmware for Nouveau GPU driver](https://nouveau.freedesktop.org/PowerManagement.html) (to enable power-management for Nvidia GTX 1650+ GPUs)
- [Increased inotify limits](https://www.suse.com/support/kb/doc/?id=000020048) (for preventing errors like "too many open files" when installing/using some huge applications & games)
- [Increased file nolimits](https://github.com/lutris/docs/blob/master/HowToEsync.md) (for preventing non-working Esync)
- [BBR TCP congestion algorithm & FQ network packet scheduling](https://docs.google.com/spreadsheets/d/1I1NcVVbuC7aq4nGalYxMNz9pgS9OLKcFHssIBlj9xXI/edit#gid=1142336892) (for better network performance, especially in low-signal situations)
- Applied workaround for automatic assignment of `adbusers` group to all users (so Android platform-tools is ready to be used without tinkering)
- Appended `plugdev` group to users, to make some udev rules like Yubikey working
- [Partially fixed caps-lock delay](https://forum.manjaro.org/t/caps-lock-behaviour-wayland/79868) (which is present in all other Linux distributions)
- Enabled num-lock by default
- Set font hinting to "None"
- Set Nokia Pure Text font as default
- Set a beautiful Symbian^3 picture as a wallpaper, including dark variant
- [Set light & dark theme to AdwGtk3 for GTK3 applications](https://github.com/lassekongo83/adw-gtk3) (to make Adwaita design more consistent)
- [Use MoreWaita icon pack](https://github.com/somepaulo/MoreWaita) (to extend Adwaita theme icon language)
- Set Serbian Latin language as the locale (display language remains English)
- Set top bar to show weekday too in all languages
- Show battery percentage in top bar
- Power button powers off PC instead of suspending it
- Enabled "Remove Old Trash files automatically" in Nautilus (every 30 days by default in Gnome)
- Set mouse acceleration to flat
- Disabled mouse middle-click to paste & touchpad 3-click to paste for GTK applications
- Set Blur my Shell blur radius value to 8, as default value is too strong & looks cheap when using default background
- Set OpenWeather Refined to:
  - show conditions in top bar
  - show sunrise/sunset in top bar
  - use "mbar" as pressure unit
  - use arrows for wind direction
  - use packaged icons
  - use custom OpenWeatherMap API key (solves "too many users" issue)
- Set Notifications Alert to use less distracting, but still noticeable color for the alert instead of default bright red. This color also fits the top bar blur much better.
- Set Bluetooth Battery Meter to show battery percentage
- Set Night Time Switcher time offset to 0 & set manual time (time based on automatic location is not accurate. Manual location can be specified instead)
- Set Gnome 4x UI Improvements to only enable wallpaper thumbnails in workspace switcher
- Enabled Nautilus "Sort folders before files"
- Set keyboard delay to be much lower, as Gnome defaults are too slow
- ["Window not responding" dialog extended to 20s](https://github.com/ValveSoftware/csgo-osx-linux/issues/669) (to prevent constant dialog showup in some games)
- Add Nautilus "New Document" to context menu
- Set Gnome Software to use Flathub-user remote by default (makes separation between OS flatpaks & user flatpaks much better)
- Disable Gnome Software flatpak auto-updater (not needed since Gidro-OS uses included [ublue-os flatpak auto-updater](https://github.com/ublue-os/config/blob/main/rpmspec/ublue-os-update-services.spec))
- Disable Gnome Software "Software Repositories" option (Warehouse implements the same functionality)
- [Lock some settings to prevent users messing with the system reliability, while still remaining customizable](https://github.com/fiftydinar/gidro-os/wiki/2.-Unsupported-Operations#why-are-some-setting-toggles-grayed-out-i-cant-change-them)
- Hide ROM Properties desktop shortcut
- Enable silent auto-start on boot for those applications:
  - Steam
  - Discord
  - ArmCord
  - Telegram
  - Deluge
  - TutaMail
- Set Text Editor to:
  - use Nokia Pure text font
  - disable Restore Session
  - use higher contrast theme
  - highlight line numbers
- Set Folio to use Nokia Pure text font
- Set Calculator to separate thousands
- Set Clapper (Videos) to use Nokia Pure font for subtitles
- Set LibreWolf to:
  - enable WebGL
  - disable ResistFingerprinting
  - disable deleting cookies & cache on exit
  - enable auto-scroll
  - disable middle-click paste
  - disable Ctrl+Q on quit
  - enable rounded window bottom edge
  - download to Downloads folder without asking
  - enable favorite websites in homepage
  - set 2 rows for favorite websites
  - disable tab manager arrow
  - enable switching tabs with mouse-wheel
  - autohide "Downloads" button
  - disable offline translation
- Set Gapless to enable background playback
- Use cool BlueBuild boot & login-screen logo instead of Fedora

## Installation (ISO) [Recommended]

Please read the [Wiki](https://github.com/fiftydinar/gidro-os/wiki) before proceeding with the installation.

ISO doesn't require an active internet connection during its usage.

### [DOWNLOAD LINK](https://archive.org/download/gidro-os_02-10-2024/home/runner/work/gidro-os/gidro-os/upload/gidro-os_02-10-2024.iso)
### [TORRENT LINK](https://archive.org/download/gidro-os_02-10-2024/gidro-os_02-10-2024_archive.torrent)<br/>(higher download speed)
### [ISO CHECKSUM](https://archive.org/download/gidro-os_02-10-2024/home/runner/work/gidro-os/gidro-os/upload/gidro-os_02-10-2024.iso-CHECKSUM)<br/>(verify the checksum if ISO is downloaded correctly with apps like [Collision](https://flathub.org/apps/dev.geopjr.Collision))

Just download the ISO & proceed with installation.

If you are on UEFI system, you will notice blue MOK screen after installer, which is used for enrolling security keys.
You will need to "Enroll key" with a password `universalblue`.
This needs to be done even if you're not using Secure Boot.

Otherwise, continue boot.

## Installation (Rebase)

Please read the [Wiki](https://github.com/fiftydinar/gidro-os/wiki) before proceeding with the installation.

Rebasing is only supported from Fedora Silverblue edition.

You will need to enroll security key before rebase with the command below, even if you're not using Secure Boot (requires internet).
It will prompt you for sudo user password, so type that, then type the password for secure key, which is `universalblue`:

```
wget -q https://github.com/ublue-os/akmods/raw/main/certs/public_key.der -O /tmp/akmods-ublue.der && sudo mokutil --timeout -1 && sudo mokutil --import /tmp/akmods-ublue.der && rm /tmp/akmods-ublue.der
```

To rebase an existing Silverblue installation to the latest build:

- Reset any package overrides that you might have:
  ```
  rpm-ostree override reset --all
  ```
- Remove all packages that you layered:
  ```
  rpm-ostree uninstall --all
  ```
- Reset any initramfs modifications that you might have:
  ```
  rpm-ostree initramfs --disable
  ```
  ```
  rpm-ostree initramfs-etc --untrack-all
  ```
- Rebase to the unsigned image, to get the proper signing keys and policies installed:
  ```
  rpm-ostree rebase ostree-unverified-registry:ghcr.io/fiftydinar/gidro-os:latest
  ```
- Reboot to complete the rebase:
  ```
  systemctl reboot
  ```

- You will be prompted with blue MOK screen, which is used for enrolling security keys.
  Choose "Enroll key" & type `universalblue` as a password. Continue boot afterwards.

- Then rebase to the signed image, like so:
  ```
  rpm-ostree rebase ostree-image-signed:docker://ghcr.io/fiftydinar/gidro-os:latest
  ```
- Reboot again to complete the installation
  ```
  systemctl reboot
  ```

## COPR repos used for some installed RPM packages
- [ROM Properties](https://copr.fedorainfracloud.org/coprs/kylegospo/rom-properties/)
- [Gnome-randr-rust](https://copr.fedorainfracloud.org/coprs/fiftydinar/gnome-randr-rust/)
- [Zsync](https://copr.fedorainfracloud.org/coprs/elxreno/zsync/)
- [Miniaturo](https://copr.fedorainfracloud.org/coprs/decathorpe/miniaturo/)

## Note for myself regarding what I do after install

- I use `amd_pstate=active` kernel argument to force pstate for my supported CPU (Ryzen 5 5600X, waiting for upstream to enable it by default)
