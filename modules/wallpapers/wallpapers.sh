#!/usr/bin/env bash

set -euo pipefail

MODULE_DIRECTORY="${MODULE_DIRECTORY:-"/tmp/modules"}"
wallpapers_module_dir="$MODULE_DIRECTORY"/wallpapers

get_yaml_array DEFAULT_WALLPAPER '.default.wallpaper[]' "$1"
# If file-name has whitespace, convert it to _ character.
readarray -t DEFAULT_WALLPAPER < <(printf '%s\n' "${DEFAULT_WALLPAPER[@]}" | tr ' ' '_')
get_yaml_array DEFAULT_WALLPAPER_LIGHT_DARK '.default.wallpaper-light-dark[]' "$1"
# If file-name has whitespace, convert it to _ character.
readarray -t DEFAULT_WALLPAPER_LIGHT_DARK < <(printf '%s\n' "${DEFAULT_WALLPAPER_LIGHT_DARK[@]}" | tr ' ' '_')
# Separate default light & dark wallpaper entry (without need to make another yaml array). It must contain "-bb-light" &/or "-bb-dark" word in filename.
readarray -t DEFAULT_WALLPAPER_LIGHT < <(printf '%s\n' "${DEFAULT_WALLPAPER_LIGHT_DARK[@]}" | awk -F '_\\+_' '{print $1}')
readarray -t DEFAULT_WALLPAPER_DARK < <(printf '%s\n' "${DEFAULT_WALLPAPER_LIGHT_DARK[@]}" | awk -F '_\\+_' '{print $NF}')

# Scaling (use special variables for all & for specific wallpapers)
SCALING_NONE_ALL=$(yq '.scaling.none' "$1")
SCALING_SCALED_ALL=$(yq '.scaling.scaled' "$1")
SCALING_STRETCHED_ALL=$(yq '.scaling.stretched' "$1")
SCALING_ZOOM_ALL=$(yq '.scaling.zoom' "$1")
SCALING_CENTERED_ALL=$(yq '.scaling.centered' "$1")
SCALING_SPANNED_ALL=$(yq '.scaling.spanned' "$1")
SCALING_WALLPAPER_ALL=$(yq '.scaling.wallpaper' "$1")
get_yaml_array SCALING_NONE '.scaling.none[]' "$1"
# If file-name has whitespace, convert it to _ character.
readarray -t SCALING_NONE < <(printf '%s\n' "${SCALING_NONE[@]}" | tr ' ' '_')
get_yaml_array SCALING_SCALED '.scaling.scaled[]' "$1"
# If file-name has whitespace, convert it to _ character.
readarray -t SCALING_SCALED < <(printf '%s\n' "${SCALING_SCALED[@]}" | tr ' ' '_')
get_yaml_array SCALING_STRETCHED '.scaling.stretched[]' "$1"
# If file-name has whitespace, convert it to _ character.
readarray -t SCALING_STRETCHED < <(printf '%s\n' "${SCALING_STRETCHED[@]}" | tr ' ' '_')
get_yaml_array SCALING_ZOOM '.scaling.zoom[]' "$1"
# If file-name has whitespace, convert it to _ character.
readarray -t SCALING_ZOOM < <(printf '%s\n' "${SCALING_ZOOM[@]}" | tr ' ' '_')
get_yaml_array SCALING_CENTERED '.scaling.centered[]' "$1"
# If file-name has whitespace, convert it to _ character.
readarray -t SCALING_CENTERED < <(printf '%s\n' "${SCALING_CENTERED[@]}" | tr ' ' '_')
get_yaml_array SCALING_SPANNED '.scaling.spanned[]' "$1"
# If file-name has whitespace, convert it to _ character.
readarray -t SCALING_SPANNED < <(printf '%s\n' "${SCALING_SPANNED[@]}" | tr ' ' '_')
get_yaml_array SCALING_WALLPAPER '.scaling.wallpaper[]' "$1"
# If file-name has whitespace, convert it to _ character.
readarray -t SCALING_WALLPAPER < <(printf '%s\n' "${SCALING_WALLPAPER[@]}" | tr ' ' '_')

