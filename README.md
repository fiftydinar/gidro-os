# Gidro OS

My lightly customized image, based on Fedora Silverblue, nokmods edition, derived from UniversalBlue project.

Removed packages (RPMs):
- Firefox
- htop
- nvtop
- Gnome Software rpm-ostree package (not needed since we use UblueOS updater)
- Gnome classic session
- Gnome Tour
- Gnome System Monitor
- Gnome system extensions
- Gnome Tweaks

Replaced packages (RPMs)/usecases:
- Ungoogled Chromium from Flathub instead of Firefox rpm
- Mission Center from Flathub instead of Gnome System Monitor

Installed packages (RPMs):
- System76 Scheduler (for performance improvement by adequately adjusting process priorities in realtime)
- DDC Control (for setting up screen controls through GUI in OS)
- Team Fortress 2 SELinux rule (for preventing "no certain sounds" issue)
- Additional Game ROM Properties for Nautilus

Added extensions:
- Blur My Shell
- Caffeine
- System76 Scheduler (needed for integration with Gnome)

System(ish) flatpaks:
- Gnome Boxes
- Gnome Calculator
- Gnome Calendar
- Gnome Snapshot
- Gnome Document Viewer
- Gnome Maps
- Gnome Text Editor
- G4Music
- Clapper
- Gnome Image Viewer (Loupe)
- Secrets
- Sticky Notes
- Rnote
- Flatseal
- Extension Manager
- Gradience
- Easy Effects
- Bottles

User flatpaks:
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
- PCSX2
- Space Cadet Pinball
- Grapejuice
- ProtonPlus

Settings applied by default:
- BBR TCP congestion algorithm & FQ network packet scheduling (for better network performance, especially in low-signal situations)
- Increased vm.max_map_count value to match SteamOS (to allow some memory-hungry applications such as games to use more memory maps, which allows them to run & not crash)
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

Additional configuration:
- hide/unhide grub justfile

## Necessary Post-Setup

Config changes (one-liner command):
- Enable Nautilus "Sort folders before files"
- Add Nautilus "New Document" to context menu
- Set keyboard delay to be much faster, as Gnome defaults are too slow
- "Window not responding" dialog extended to 20s
- Hide ROM Properties desktop shortcut

Run this command after install until I implement this into the image:
  ```
just post-setup
  ```

## Post-Setup (for special devices & special usecases)
- Close button from windows removed (because I mapped the close button to special mouse key on Logitech G305)
  ```
  just hide-close-button
  ```

## Post-Setup (optional)
- Install OBS distrobox container
  ```
  just install-obs-studio-portable
  ```
- Install Bazzite-arch distrobox container, which includes Steam & Lutris for gaming + AdwSteamGTK skin (enter commands one by one)
  ```
  just distrobox-bazzite
  distrobox-enter -n bazzite-arch -- '  distrobox-export --app steam'
  distrobox-enter -n bazzite-arch -- '  distrobox-export --app lutris'
  distrobox-enter -n bazzite-arch -- '  paru -S adwsteamgtk --noconfirm'
  distrobox-enter -n bazzite-arch -- '  distrobox-export --app AdwSteamGtk'
  ```
- Hide GRUB
  ```
  just hide-grub
  ```

## Installation (ISO) [Recommended]

ISOs are online-based & are constantly upgraded. There is no need to worry about the version & the date of the ISO.
Just download, install & enjoy!

Available for download in Releases page.

## Installation (Rebase)

> **Warning**
> [This is an experimental feature](https://www.fedoraproject.org/wiki/Changes/OstreeNativeContainerStable) and should not be used in production, try it in a VM for a while!

To rebase an existing Silverblue/Kinoite installation to the latest build:

- First rebase to the unsigned image, to get the proper signing keys and policies installed:
  ```
  sudo rpm-ostree rebase ostree-unverified-registry:ghcr.io/fiftydinar/gidro-os:latest
  ```
- Reboot to complete the rebase:
  ```
  systemctl reboot
  ```
- Then rebase to the signed image, like so:
  ```
  sudo rpm-ostree rebase ostree-image-signed:docker://ghcr.io/fiftydinar/gidro-os:latest
  ```
- Reboot again to complete the installation
  ```
  systemctl reboot
  ```

This repository builds date tags as well, so if you want to rebase to a particular day's build:

```
sudo rpm-ostree rebase ostree-image-signed:docker://ghcr.io/fiftydinar/gidro-os:20230922
```

## Plans for the future
- Integrate necessary post-setup into the image
(some extensions are not available in rpm & some dconfs are not applying on boot)
- Integrate & separate image into triple-buffer & VRR variants
- Integrate Davinci Resolve container into just
- Separate system & user remote flatpaks in yafti
- Set "Flathub (user)" remote as a default in Gnome Software
- Disable "Enable 3rd party repos?" first-run prompt in Gnome Software
- Find replacement for non-fuctioning OpenWeather extension for Fedora 39/Gnome 45, which comes around 17th October. Same applies for post-install extensions: Quick Close in Overview & Rounded Window Corners
- Switch from nokmods build to main again when Fedora 39 gets building, as they will be the same, except nokmods will be removed
