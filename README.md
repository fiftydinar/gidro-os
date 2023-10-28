# Gidro-OS

> **Warning**
> This image is still in development & it's not ready yet until Fedora 39 official release land!

![](assets/bg.webp)

My customized image, based on Fedora Silverblue, main edition, derived from UniversalBlue project. Nvidia support is also included.

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
- Ungoogled Chromium from Flathub instead of Firefox rpm
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

Installed extensions:
- Blur My Shell
- Caffeine
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
- Hide GRUB text output on boot
- Hide close button from windows (useful for mouses which have a special key for closing applications window)

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
- Set Serbian Latin language as the locale (display language remains English)
- Set top bar to show weekday too in all languages
- Enable "Remove Old Trash files automatically" in Nautilus (every 30 days by default in Gnome)
- Set mouse acceleration to flat 
- Set BlurMyShell sigma value to 5, as default value is too strong & looks cheap when using default background
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
  sudo rpm-ostree rebase ostree-unverified-registry:ghcr.io/fiftydinar/gidro-os:latest
  ```
  AMD/Intel + VRR:
  ```
  sudo rpm-ostree rebase ostree-unverified-registry:ghcr.io/fiftydinar/gidro-os-vrr:latest
  ```
  Nvidia:
  ```
  sudo rpm-ostree rebase ostree-unverified-registry:ghcr.io/fiftydinar/gidro-os-nvidia:latest
  ```
  Nvidia + VRR:
  ```
  sudo rpm-ostree rebase ostree-unverified-registry:ghcr.io/fiftydinar/gidro-os-nvidia-vrr:latest
  ``` 
- Reboot to complete the rebase:
  ```
  systemctl reboot
  ```
- Then rebase to the signed image, like so:

  AMD/Intel:
  ```
  sudo rpm-ostree rebase ostree-image-signed:docker://ghcr.io/fiftydinar/gidro-os:latest
  ```
  AMD/Intel + VRR:
  ```
  sudo rpm-ostree rebase ostree-image-signed:docker://ghcr.io/fiftydinar/gidro-os-vrr:latest
  ```
  Nvidia:
  ```
  sudo rpm-ostree rebase ostree-image-signed:docker://ghcr.io/fiftydinar/gidro-os-nvidia:latest
  ```
  Nvidia + VRR:
  ```
  sudo rpm-ostree rebase ostree-image-signed:docker://ghcr.io/fiftydinar/gidro-os-nvidia-vrr:latest
  ```
- Reboot again to complete the installation
  ```
  systemctl reboot
  ```

This repository builds date tags as well, so if you want to rebase to a particular day's build:

AMD/Intel:
```
sudo rpm-ostree rebase ostree-image-signed:docker://ghcr.io/fiftydinar/gidro-os:20230930
```
AMD/Intel + VRR:
```
sudo rpm-ostree rebase ostree-image-signed:docker://ghcr.io/fiftydinar/gidro-os-vrr:20230930
```
Nvidia:
```
sudo rpm-ostree rebase ostree-image-signed:docker://ghcr.io/fiftydinar/gidro-os-nvidia:20230930
```
Nvidia + VRR:
```
sudo rpm-ostree rebase ostree-image-signed:docker://ghcr.io/fiftydinar/gidro-os-nvidia-vrr:20230930
```

## Credits
- Bazzite (for hardware-setup service, some performance tweaks, bazzite-arch & some other stuff)
- PopOS (for System76 scheduler, System76-Power, storage I/O udev rule & ZRAM tweaks)

## Plans for the future
- Integrate all post-setup into image as much as possible
- Integrate Davinci Resolve container into just & yafti
- Integrate "Quick Close in Overview" extension in an image as a rpm
- Integrate "OpenWeather" extension in an image as a rpm (currently use fork, as official is not ready)
- Switch from nxmbit dynamic triple-buffering repo to another one if it doesn't gain Fedora 39 support
- Find solution for lack of popular used fonts, mostly from Microsoft & Apple (BetterFonts causes font hinting issues, so other solution is needed)
- Find updated & more capable font, which is similar to Nokia Pure font (Nokia Pure can look off in some cases, especially when : symbol is used & g symbol can get cut off in some cases too)
- Update System76-Power to latest version