wallpaper_include_location="/tmp/config/wallpapers"
wallpaper_location="/usr/share/backgrounds/bluebuild"
wallpaper_gnome_xml="/usr/share/gnome-background-properties"

echo "Installing wallpapers module"

# Copy wallpapers when they are present & fail if they are not
if [ -d "$wallpaper_include_location" ]; then
  if [[ $(find "$wallpaper_include_location") ]]; then
    echo "Copying wallpapers into system backgrounds directory"
    # If file-names & wallpaper folders have whitespaces, convert them to _ character.
    find "$wallpaper_include_location" -depth -name "* *" -execdir bash -c 'mv "$0" "${0// /_}"' {} \;
    cp -r "$wallpaper_include_location"/* "$wallpaper_location"
  else
    echo "Module failed because wallpapers aren't included in config/wallpapers directory"
    exit 1
  fi
fi

# Check if Gnome DE is being used for configuring advanced options. If it's not, exit this script successfully.
gnome_detection=$(find /usr/bin -type f -name "gnome-session" -printf "%f\n")
if [[ ! $gnome_detection == gnome-session ]]; then
  echo "Wallpapers module installed successfully!"
  exit 0
fi

# Separate included light/dark wallpapers list from the default wallpapers. Also don't include ./ prefix in files & include filenames only.
readarray -t WALLPAPER_LIGHT_DARK < <(find "$wallpaper_include_location"/bluebuild-gnome-light-dark -type f "${DEFAULT_WALLPAPER_LIGHT[@]/#/-not -name }" "${DEFAULT_WALLPAPER_DARK[@]/#/-not -name }" -printf "%f\n")
# Separate light & dark wallpaper entry. It must contain "-bb-light" &/or "-bb-dark" word in filename.
readarray -t WALLPAPER_LIGHT < <(printf '%s\n' "${WALLPAPER_LIGHT_DARK[@]}" | awk '/-bb-light/')
readarray -t WALLPAPER_DARK < <(printf '%s\n' "${WALLPAPER_LIGHT_DARK[@]}" | awk '/-bb-dark/')
# Separate included wallpapers list from the default wallpapers. Also don't include ./ prefix in files & include filenames only. Exclude directory for light/dark wallpapers inclusion.
readarray -t WALLPAPER < <(find "$wallpaper_include_location" -type d -not -path "$wallpaper_include_location/bluebuild-gnome-light-dark" -type f "${DEFAULT_WALLPAPER[@]/#/-not -name }" -printf "%f\n")

# Write XMLs to make included wallpapers appear in Gnome settings.
# Remove filename-dark field, as it's not needed for classic wallpapers
# Set name of the wallpaper to BlueBuild-nameofthewallpaper.jpg.xml
for wallpaper in "${WALLPAPER[@]}"; do
  cp "$wallpapers_module_dir"/bluebuild.xml "$wallpaper_gnome_xml"
  yq -i '.wallpapers.wallpaper.name = "BlueBuild-'"$wallpaper"'"' "$wallpaper_gnome_xml"/bluebuild.xml
  yq -i '.wallpapers.wallpaper.filename = $wallpaper_location/$wallpaper' "$wallpaper_gnome_xml"/bluebuild.xml
  yq 'del(.wallpapers.wallpaper.filename-dark)' "$wallpaper_gnome_xml"/bluebuild.xml -i
  if [[ "$SCALING_NONE_ALL" = "all" ]]; then
  yq -i '.wallpapers.wallpaper.options = none' "$wallpaper_gnome_xml"/bluebuild.xml
  fi
  if [[ "$SCALING_SCALED_ALL" = "all" ]]; then
  yq -i '.wallpapers.wallpaper.options = scaled' "$wallpaper_gnome_xml"/bluebuild.xml
  fi
  if [[ "$SCALING_STRETCHED_ALL" = "all" ]]; then
  yq -i '.wallpapers.wallpaper.options = stretched' "$wallpaper_gnome_xml"/bluebuild.xml
  fi
  if [[ "$SCALING_ZOOM_ALL" = "all" ]]; then
  yq -i '.wallpapers.wallpaper.options = zoom' "$wallpaper_gnome_xml"/bluebuild.xml
  fi
  if [[ "$SCALING_CENTERED_ALL" = "all" ]]; then
  yq -i '.wallpapers.wallpaper.options = centered' "$wallpaper_gnome_xml"/bluebuild.xml
  fi
  if [[ "$SCALING_SPANNED_ALL" = "all" ]]; then
  yq -i '.wallpapers.wallpaper.options = spanned' "$wallpaper_gnome_xml"/bluebuild.xml
  fi
  if [[ "$SCALING_WALLPAPER_ALL" = "all" ]]; then
  yq -i '.wallpapers.wallpaper.options = wallpaper' "$wallpaper_gnome_xml"/bluebuild.xml
  fi
  mv "$wallpaper_gnome_xml"/bluebuild.xml "$wallpaper_gnome_xml"/bluebuild-"$wallpaper".xml
done

# Write XMLs to make included light/dark wallpapers appear in Gnome settings.
# Set name of the wallpaper to BlueBuild-nameofthewallpaper.jpg.xml
for wallpaper_light in "${WALLPAPER_LIGHT[@]}"; do
  for wallpaper_dark in "${WALLPAPER_DARK[@]}"; do
    cp "$wallpapers_module_dir"/bluebuild.xml "$wallpaper_gnome_xml"
    yq -i '.wallpapers.wallpaper.name = "BlueBuild-'"$wallpaper_light"_+_$wallpaper_dark'"' "$wallpaper_gnome_xml"/bluebuild.xml
    yq -i '.wallpapers.wallpaper.filename = $wallpaper_location/$wallpaper_light' "$wallpaper_gnome_xml"/bluebuild.xml
    yq -i '.wallpapers.wallpaper.filename-dark = $wallpaper_location/$wallpaper_dark' "$wallpaper_gnome_xml"/bluebuild.xml
    if [[ "$SCALING_NONE_ALL" = "all" ]]; then
      yq -i '.wallpapers.wallpaper.options = none' "$wallpaper_gnome_xml"/bluebuild.xml
    fi
    if [[ "$SCALING_SCALED_ALL" = "all" ]]; then
      yq -i '.wallpapers.wallpaper.options = scaled' "$wallpaper_gnome_xml"/bluebuild.xml
    fi
    if [[ "$SCALING_STRETCHED_ALL" = "all" ]]; then
      yq -i '.wallpapers.wallpaper.options = stretched' "$wallpaper_gnome_xml"/bluebuild.xml
    fi
    if [[ "$SCALING_ZOOM_ALL" = "all" ]]; then
      yq -i '.wallpapers.wallpaper.options = zoom' "$wallpaper_gnome_xml"/bluebuild.xml
    fi
    if [[ "$SCALING_CENTERED_ALL" = "all" ]]; then
      yq -i '.wallpapers.wallpaper.options = centered' "$wallpaper_gnome_xml"/bluebuild.xml
    fi
    if [[ "$SCALING_SPANNED_ALL" = "all" ]]; then
      yq -i '.wallpapers.wallpaper.options = spanned' "$wallpaper_gnome_xml"/bluebuild.xml
    fi
    if [[ "$SCALING_WALLPAPER_ALL" = "all" ]]; then
      yq -i '.wallpapers.wallpaper.options = wallpaper' "$wallpaper_gnome_xml"/bluebuild.xml
    fi
    mv "$wallpaper_gnome_xml"/bluebuild.xml "$wallpaper_gnome_xml"/bluebuild-"$wallpaper_light"_+_"$wallpaper_dark".xml
  done
done

# Write XMLs to make default wallpaper appear in Gnome settings.
# Remove filename-dark field, as it's not needed for the default wallpaper
# Set name of the XML to BlueBuild-nameofthewallpaper.jpg.xml
for default_wallpaper in "${DEFAULT_WALLPAPER[@]}"; do
  cp "$wallpapers_module_dir"/bluebuild.xml "$wallpaper_gnome_xml"
  yq -i '.wallpapers.wallpaper.name = "BlueBuild-'"$default_wallpaper"'"' "$wallpaper_gnome_xml"/bluebuild.xml
  yq -i '.wallpapers.wallpaper.filename = $wallpaper_location/$default_wallpaper' "$wallpaper_gnome_xml"/bluebuild.xml
  yq 'del(.wallpapers.wallpaper.filename-dark)' "$wallpaper_gnome_xml"/bluebuild.xml -i
  if [[ "$SCALING_NONE_ALL" = "all" ]]; then
  yq -i '.wallpapers.wallpaper.options = none' "$wallpaper_gnome_xml"/bluebuild.xml
  fi
  if [[ "$SCALING_SCALED_ALL" = "all" ]]; then
  yq -i '.wallpapers.wallpaper.options = scaled' "$wallpaper_gnome_xml"/bluebuild.xml
  fi
  if [[ "$SCALING_STRETCHED_ALL" = "all" ]]; then
  yq -i '.wallpapers.wallpaper.options = stretched' "$wallpaper_gnome_xml"/bluebuild.xml
  fi
  if [[ "$SCALING_ZOOM_ALL" = "all" ]]; then
  yq -i '.wallpapers.wallpaper.options = zoom' "$wallpaper_gnome_xml"/bluebuild.xml
  fi
  if [[ "$SCALING_CENTERED_ALL" = "all" ]]; then
  yq -i '.wallpapers.wallpaper.options = centered' "$wallpaper_gnome_xml"/bluebuild.xml
  fi
  if [[ "$SCALING_SPANNED_ALL" = "all" ]]; then
  yq -i '.wallpapers.wallpaper.options = spanned' "$wallpaper_gnome_xml"/bluebuild.xml
  fi
  if [[ "$SCALING_WALLPAPER_ALL" = "all" ]]; then
  yq -i '.wallpapers.wallpaper.options = wallpaper' "$wallpaper_gnome_xml"/bluebuild.xml
  fi
  mv "$wallpaper_gnome_xml"/bluebuild.xml "$wallpaper_gnome_xml"/bluebuild-"$default_wallpaper".xml
done

# Write XMLs to make default light/dark wallpaper appear in Gnome settings.
# Set name of the wallpaper to BlueBuild-nameofthewallpaper.jpg.xml
for default_wallpaper_light in "${DEFAULT_WALLPAPER_LIGHT[@]}"; do
  for default_wallpaper_dark in "${DEFAULT_WALLPAPER_DARK[@]}"; do
    cp "$wallpapers_module_dir"/bluebuild.xml "$wallpaper_gnome_xml"
    yq -i '.wallpapers.wallpaper.name = "BlueBuild-'"$default_wallpaper_light"_+_$default_wallpaper_dark'"' "$wallpaper_gnome_xml"/bluebuild.xml
    yq -i '.wallpapers.wallpaper.filename = $wallpaper_location/$default_wallpaper_light' "$wallpaper_gnome_xml"/bluebuild.xml
    yq -i '.wallpapers.wallpaper.filename-dark = $wallpaper_location/$default_wallpaper_dark' "$wallpaper_gnome_xml"/bluebuild.xml
    if [[ "$SCALING_NONE_ALL" = "all" ]]; then
      yq -i '.wallpapers.wallpaper.options = none' "$wallpaper_gnome_xml"/bluebuild.xml
    fi
    if [[ "$SCALING_SCALED_ALL" = "all" ]]; then
      yq -i '.wallpapers.wallpaper.options = scaled' "$wallpaper_gnome_xml"/bluebuild.xml
    fi
    if [[ "$SCALING_STRETCHED_ALL" = "all" ]]; then
      yq -i '.wallpapers.wallpaper.options = stretched' "$wallpaper_gnome_xml"/bluebuild.xml
    fi
    if [[ "$SCALING_ZOOM_ALL" = "all" ]]; then
      yq -i '.wallpapers.wallpaper.options = zoom' "$wallpaper_gnome_xml"/bluebuild.xml
    fi
    if [[ "$SCALING_CENTERED_ALL" = "all" ]]; then
      yq -i '.wallpapers.wallpaper.options = centered' "$wallpaper_gnome_xml"/bluebuild.xml
    fi
    if [[ "$SCALING_SPANNED_ALL" = "all" ]]; then
      yq -i '.wallpapers.wallpaper.options = spanned' "$wallpaper_gnome_xml"/bluebuild.xml
    fi
    if [[ "$SCALING_WALLPAPER_ALL" = "all" ]]; then
      yq -i '.wallpapers.wallpaper.options = wallpaper' "$wallpaper_gnome_xml"/bluebuild.xml
    fi
    mv "$wallpaper_gnome_xml"/bluebuild.xml "$wallpaper_gnome_xml"/bluebuild-"$default_wallpaper_light"_+_"$default_wallpaper_dark".xml
  done
done

# Write per-wallpaper scaling settings
for scaling_none in "${SCALING_NONE[@]}"; do
  yq -i '.wallpapers.wallpaper.options = none' "$wallpaper_gnome_xml"/bluebuild-"$scaling_none".xml
done
for scaling_scaled in "${SCALING_SCALED[@]}"; do
  yq -i '.wallpapers.wallpaper.options = scaled' "$wallpaper_gnome_xml"/bluebuild-"$scaling_scaled".xml
done
for scaling_stretched in "${SCALING_STRETCHED[@]}"; do
  yq -i '.wallpapers.wallpaper.options = stretched' "$wallpaper_gnome_xml"/bluebuild-"$scaling_stretched".xml
done
for scaling_zoom in "${SCALING_ZOOM[@]}"; do
  yq -i '.wallpapers.wallpaper.options = zoom' "$wallpaper_gnome_xml"/bluebuild-"$scaling_zoom".xml
done
for scaling_centered in "${SCALING_CENTERED[@]}"; do
  yq -i '.wallpapers.wallpaper.options = centered' "$wallpaper_gnome_xml"/bluebuild-"$scaling_centered".xml
done
for scaling_spanned in "${SCALING_SPANNED[@]}"; do
  yq -i '.wallpapers.wallpaper.options = spanned' "$wallpaper_gnome_xml"/bluebuild-"$scaling_spanned".xml
done
for scaling_wallpaper in "${SCALING_WALLPAPER[@]}"; do
  yq -i '.wallpapers.wallpaper.options = wallpaper' "$wallpaper_gnome_xml"/bluebuild-"$scaling_wallpaper".xml
done

# Write default wallpaper to gschema override
if [[ ${#DEFAULT_WALLPAPER[@]} == 1 ]]; then
  printf "%s" "Setting ${DEFAULT_WALLPAPER[@]} as the default wallpaper in gschema override"
  printf  "picture-uri='file://$wallpaper_location/${DEFAULT_WALLPAPER[@]}'" >> "$wallpapers_module_dir"/zz2-bluebuild-wallpapers.gschema.override
elif [[ ${#DEFAULT_WALLPAPER[@]} -gt 1 ]]; then
  echo "Module failed because you included more than 1 wallpaper to be set as default, which is not allowed"
  exit 1
fi

# Write default light/dark theme wallpaper to gschema override
if [[ ${#DEFAULT_WALLPAPER_LIGHT_DARK[@]} == 1 ]]; then
  printf "%s" "Setting ${DEFAULT_WALLPAPER_LIGHT_DARK[@]} as the default light/dark wallpaper in gschema override"
  printf  "picture-uri='file://$wallpaper_location/${DEFAULT_WALLPAPER_LIGHT[@]}'" >> "$wallpapers_module_dir"/zz2-bluebuild-wallpapers.gschema.override
  printf  "picture-uri-dark='file://$wallpaper_location/${DEFAULT_WALLPAPER_DARK[@]}'" >> "$wallpapers_module_dir"/zz2-bluebuild-wallpapers.gschema.override 
elif [[ ${#DEFAULT_WALLPAPER_LIGHT_DARK[@]} -gt 1 ]]; then
  echo "Module failed because you included more than 1 light & dark wallpaper to be set as default for light/dark theme, which is not allowed"
  exit 1
fi

# Overwrite default "zoom" scaling value if user supplied their own option with global scaling in gschema override
if [[ "$SCALING_NONE_ALL" = "all" ]]; then
  sed -i "s/picture-options=.*/picture-options='none'/" "$wallpapers_module_dir/zz2-bluebuild-wallpapers.gschema.override"
