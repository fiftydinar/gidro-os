# Gidro-OS

![](assets/bg.webp)

My customized image, based on Fedora Silverblue, main edition, derived from UniversalBlue project.

Removed packages (RPMs):
- Firefox
- htop
- nvtop
- Gnome Software rpm-ostree package (not needed since we use rpm-ostree auto-updater)
- Gnome classic session
- Gnome Tour
- Gnome Initial Setup
- Gnome System Monitor
- Gnome system extensions
- Gnome Tweaks

Replaced packages (RPMs)/usecases:
- Gnome Web from Flathub instead of Firefox rpm
- Mission Center from Flathub instead of Gnome System Monitor
- System76-Power instead of Power Profiles Daemon (it is more aggressively, but still reliably, adjusting power-saving of various components + Power Profiles Daemon is depreciated)
- Gnome Mutter "dynamic triple-buffering" support (for improved Gnome Shell performance)
- Gnome Mutter "Variable Refresh Rate" support (only available as a separate image, as it conflicts with dynamic triple-buffering)

Installed packages (RPMs):
- System76 Scheduler (for performance improvement by adequately adjusting process priorities in realtime)
- DDC Control (for setting up screen controls through GUI in OS)
- Team Fortress 2 SELinux rule (for preventing "no certain sounds" issue)
- Additional Game ROM Properties for Nautilus
- Nautilus Python (for Python Nautilus extensions)
- Python3-icoextract (for .exe icons thumbnailing support)
- Gnome-randr-rust (xrandr equivalent for Gnome Wayland)

Installed extensions:
- Blur My Shell
- Caffeine
- Quick Close in Overview
- OpenWeather
- System76 Scheduler (needed for integration with Gnome)

Installed flatpaks:
- Gnome Boxes
- Gnome Calculator
- Gnome Calendar
- Gnome Camera
- Gnome Contacts
- Gnome Clocks
- Gnome Document Viewer
- Gnome Maps
- Gnome Text Editor
- G4Music
- Clapper
- Gnome Image Viewer (Loupe)
- Secrets
- Sticky Notes
- Rnote
- LocalSend
- Flatseal
- Warehouse
- PinApp
- jdSimpleAutostart
- Extension Manager
- Easy Effects
- Bottles

Optional flatpaks:
- Warp
- OBS Studio
- Thunderbird
- Discord
- Telegram
- FreeTube
- Dialect
- Fragments
- ASCII Draw
- InkScape
- Mousai
- NewsFlash
- LibreOffice
- Tagger
- Parabolic
- Nicotine+
- Tenacity
- GitHub Desktop
- Steam
- ProtonPlus (Steam Proton Manager)
- PCSX2
- Space Cadet Pinball
- Grapejuice (Roblox)

Optional config:
- Hide GRUB text output on boot (available in yafti & just)
- Hide close button from windows - useful for mouses which have a special key for closing applications window (available in yafti & just)
- Steam silent auto-start on boot (can be enabled in jdSimpleAutostart)
- Discord silent auto-start on boot (can be enabled in jdSimpleAutostart)

Settings applied by default:
- Enabled Vulkan support for AMD GCN 1.0 & GCN 2.0 GPUs (HD 7000/HD 8000 series)
- Kyber I/O scheduler for SSDs/NVMEs, BFQ I/O scheduler for HDDs/microSDs/eMMCs (for improved responsiveness under I/O load)
- ZSTD I/O scheduler for ZRAM & better ZRAM values suited for desktop (avoids OOM situations better & it also improves responsiveness under I/O load)
- Set memlock limit from 64kb to 2GB (maps maximum locked value of 2GB per operation, needed for RPCS3 emulator)
- Increased vm.max_map_count value to match SteamOS (to allow some memory-hungry applications such as games to use more memory maps, which allows them to run & not crash)
- Disable kernel split-lock mitigate (for restoring performance of affected games)
- Applied fix for non-working trim for LUKS partitions
- Disabled kernel watchdog (logger), for improved performance & battery life
- BBR TCP congestion algorithm & FQ network packet scheduling (for better network performance, especially in low-signal situations)
- Enable touchpad tap-to-click
- Set font hinting to "None"
- Set Nokia Pure Text font as default
- Set a beautiful Symbian^3 picture as a wallpaper
- Set light & dark theme to AdwGtk3 for GTK3 applications
- Use MoreWaita icon pack (to extend Adwaita icon language)
- Set Serbian Latin language as the locale (display language remains English)
- Set top bar to show weekday too in all languages
- Enable "Remove Old Trash files automatically" in Nautilus (every 30 days by default in Gnome)
- Set mouse acceleration to flat 
- Set BlurMyShell sigma value to 5, as default value is too strong & looks cheap when using default background
- Set OpenWeather to be in top-right, to show weather conditions in top bar, use mbar for pressure, show wind arrows & don't use decimals for temperature
- Enable Nautilus "Sort folders before files"
- Set keyboard delay to be much faster, as Gnome defaults are too slow
- "Window not responding" dialog extended to 20s
- Add Nautilus "New Document" to context menu
- Set Gnome Software to use Flathub-user remote by default
- Hide ROM Properties desktop shortcut
- Set Text Editor to use Nokia Pure text font, disable Restore Session, use higher contrast theme & highlight line numbers
- Set Calculator to separate thousands
- Set Clapper (Videos) to use Nokia Pure font for subtitles
  
