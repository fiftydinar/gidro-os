# Gidro-OS

![](assets/bg.webp)

My customized image, based on [Fedora Silverblue](https://fedoraproject.org/atomic-desktops/silverblue/).

Gidro-OS was based on [Universal Blue's](https://universal-blue.org/) `silverblue-main` image in the past, but now, I just take some stuff that I need from them in a convenient recipe as a base.  
Reasoning for that is to have more control over the Universal Blue's base, which would make it possible for me to react immediately with changes if needed, to avoid some questionable additions to the base, to make image smaller (and with it, updates faster) etc.  
You can see my changes to the base recipe [here](https://github.com/fiftydinar/gidro-os/blob/main/recipes/base.yml).

`gidro-os-appimages` is an experimental version of Gidro-OS with flatpak-related stuff removed & with [`AM` AppImage manager](https://github.com/ivan-hc/AM) installed, to see if AppImage-only usage can replace flatpaks in the future.

This image is created using the easy & robust [BlueBuild](https://blue-build.org/) tooling for creating & maintaining container-based Linux desktop images.  
It is similar to making custom ROMs in the Android community, but in a much easier & more reliable way.

[**Why did I make the custom image?**](https://github.com/fiftydinar/gidro-os/wiki/1.-OS-Scope-&-Vision)  
[**Note for downstream custom image maintainers**](https://github.com/fiftydinar/gidro-os/wiki/8.-Note-for-downstream-custom-image-maintainers)

## Modifications

Removed packages (RPMs):
- [Gnome classic session](https://help.gnome.org/users/gnome-help/stable/gnome-classic.html.en)
- Gnome system extensions (some are from Fedora, some are from Gnome classic session, which are not needed)

Replaced packages (RPMs):
- [Yafti](https://github.com/ublue-os/yafti) instead of [Gnome Initial Setup](https://gitlab.gnome.org/GNOME/gnome-initial-setup) & [Gnome Tour](https://gitlab.gnome.org/GNOME/gnome-tour)  
   (for better, more suitable first-time install experience)
- [Power Profiles Daemon](https://gitlab.freedesktop.org/upower/power-profiles-daemon) instead of [Tuned](https://tuned-project.org/)  
   (because Power Profiles Daemon is simpler & more reliable than Tuned for power-management)
- [Trivalent](https://github.com/secureblue/Trivalent) instead of [Firefox](https://www.mozilla.org/en-US/firefox/)  
   (it is a more secure browser, has support for web applications, working hardware-accelerated video decoding + encoding out-of-the-box & ads blocker)

Replaced packages (RPMs) with flatpaks:
- [Mission Center](https://flathub.org/apps/io.missioncenter.MissionCenter) instead of [Gnome System Monitor](https://gitlab.gnome.org/GNOME/gnome-system-monitor)  
   (it is a much better looking task manager with more useful functionality)

Installed packages (RPMs):
- GNU Binutils (has some useful stuff)
- [Additional Game ROM Properties for Nautilus](https://github.com/GerbilSoft/rom-properties)
- [Nautilus Python](https://github.com/GNOME/nautilus-python) (for Python Nautilus extensions)
- [Python3-icoextract](https://github.com/jlu5/icoextract) (for .exe icons thumbnailing support)
- [Miniaturo](https://github.com/dbrgn/miniaturo) (RAW pictures thumbnailing for Nautilus)
- [Foo2zjs](https://www.openprinting.org/driver/foo2zjs/) (Driver which supports some additional Konica Minolta printers)
- [Uld](https://www.bchemnet.com/suldr/) (Driver which supports some additional Samsung printers)
- [sg3_utils](https://sg.danny.cz/sg/sg3_utils.html) (Package which contains utilities that send SCSI commands to devices - used by Apple SuperDrive)
- [rar](https://www.win-rar.com/rar-linux-mac.html?&L=0) (RAR CLI package)
- [pandoc](https://github.com/jgm/pandoc) (CLI Document converter)
- [fontconfig-font-replacements](https://github.com/hyperreal64/fedora-better-fonts) (Also known as `better-fonts`. It fills the gap of missing proprietary fonts with the open-source font replacements)
- [dr14_t.meter](https://github.com/simon-r/dr14_t.meter) (support for reading dynamic range of audio files)

Installed packages (AppImages/static binaries):
- [Android platform-tools](https://developer.android.com/tools/releases/platform-tools)

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
- [Media Progress](https://github.com/Krypion17/media-progress)
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
- [Reco Audio Recorder](https://flathub.org/apps/com.github.ryonakano.reco)
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
- [Main Menu](https://flathub.org/apps/page.codeberg.libre_menu_editor.LibreMenuEditor)
- [Extension Manager](https://flathub.org/apps/com.mattjakeman.ExtensionManager)
- [Easy Effects](https://flathub.org/apps/com.github.wwmm.easyeffects)

Optional just config:
- [Hide close button from windows](https://github.com/fiftydinar/gidro-os/wiki/6.-Gidro%E2%80%90OS-useful-commands-&-config#how-to-apply-hide-close-button-from-windows-config) (useful for mouses which have a special key for closing applications window)
- [Scheduled nightly reboot](https://github.com/fiftydinar/gidro-os/wiki/6.-Gidro%E2%80%90OS-useful-commands-&-config#how-to-apply-scheduled-nightly-reboot-config) (useful for applying system updates if you're leaving your PC turned on 24/7)
- [Disable Bluetooth headset profile (HSP/HFP)](https://github.com/fiftydinar/gidro-os/wiki/6.-Gidro%E2%80%90OS-useful-commands-&-config#how-to-disable-bluetooth-headset-profile) (useful if you don't use mic from Bluetooth headphones, so you don't get surprisingly switched to lower audio quality headset profile)

Settings applied by default:
- Change `${HOME}` directory structure to be cleaner, as much as possible without dotfiles (some programs won't respect it, no matter what)
  - `Local` folder instead of `.local` (including subfolders like `config`, `share`, `state` & `cache`)
  - Add `Applications` folder & add it to `PATH` (`${HOME}/.local/bin/` is still supported in `PATH`)
  - Add `Games` folder
  - Add `Volatile` folder (useful for testing temporary stuff, which are gone after system reboot)
  - Ensure that some programs respect XDG directory structure, to not mess the `${HOME}` directory
- [Disabled option for installing system packages, aka layering through `rpm-ostree` & `dnf`](https://github.com/fiftydinar/gidro-os/wiki/2.-Unsupported-Operations#why-rpm-ostree-installremove-or-dnf-installremove-doesnt-work-to-installremove-some-applications-) (to ensure that system integrity & reliability remains untouched)
- [Enabled experimental support for Variable Refresh Rate on supported screens](https://global.samsungdisplay.com/31137) (improves video & gaming experience by dynamically matching screen refresh rate with the content framerate)
- [Enabled Vulkan support for AMD GCN 1.0 & GCN 2.0 GPUs](https://thespecter.net/blog/technology/enabling-amdgpu-on-fedora-31-for-using-vulkan-with-r7-and-r9-radeon-cards/) (for better performance & compatibility with those GPUs)
- [Kyber I/O scheduler for SSDs/NVMEs, BFQ I/O scheduler for HDDs/microSDs/eMMCs](https://github.com/pop-os/default-settings/pull/149) (for improved responsiveness under I/O load)
- [ZSTD I/O scheduler for ZRAM & better ZRAM values suited for desktop](https://github.com/pop-os/default-settings/pull/163) (avoids OOM situations better & it also improves responsiveness under I/O load. Also thanks to [MaxPerfWiz](https://gitlab.com/cscs/maxperfwiz) & [@ahydronous](https://gist.github.com/ahydronous/7ceaa00df96ef99131600edd4c2c73f2) for some good research & values.)
- [Set memlock limit from 64kb to 2GB](https://github.com/RPCS3/rpcs3/issues/9328#issuecomment-732712084) (maps maximum locked value of 2GB per operation, needed for RPCS3 emulator)
- [Increased vm.max_map_count value to match SteamOS](https://www.reddit.com/r/linux_gaming/comments/10x1e6u/fix_hogwarts_legacy_loading_screen_crash/) (to allow some memory-hungry applications such as games to use more memory maps, which allows them to run & not crash)
- [Disabled kernel split-lock mitigate](https://github.com/doitsujin/dxvk/issues/2938) (for restoring performance of affected games)
- [Enabled full kernel preemption](https://lwn.net/Articles/944686/) (increases system responsiveness with negligible cost of some throughput)
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
- Force font hinting to be manual, instead of automatic based on display resolution
- Set Nokia Pure Text font as the default
- Set Source Code Pro font as the monospace default (Gnome <=47 monospace font)
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
  - use OpenWeatherMap provider by default
- Set Notifications Alert to use less distracting, but still noticeable color for the alert instead of default bright red. This color also fits the top bar blur much better.
- Set Bluetooth Battery Meter to:
  - Show battery percentage
  - Show battery for upower 2.4Ghz devices
  - Enable experimental Bluetooth features to make it more compatible with it
- Set Night Time Switcher time offset to 0 & set manual time (time based on automatic location is not accurate. Manual location can be specified instead)
- Set Gnome 4x UI Improvements to only enable wallpaper thumbnails in workspace switcher
- Set Media Progress to use Nokia Pure Text T font instead of the hardcoded one
- Enabled Nautilus "Sort folders before files"
- Set keyboard delay to be much lower, as Gnome defaults are too slow
- ["Window not responding" dialog extended to 20s](https://github.com/ValveSoftware/csgo-osx-linux/issues/669) (to prevent constant dialog showup in some games)
- Add Nautilus "New Document" to context menu
- Set Gnome Software to use Flathub-user remote by default (makes separation between OS flatpaks & user flatpaks much better)
- Disable Gnome Software flatpak auto-updater (not needed since Gidro-OS uses included [ublue-os flatpak auto-updater](https://github.com/ublue-os/config/blob/main/rpmspec/ublue-os-update-services.spec))
- Disable Gnome Software "Software Repositories" option (Warehouse implements the same functionality)
- Use F41 version of Gnome Software until [annoying notification pop-up is fixed](https://gitlab.gnome.org/GNOME/gnome-software/-/issues/2802)
- [Lock some settings to prevent users messing with the system reliability, while still remaining customizable](https://github.com/fiftydinar/gidro-os/wiki/2.-Unsupported-Operations#why-are-some-setting-toggles-grayed-out-i-cant-change-them)
- Hide ROM Properties desktop shortcut
- Enable silent auto-start on boot for those applications:
  - Steam
  - Discord
  - ArmCord
  - Telegram
  - Deluge
  - TutaMail
- Set Trivalent to:
  - disable Network Sandbox (solves data persistence bug)
  - disable search choice pop-up
  - enable middle-click mouse scrolling
  - use secureblue's selinux policy
- Set Text Editor to:
  - use Nokia Pure Text font
  - increase the font size to 16
  - disable Restore Session
  - use higher contrast theme
  - highlight line numbers
- Set Folio to use Nokia Pure Text font
- Set Calculator to separate thousands
- Set Clapper (Videos) to use Nokia Pure Text font for subtitles
- Set Gapless to enable background playback
- Set Terminal (Ptyxis) to don't restore session by default
- Use cool BlueBuild boot & login-screen logo instead of Fedora

## Installation (ISO) [Recommended]

> [!IMPORTANT]  
> Please read the [Wiki](https://github.com/fiftydinar/gidro-os/wiki) before proceeding with the installation.

> [!IMPORTANT]  
> Backup your important data before proceeding with the installation.

> [!CAUTION]
> This ISO installation guide assumes that you want to install Gidro-OS on single-boot single-disk setup.

### [DOWNLOAD LINK](https://archive.org/details/@fifty_dinar)<br/>(ISOs are in DD-MM-YYYY date format)

- ISO doesn't require an active internet connection during its usage (but it is recommended to have it, to make NTP working).
- Download the ISO & proceed with installation.
- When ISO is booted, finish the following mandatory tasks:
  - In "Installation Destination", select on which disk to install Gidro-OS, select "Storage Configuration" to Automatic & select "Free up space by removing or shrinking existing partitions".  
    "Reclaim disk space" screen will pop-up. Click "Delete all" & "Reclaim space".
  - In "User Creation", input full name, user name & password. Click Done.
- Optionally do tasks of "Keyboard", "Language Support", "Time & Date", etc.
- Click "Begin Installation"
- When ISO finished the installation, follow the instructions of the 1st-time setup pop-up & finish it.

## Installation (Rebase)

> [!IMPORTANT]  
> Please read the [Wiki](https://github.com/fiftydinar/gidro-os/wiki) before proceeding with the installation.

> [!IMPORTANT]  
> Backup your important data before proceeding with the installation.

To rebase an existing installation to the latest build:

- Update your current system to the latest version (system will reboot):
  ```
  sudo bootc upgrade --apply
  ```
- Rebase to the unsigned image, to get the proper signing keys and policies installed (system will reboot):
  ```
  sudo bootc switch --apply ghcr.io/fiftydinar/gidro-os:latest
  ```
- Then rebase to the signed image, like this (system will reboot):
  ```
  sudo bootc switch --enforce-container-sigpolicy --apply ghcr.io/fiftydinar/gidro-os:latest
  ```
- 1st-time setup should pop-up, just follow the instructions of it & finish it  
  (don't worry if you didn't finish it before, 1st-time setup remembers the setup state & it will be present until finished)

## COPR repos used for some installed RPM packages
- [ROM Properties](https://copr.fedorainfracloud.org/coprs/bazzite-org/rom-properties/)
- [Miniaturo](https://copr.fedorainfracloud.org/coprs/decathorpe/miniaturo/)
- [Better Fonts](https://copr.fedorainfracloud.org/coprs/hyperreal/better_fonts/)
- [Trivalent subresource filter](https://copr.fedorainfracloud.org/coprs/secureblue/trivalent/)
- [DR14 T Meter](https://copr.fedorainfracloud.org/coprs/sassam/dr14_tmeter/)