fi
if [[ "$SCALING_SCALED_ALL" = "all" ]]; then
  sed -i "s/picture-options=.*/picture-options='scaled'/" "$wallpapers_module_dir/zz2-bluebuild-wallpapers.gschema.override"
fi
if [[ "$SCALING_STRETCHED_ALL" = "all" ]]; then
  sed -i "s/picture-options=.*/picture-options='stretched'/" "$wallpapers_module_dir/zz2-bluebuild-wallpapers.gschema.override"
fi
if [[ "$SCALING_ZOOM_ALL" = "all" ]]; then
  sed -i "s/picture-options=.*/picture-options='zoom'/" "$wallpapers_module_dir/zz2-bluebuild-wallpapers.gschema.override"
fi
if [[ "$SCALING_CENTERED_ALL" = "all" ]]; then
  sed -i "s/picture-options=.*/picture-options='centered'/" "$wallpapers_module_dir/zz2-bluebuild-wallpapers.gschema.override"
fi
if [[ "$SCALING_SPANNED_ALL" = "all" ]]; then
  sed -i "s/picture-options=.*/picture-options='spanned'/" "$wallpapers_module_dir/zz2-bluebuild-wallpapers.gschema.override"
fi
if [[ "$SCALING_WALLPAPER_ALL" = "all" ]]; then
  sed -i "s/picture-options=.*/picture-options='wallpaper'/" "$wallpapers_module_dir/zz2-bluebuild-wallpapers.gschema.override"
