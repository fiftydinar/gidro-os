# `gnome-extensions`

The `gnome-extensions` module can be used to install Gnome extensions inside system directory.

This module is universally compatible with all distributions which ship Gnome, as long as some extension doesn't require some additional dependency, like Pano.

What does this module do?
- It parses the gettext-domain that you inputted, along with the extension version
- It downloads the extension directly from https://extensions.gnome.org
- Downloaded extension archive is then extracted to temporary directory
- All of its extracted files are copied to the appropriate final directories  
  (`/usr/share/glib-2.0/schemas`, `/usr/share/gnome-shell/extensions` & `/usr/share/locale`)

# Usage

To use this module, you need to input gettext-domain of the extension without @ symbol + the version of the extension in `.v%VERSION%` format.  
You can see gettext-domain of the extension by looking at the repo of the extension   
or by simply downloading the zip file from https://extensions.gnome.org & than look at the download URL part after `/extension-data/` & before `.v%VERSION%`.

You must assure that version of the extension is compatible with current Gnome version that your image is using.  
You can easily see this information when downloading extension from https://extensions.gnome.org