## Installation (ISO) [Recommended]

Please read the [Wiki](https://github.com/fiftydinar/gidro-os/wiki) before proceeding.
ISOs are online-based & are constantly upgraded. There is no need to worry about the version & the date of the ISO.
Just download, install & enjoy!

Available for download in Releases page.

## Installation (Rebase)

> **Warning**
> [This is an experimental feature](https://www.fedoraproject.org/wiki/Changes/OstreeNativeContainerStable) and should not be used in production, try it in a VM for a while!

To rebase an existing Silverblue/Kinoite installation to the latest build:

- First rebase to the unsigned image, to get the proper signing keys and policies installed:

  AMD/Intel:
  ```
  rpm-ostree rebase ostree-unverified-registry:ghcr.io/fiftydinar/gidro-os:latest
  ```
  AMD/Intel + VRR:
  ```
  rpm-ostree rebase ostree-unverified-registry:ghcr.io/fiftydinar/gidro-os-vrr:latest
  ```
- Reboot to complete the rebase:
  ```
  systemctl reboot
  ```
- Then rebase to the signed image, like so:

  AMD/Intel:
  ```
  rpm-ostree rebase ostree-image-signed:docker://ghcr.io/fiftydinar/gidro-os:latest
  ```
  AMD/Intel + VRR:
  ```
  rpm-ostree rebase ostree-image-signed:docker://ghcr.io/fiftydinar/gidro-os-vrr:latest
  ```
- Reboot again to complete the installation
  ```
  systemctl reboot
  ```

This repository builds date tags as well, so if you want to rebase to a particular day's build:

AMD/Intel:
```
rpm-ostree rebase ostree-image-signed:docker://ghcr.io/fiftydinar/gidro-os:20231011
```
AMD/Intel + VRR:
```
rpm-ostree rebase ostree-image-signed:docker://ghcr.io/fiftydinar/gidro-os-vrr:20231011
```

## Repos used for some installed RPM packages
- [Gnome dynamic triple-buffering](https://copr.fedorainfracloud.org/coprs/eliasofwaffle/mutter-dynamic-triplebuffer/)
- [Gnome VRR](https://copr.fedorainfracloud.org/coprs/kylegospo/gnome-vrr/)
- [System76-Power](https://copr.fedorainfracloud.org/coprs/szydell/system76/)
- [System76-Scheduler](https://copr.fedorainfracloud.org/coprs/kylegospo/system76-scheduler/)
- [HL2Selinux](https://copr.fedorainfracloud.org/coprs/kylegospo/hl2linux-selinux/)
- [ROM Properties](https://copr.fedorainfracloud.org/coprs/kylegospo/rom-properties/)
- [Gnome-randr-rust](https://copr.fedorainfracloud.org/coprs/fiftydinar/gnome-randr-rust/)
- [Quick Close in Overview](https://copr.fedorainfracloud.org/coprs/fiftydinar/gnome-shell-extension-middleclickclose-git/)
- [OpenWeather](https://copr.fedorainfracloud.org/coprs/fiftydinar/gnome-shell-openweather-toppk/)

## Credits
- Bazzite (for hardware-setup service, some performance tweaks & some other stuff)
- PopOS (for System76 scheduler, System76-Power, storage I/O udev rule & ZRAM tweaks)

## Plans for the future
- Integrate all post-setup into image as much as possible
- Maintain current fork of OpenWeather from unmerged changes, as it looks like it is abandoned (separate extension reborn project is needed)
- Switch to git version of OpenWeather fork when it gains proper Gnome 45 support
- Migrate "Quick Close in Overview" extension from my copr to official rpm when it gets released
- Update System76-Power to latest version

Issues to fix:
- Find solution for lack of popular used fonts, mostly from Microsoft & Apple (BetterFonts causes font hinting issues, so other solution is needed)