fi

# Overwrite default "zoom" scaling value if user supplied their own options with scaling per-wallpaper in gschema override
# Write "none" scaling value
for value in "${DEFAULT_WALLPAPER[@]}"; do
    for match in "${SCALING_NONE[@]}"; do
        if [[ "$value" == "$match" ]]; then
            sed -i "s/picture-options=.*/picture-options='none'/" "$wallpapers_module_dir/zz2-bluebuild-wallpapers.gschema.override"
        fi
    done
done
for value in "${DEFAULT_WALLPAPER_LIGHT_DARK[@]}"; do
    for match in "${SCALING_NONE[@]}"; do
        if [[ "$value" == "$match" ]]; then
            sed -i "s/picture-options=.*/picture-options='none'/" "$wallpapers_module_dir/zz2-bluebuild-wallpapers.gschema.override"
        fi
    done
done
# Write "scaled" scaling value
for value in "${DEFAULT_WALLPAPER[@]}"; do
    for match in "${SCALING_SCALED[@]}"; do
        if [[ "$value" == "$match" ]]; then
            sed -i "s/picture-options=.*/picture-options='scaled'/" "$wallpapers_module_dir/zz2-bluebuild-wallpapers.gschema.override"
        fi
    done
done
for value in "${DEFAULT_WALLPAPER_LIGHT_DARK[@]}"; do
    for match in "${SCALING_SCALED[@]}"; do
        if [[ "$value" == "$match" ]]; then
            sed -i "s/picture-options=.*/picture-options='scaled'/" "$wallpapers_module_dir/zz2-bluebuild-wallpapers.gschema.override"
        fi
    done
