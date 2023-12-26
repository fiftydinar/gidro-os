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
- [Gnome Web](https://wiki.gnome.org/Apps/Web) from Flathub instead of Firefox
- [Mission Center](https://flathub.org/apps/io.missioncenter.MissionCenter) from Flathub instead of Gnome System Monitor
- [System76-Power](https://github.com/pop-os/system76-power) instead of Power Profiles Daemon (it is more aggressively, but still reliably, adjusting power-saving of various components + Power Profiles Daemon is depreciated)

Installed packages (RPMs):
- [System76 Scheduler](https://github.com/pop-os/system76-scheduler) (for performance improvement by adequately adjusting process priorities in realtime)
- [Team Fortress 2 SELinux rule](https://github.com/kylegospo/hl2linux-selinux) (for preventing "no certain sounds" issue)
- [Additional Game ROM Properties for Nautilus](https://github.com/GerbilSoft/rom-properties)
- [Nautilus Python](https://github.com/GNOME/nautilus-python) (for Python Nautilus extensions)
- [Python3-icoextract](https://github.com/jlu5/icoextract) (for .exe icons thumbnailing support)
- [Gnome-randr-rust](https://github.com/maxwellainatchi/gnome-randr-rust) (xrandr equivalent for Gnome Wayland)

Installed extensions:
- [Blur My Shell](https://github.com/aunetx/blur-my-shell)
- [Caffeine](https://github.com/eonpatapon/gnome-shell-extension-caffeine)
- [Quick Close in Overview](https://github.com/p91paul/middleclickclose)
- [OpenWeather](https://github.com/toppk/gnome-shell-extension-openweather)
- System76 Scheduler (needed for integration with Gnome)

Installed flatpaks:
- [Boxes](https://apps.gnome.org/en/Boxes/)
- [Calculator](https://apps.gnome.org/en/Calculator/)
- [Calendar](https://apps.gnome.org/en/Calendar/)
- [Camera](https://apps.gnome.org/en/Snapshot/)
- [Contacts](https://apps.gnome.org/en/Contacts/)
- [Clocks](https://apps.gnome.org/en/Clocks/)
- [Document Viewer](https://apps.gnome.org/en/Evince/)
- [Maps](https://apps.gnome.org/en/Maps/)
- [Text Editor](https://apps.gnome.org/en/TextEditor/)
- [G4Music](https://flathub.org/apps/com.github.neithern.g4music)
- [Clapper](https://flathub.org/apps/com.github.rafostar.Clapper)
- [Image Viewer](https://apps.gnome.org/en/Loupe/)
- [Secrets](https://apps.gnome.org/en/Secrets/)
- [Sticky Notes](https://flathub.org/apps/com.vixalien.sticky)
- [Rnote](https://flathub.org/apps/com.github.flxzt.rnote)
- [LocalSend](https://flathub.org/apps/org.localsend.localsend_app)
- [GPU Screen Recorder](https://flathub.org/apps/com.dec05eba.gpu_screen_recorder)
- [Flatseal](https://flathub.org/apps/com.github.tchx84.Flatseal)
- [Warehouse](https://flathub.org/apps/io.github.flattool.Warehouse)
- [PinApp](https://flathub.org/apps/io.github.fabrialberio.pinapp)
- [Extension Manager](https://flathub.org/apps/com.mattjakeman.ExtensionManager)
- [Easy Effects](https://flathub.org/apps/com.github.wwmm.easyeffects)
- [Bottles](https://flathub.org/apps/com.usebottles.bottles)

Optional flatpaks:
- [Warp (Global File Sharing)](https://apps.gnome.org/en/Warp/)
- [OBS Studio (Screen Recorder)](https://flathub.org/apps/com.obsproject.Studio)
- [Thunderbird (Email)](https://flathub.org/apps/org.mozilla.Thunderbird)
- [Discord](https://flathub.org/apps/com.discordapp.Discord)
- [Telegram](https://flathub.org/apps/org.telegram.desktop)
- [FreeTube (YouTube alt.)](https://flathub.org/apps/io.freetubeapp.FreeTube)
- [Dialect (Translator)](https://apps.gnome.org/en/Dialect/)
- [Deluge (Torrent)](https://flathub.org/apps/org.deluge_torrent.deluge)
- [ASCII Draw](https://flathub.org/apps/io.github.nokse22.asciidraw)
- [InkScape](https://flathub.org/apps/org.inkscape.Inkscape)
- [Mousai (Shazam alt.)](https://apps.gnome.org/en/Mousai/)
- [NewsFlash](https://apps.gnome.org/en/NewsFlash/)
- [LibreOffice](https://flathub.org/apps/org.libreoffice.LibreOffice)
- [Tagger](https://flathub.org/apps/org.nickvision.tagger)
- [Parabolic (YouTube Downloader)](https://flathub.org/apps/org.nickvision.tubeconverter)
- [Nicotine+ (Soulseek alt.)](https://flathub.org/apps/org.nicotine_plus.Nicotine)
- [Tenacity (Audacity alt.)](https://flathub.org/apps/org.tenacityaudio.Tenacity)
- [GitHub Desktop](https://flathub.org/apps/io.github.shiftey.Desktop)
- [Steam](https://flathub.org/apps/com.valvesoftware.Steam)
- [ProtonPlus (Steam Proton Manager)](https://flathub.org/apps/com.vysp3r.ProtonPlus)
- [PCSX2 (PS2 Emulator)](https://flathub.org/apps/net.pcsx2.PCSX2)
- [Space Cadet Pinball](https://flathub.org/apps/com.github.k4zmu2a.spacecadetpinball)
- [Grapejuice (Roblox)](https://flathub.org/apps/net.brinkervii.grapejuice)
- [Cartridges (Universal Game Launcher)](https://apps.gnome.org/en/Cartridges/)

Optional config:
- [Hide GRUB text output on boot](https://github.com/fiftydinar/gidro-os/wiki#how-to-apply-hide-grub-text-output-on-boot-config) (if you want to make boot process faster - hold Esc on boot if you need boot options back)
- [Hide close button from windows](https://github.com/fiftydinar/gidro-os/wiki#how-to-apply-hide-close-button-from-windows-config) (useful for mouses which have a special key for closing applications window)

Settings applied by default:
- [Enabled Vulkan support for AMD GCN 1.0 & GCN 2.0 GPUs](https://thespecter.net/blog/technology/enabling-amdgpu-on-fedora-31-for-using-vulkan-with-r7-and-r9-radeon-cards/) (for better performance & compatibility with those GPUs)
- [Kyber I/O scheduler for SSDs/NVMEs, BFQ I/O scheduler for HDDs/microSDs/eMMCs](https://github.com/pop-os/default-settings/pull/149) (for improved responsiveness under I/O load)
- [ZSTD I/O scheduler for ZRAM & better ZRAM values suited for desktop](https://github.com/pop-os/default-settings/pull/163) (avoids OOM situations better & it also improves responsiveness under I/O load)
- [Set memlock limit from 64kb to 2GB](https://github.com/RPCS3/rpcs3/issues/9328#issuecomment-732712084) (maps maximum locked value of 2GB per operation, needed for RPCS3 emulator)
- [Increased vm.max_map_count value to match SteamOS](https://www.reddit.com/r/linux_gaming/comments/10x1e6u/fix_hogwarts_legacy_loading_screen_crash/) (to allow some memory-hungry applications such as games to use more memory maps, which allows them to run & not crash)
- [Disabled kernel split-lock mitigate](https://github.com/doitsujin/dxvk/issues/2938) (for restoring performance of affected games)
- [Disabled memory core dumps](https://wiki.archlinux.org/title/Core_dump) (for preventing potential performance drop when dumping memory-heavy processes & for improving security)
- [Applied fix for non-working trim for LUKS partitions](https://bugzilla.redhat.com/show_bug.cgi?id=1801539)
- [Applied fix for keyboard language on LUKS unlock screen](https://github.com/fedora-silverblue/issue-tracker/issues/3)
- [Disabled kernel watchdog](https://wiki.archlinux.org/title/Power_management#Disabling_NMI_watchdog) (for improved performance & battery life)
- [Disabled most kernel logs](https://phabricator.whonix.org/T950) (for improving boot/shutdown times & for improving security)
- [Increased inotify limits](https://www.suse.com/support/kb/doc/?id=000020048) (for preventing errors like "too many open files" when installing/using some huge applications & games)
- [Increased file nolimits to prevent non-working Esync](https://github.com/lutris/docs/blob/master/HowToEsync.md)
- [BBR TCP congestion algorithm & FQ network packet scheduling](https://docs.google.com/spreadsheets/d/1I1NcVVbuC7aq4nGalYxMNz9pgS9OLKcFHssIBlj9xXI/edit#gid=1142336892) (for better network performance, especially in low-signal situations)
- [Partially fixed caps-lock delay](https://forum.manjaro.org/t/caps-lock-behaviour-wayland/79868) (which is present in all other Linux distributions)
- Enabled num-lock by default
- Enabled touchpad tap-to-click
- Set font hinting to "None"
- Set Nokia Pure Text font as default
- Set a beautiful Symbian^3 picture as a wallpaper
- [Set light & dark theme to AdwGtk3 for GTK3 applications](https://github.com/lassekongo83/adw-gtk3) (to make Adwaita design more consistent)
- [Use MoreWaita icon pack](https://github.com/somepaulo/MoreWaita) (to extend Adwaita theme icon language)
- Set Serbian Latin language as the locale (display language remains English)
- Set top bar to show weekday too in all languages
- Show battery percentage in top bar
- Power button powers off PC instead of suspending it
- Enabled "Remove Old Trash files automatically" in Nautilus (every 30 days by default in Gnome)
- Set mouse acceleration to flat 
- Set BlurMyShell sigma value to 5, as default value is too strong & looks cheap when using default background
- Set OpenWeather to be in top-right, to show weather conditions in top bar, use mbar for pressure, show wind arrows & don't use decimals for temperature
- Enabled Nautilus "Sort folders before files"
- Set keyboard delay to be much lower, as Gnome defaults are too slow
- ["Window not responding" dialog extended to 20s](https://github.com/ValveSoftware/csgo-osx-linux/issues/669) (to prevent constant dialog showup in some games)
- Add Nautilus "New Document" to context menu
- Set Gnome Software to use Flathub-user remote by default
- Hide ROM Properties desktop shortcut
- [Include Proton-GE with auto-download support for Steam](https://github.com/GloriousEggroll/proton-ge-custom)
- Steam silent auto-start on boot enabled (if app is installed)
- Discord silent auto-start on boot enabled (if app is installed)
- Telegram silent auto-start on boot enabled (if app is installed)
- Deluge auto-start on boot enabled (if app is installed)
- Set Text Editor to use Nokia Pure text font, disable Restore Session, use higher contrast theme & highlight line numbers
- Set Calculator to separate thousands
- Set Clapper (Videos) to use Nokia Pure font for subtitles, 100% volume by default & quit when video ends
- Gnome Web "Restore Tabs on Startup" disabled
- G4Music background playback enabled
  
## Installation (ISO) [Recommended]

Please read the [Wiki](https://github.com/fiftydinar/gidro-os/wiki) before proceeding.

ISOs are online-based & are constantly upgraded. There is no need to worry about the version & the date of the ISO.
Just download, install & enjoy!

Available for download in Releases page.

## Installation (Rebase)

Please read the [Wiki](https://github.com/fiftydinar/gidro-os/wiki) before proceeding.

Rebasing is only supported from Fedora Silverblue edition.

To rebase an existing Silverblue installation to the latest build:

- First rebase to the unsigned image, to get the proper signing keys and policies installed:
  ```
  rpm-ostree rebase ostree-unverified-registry:ghcr.io/fiftydinar/gidro-os:latest
  ```
- Reboot to complete the rebase:
  ```
  systemctl reboot
  ```
- Then rebase to the signed image, like so:
  ```
  rpm-ostree rebase ostree-image-signed:docker://ghcr.io/fiftydinar/gidro-os:latest
  ```
- Reboot again to complete the installation
  ```
  systemctl reboot
  ```

This repository builds date tags as well, so if you want to rebase to a particular day's build:

```
rpm-ostree rebase ostree-image-signed:docker://ghcr.io/fiftydinar/gidro-os:20231115
```

## Repos used for some installed RPM packages
- [System76-Power](https://copr.fedorainfracloud.org/coprs/szydell/system76/)
- [System76-Scheduler](https://copr.fedorainfracloud.org/coprs/kylegospo/system76-scheduler/)
- [HL2Selinux](https://copr.fedorainfracloud.org/coprs/kylegospo/hl2linux-selinux/)
- [ROM Properties](https://copr.fedorainfracloud.org/coprs/kylegospo/rom-properties/)
- [Gnome-randr-rust](https://copr.fedorainfracloud.org/coprs/fiftydinar/gnome-randr-rust/)
- [Quick Close in Overview](https://copr.fedorainfracloud.org/coprs/fiftydinar/gnome-shell-extension-middleclickclose-git/)
- [OpenWeather](https://copr.fedorainfracloud.org/coprs/fiftydinar/gnome-shell-openweather-toppk/)

## Plans for the future
- Integrate all post-setup into image as much as possible
- Maintain current fork of OpenWeather from unmerged changes, as it looks like it is abandoned (separate extension reborn project is needed)
- Migrate "Quick Close in Overview" extension from my copr to official rpm when it gets released
- Find solution for lack of popular used fonts, mostly from Microsoft & Apple (BetterFonts causes font hinting issues, so other solution is needed)
