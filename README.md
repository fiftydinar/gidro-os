# Gidro OS

My lightly customized image, based on Fedora Silverblue, main edition, derived from UniversalBlue project.

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
- Extensions

Added extensions:
- Blur My Shell
- OpenWeather
- Caffeine
- System76 Scheduler (needed for integration with Gnome)

System(ish) flatpaks:
- Flatseal
- Easy Effects
- Gnome Image Viewer (Loupe)
- Gnome Snapshot
- Gnome Document Viewer
- Gnome Text Editor
- Sticky Notes
- Secrets
- Gradience
- Gnome Calculator
- Gnome Calendar
- Gnome Maps
- Gnome Boxes
- Gnome Clocks
- LibreOffice
- G4Music
- Clapper
- Bottles

User flatpaks:
- Dialect
- Telegram Desktop
- Discord
- Rnote
- InkScape
- Fragments
- FreeTube
- ASCII Draw
- Mousai
- NewsFlash
- Tagger
- Parabolic
- Nicotine+
- Tenacity
- Thunderbird
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
- Set a beautiful Symbian^3 picture as a wallpaper as well
- Set Serbian Latin language as the locale (display language remains English)
- Set top bar to show weekday too in all languages
- Enable "Remove Old Trash files automatically" in Nautilus
- Set mouse acceleration to flat 
- Set BlurMyShell sigma value to 5, as default value is too strong & looks cheap when using default background
- Set OpenWeather to top right, set condition to show on top bar, set arrows for wind direction & use mbar for pressure

Additional configuration:
- OBS distrobox, hide/unhide grub justfile
- bling justfile

## Necessary Post-Setup
Install & enable selected extensions in Extension Manager:
- Quick Close in Overview
- Rounded Window Corners
- GTK3 Theme Switcher

Than apply "Enable Nautilus "Sort folders before files"" manually in Nautilus settings. (manually because command doesn't work right now)

Config changes (one-liner command):
- Add Nautilus "New Document" to context menu
- Set light & dark theme to AdwGtk3
- Set keyboard delay to be much faster, as Gnome defaults are too slow
- "Window not responding" dialog extended to 20s
- Hide ROM Properties desktop shortcut

Run this command after install until I implement this into the image:
  ```
touch ~/Templates/Untitled\ Document && gsettings --schemadir ~/.local/share/gnome-shell/extensions/gtk3-theme-switcher@charlieqle/schemas/ set org.gnome.shell.extensions.gtk3-theme-switcher light adw-gtk3 && gsettings --schemadir ~/.local/share/gnome-shell/extensions/gtk3-theme-switcher@charlieqle/schemas/ set org.gnome.shell.extensions.gtk3-theme-switcher dark adw-gtk3-dark && gsettings set org.gnome.desktop.peripherals.keyboard delay 226 && gsettings set org.gnome.mutter check-alive-timeout 20000 && cd /usr/share/applications && cp com.gerbilsoft.rom-properties.rp-config.desktop ~/.local/share/applications && cd ~/.local/share/applications && echo 'Hidden=true' >> com.gerbilsoft.rom-properties.rp-config.desktop && cd ~
  ```

## Post-Setup (for special devices & special usecases)
- Close button from windows removed (because I mapped the close button to special mouse key on Logitech G305)
 ```
gsettings set org.gnome.desktop.wm.preferences button-layout 'appmenu:'
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
- Integrate post-install commands into just, including revert commands
- Integrate & separate image into triple-buffer & VRR variants
- Integrate Davinci Resolve container into just
- Use Extension Manager instead of Gnome Extensions
(cannot remove Gnome Extensions because rpm-ostree doesn't recognize it as an installed package, which came from preinstalled extensions)
- Remove bloated bling justfile
(can't currently remove it, because of the upstream issue, where just command wouldn't work without it)
- Separate system & user remote flatpaks in yafti
- Separate custom flatpaks into groups in yafti
- Disable "Enable 3rd party repos?" first-run prompt in Gnome Software