done
# Write "stretched" scaling value
for value in "${DEFAULT_WALLPAPER[@]}"; do
    for match in "${SCALING_STRETCHED[@]}"; do
        if [[ "$value" == "$match" ]]; then
            sed -i "s/picture-options=.*/picture-options='stretched'/" "$wallpapers_module_dir/zz2-bluebuild-wallpapers.gschema.override"
        fi
    done
done
for value in "${DEFAULT_WALLPAPER_LIGHT_DARK[@]}"; do
    for match in "${SCALING_STRETCHED[@]}"; do
        if [[ "$value" == "$match" ]]; then
            sed -i "s/picture-options=.*/picture-options='stretched'/" "$wallpapers_module_dir/zz2-bluebuild-wallpapers.gschema.override"
        fi
    done
done
# Write "zoom" scaling value
for value in "${DEFAULT_WALLPAPER[@]}"; do
    for match in "${SCALING_ZOOM[@]}"; do
        if [[ "$value" == "$match" ]]; then
            sed -i "s/picture-options=.*/picture-options='zoom'/" "$wallpapers_module_dir/zz2-bluebuild-wallpapers.gschema.override"
        fi
    done
done
for value in "${DEFAULT_WALLPAPER_LIGHT_DARK[@]}"; do
    for match in "${SCALING_ZOOM[@]}"; do
        if [[ "$value" == "$match" ]]; then
            sed -i "s/picture-options=.*/picture-options='zoom'/" "$wallpapers_module_dir/zz2-bluebuild-wallpapers.gschema.override"
        fi
    done
done
# Write "centered" scaling value
for value in "${DEFAULT_WALLPAPER[@]}"; do
    for match in "${SCALING_CENTERED[@]}"; do
        if [[ "$value" == "$match" ]]; then
            sed -i "s/picture-options=.*/picture-options='centered'/" "$wallpapers_module_dir/zz2-bluebuild-wallpapers.gschema.override"
        fi
    done
done
for value in "${DEFAULT_WALLPAPER_LIGHT_DARK[@]}"; do
    for match in "${SCALING_CENTERED[@]}"; do
        if [[ "$value" == "$match" ]]; then
            sed -i "s/picture-options=.*/picture-options='centered'/" "$wallpapers_module_dir/zz2-bluebuild-wallpapers.gschema.override"
        fi
    done
done
# Write "spanned" scaling value
for value in "${DEFAULT_WALLPAPER[@]}"; do
    for match in "${SCALING_SPANNED[@]}"; do
        if [[ "$value" == "$match" ]]; then
            sed -i "s/picture-options=.*/picture-options='spanned'/" "$wallpapers_module_dir/zz2-bluebuild-wallpapers.gschema.override"
        fi
    done
done
for value in "${DEFAULT_WALLPAPER_LIGHT_DARK[@]}"; do
    for match in "${SCALING_SPANNED[@]}"; do
        if [[ "$value" == "$match" ]]; then
            sed -i "s/picture-options=.*/picture-options='spanned'/" "$wallpapers_module_dir/zz2-bluebuild-wallpapers.gschema.override"
        fi
    done
done
# Write "wallpaper" scaling value
for value in "${DEFAULT_WALLPAPER[@]}"; do
    for match in "${SCALING_WALLPAPER[@]}"; do
        if [[ "$value" == "$match" ]]; then
            printf  "picture-options='wallpaper'" >> "$wallpapers_module_dir"/zz2-bluebuild-wallpapers.gschema.override
        fi
    done
done
for value in "${DEFAULT_WALLPAPER_LIGHT_DARK[@]}"; do
    for match in "${SCALING_WALLPAPER[@]}"; do
        if [[ "$value" == "$match" ]]; then
            printf  "picture-options='wallpaper'" >> "$wallpapers_module_dir"/zz2-bluebuild-wallpapers.gschema.override
        fi
    done
done

echo "Copying gschema override to system & building it to include wallpaper defaults"
  cp "$wallpapers_module_dir"/zz2-bluebuild-wallpapers.gschema.override /usr/share/glib-2.0/schemas
  glib-compile-schemas --strict /usr/share/glib-2.0/schemas
  
echo "Wallpapers module installed successfully!"  
