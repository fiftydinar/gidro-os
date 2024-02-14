#!/usr/bin/env bash

set -euo pipefail

############################### VARIABLES ###################################

MODULE_DIRECTORY="${MODULE_DIRECTORY:-"/tmp/modules"}"
wallpapers_module_dir="$MODULE_DIRECTORY"/wallpapers
wallpaper_include_location="/tmp/config/wallpapers"
wallpaper_light_dark="$wallpaper_include_location"/bluebuild-gnome-light-dark
wallpaper_destination="/usr/share/backgrounds/bluebuild"
wallpaper_gnome_xml="/usr/share/gnome-background-properties"

# Wallpaper variables

get_yaml_array DEFAULT_WALLPAPER '.default.wallpaper[]' "$1"
# If file-name has whitespace, convert it to _ character.
readarray -t DEFAULT_WALLPAPER < <(printf '%s\n' "${DEFAULT_WALLPAPER[*]}" | tr ' ' '_')
get_yaml_array DEFAULT_WALLPAPER_LIGHT_DARK '.default.wallpaper-light-dark[]' "$1"
# If file-name has whitespace, convert it to _ character.
readarray -t DEFAULT_WALLPAPER_LIGHT_DARK < <(printf '%s\n' "${DEFAULT_WALLPAPER_LIGHT_DARK[*]}" | tr ' ' '_')
# Separate default light & dark wallpaper entry (without need to make another yaml array). It must contain "-bb-light" &/or "-bb-dark" word in filename.
readarray -t DEFAULT_WALLPAPER_LIGHT < <(printf '%s\n' "${DEFAULT_WALLPAPER_LIGHT_DARK[*]}" | awk -F '_\\+_' '{print $1}')
readarray -t DEFAULT_WALLPAPER_DARK < <(printf '%s\n' "${DEFAULT_WALLPAPER_LIGHT_DARK[*]}" | awk -F '_\\+_' '{print $NF}')
# Separate included light/dark wallpapers list from the default wallpapers. Also don't include ./ prefix in files & include filenames only.
readarray -t WALLPAPER_LIGHT_DARK < <(find "$wallpaper_light_dark" -type f ! \( "${DEFAULT_WALLPAPER_LIGHT[*]/#/-name }" "${DEFAULT_WALLPAPER_DARK[*]/#/-o -name }" \) -printf "%f\n")
# Separate light & dark wallpaper entry. It must contain "-bb-light" &/or "-bb-dark" word in filename.
readarray -t WALLPAPER_LIGHT < <(printf '%s\n' "${WALLPAPER_LIGHT_DARK[@]}" | awk '/-bb-light/')
readarray -t WALLPAPER_DARK < <(printf '%s\n' "${WALLPAPER_LIGHT_DARK[@]}" | awk '/-bb-dark/')
# Separate included wallpapers list from the default wallpapers. Also don't include ./ prefix in files & include filenames only. Exclude directory for light/dark wallpapers inclusion.
readarray -t WALLPAPER < <(find "$wallpaper_include_location" -type d -not -path "$wallpaper_light_dark" -type f "${DEFAULT_WALLPAPER[*]/#/-not -name }" -printf "%f\n")

# Scaling variables

# Scaling (use special variables for all & for specific wallpapers)
SCALING_NONE_ALL=$(cat "$1" | yq '.scaling.none')
SCALING_SCALED_ALL=$(cat "$1" | yq '.scaling.scaled')
SCALING_STRETCHED_ALL=$(cat "$1" | yq '.scaling.stretched')
SCALING_ZOOM_ALL=$(cat "$1" | yq '.scaling.zoom')
SCALING_CENTERED_ALL=$(cat "$1" | yq '.scaling.centered')
SCALING_SPANNED_ALL=$(cat "$1" | yq '.scaling.spanned')
SCALING_WALLPAPER_ALL=$(cat "$1" | yq '.scaling.wallpaper')
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
scaling_options=("none" "scaled" "stretched" "zoom" "centered" "spanned" "wallpaper")

############################### INSTALLATION PROCESS ###################################

echo "Installing wallpapers module"

# Copy wallpapers when they are present & fail if they are not
if [ -d "$wallpaper_include_location" ]; then
  if [[ $(find "$wallpaper_include_location") ]]; then
    echo "Copying wallpapers into system backgrounds directory"
    # If file-names & wallpaper folders have whitespaces, convert them to _ character.
    find "$wallpaper_include_location" -depth -name "* *" -execdir bash -c 'mv "$0" "${0// /_}"' {} \;
    cp -r "$wallpaper_include_location"/* "$wallpaper_destination"
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

############################### GNOME-SPECIFIC CODE ###################################
####################################################################################
############################### WALLPAPER XML ###################################

# Write XMLs to make included wallpapers appear in Gnome settings.
# Remove filename-dark field, as it's not needed for classic wallpapers
# Set name of the wallpaper to BlueBuild-nameofthewallpaper.jpg.xml
# Also write global scaling option

for wallpaper in "${WALLPAPER[@]}"; do
  for scaling_option in "${scaling_options[@]}"; do
    cp "$wallpapers_module_dir"/bluebuild.xml "$wallpapers_module_dir"/bluebuild-template.xml
    yq -i '.wallpapers.wallpaper.name = "BlueBuild-'"$wallpaper"'"' "$wallpapers_module_dir"/bluebuild-template.xml
    yq -i ".wallpapers.wallpaper.filename = $wallpaper_destination/$wallpaper" "$wallpapers_module_dir"/bluebuild-template.xml
    yq 'del(.wallpapers.wallpaper.filename-dark)' "$wallpapers_module_dir"/bluebuild-template.xml -i
    scaling_variable="SCALING_${scaling_option^^}_ALL"
    if [[ "${!scaling_variable}" = "all" ]] && [[ ${#scaling_variable[@]} -gt 0 ]]; then
      yq -i '.wallpapers.wallpaper.options = "'"$scaling_option"'"' "$wallpapers_module_dir"/bluebuild-template.xml
    fi
    cp "$wallpapers_module_dir"/bluebuild-template.xml "$wallpaper_gnome_xml"/bluebuild-"$wallpaper".xml
    rm "$wallpapers_module_dir"/bluebuild-template.xml
  done
done

# Write XMLs to make included light/dark wallpapers appear in Gnome settings.
# Set name of the wallpaper to BlueBuild-nameofthewallpaper.jpg.xml
# Also write global scaling option
for wallpaper_light in "${WALLPAPER_LIGHT[@]}"; do
  for wallpaper_dark in "${WALLPAPER_DARK[@]}"; do
    for scaling_option in "${scaling_options[@]}"; do
      cp "$wallpapers_module_dir"/bluebuild.xml "$wallpapers_module_dir"/bluebuild-template.xml    
      yq -i '.wallpapers.wallpaper.name = "BlueBuild-'"$wallpaper_light"_+_"$wallpaper_dark"'"' "$wallpapers_module_dir"/bluebuild-template.xml
      yq -i ".wallpapers.wallpaper.filename = $wallpaper_destination/$wallpaper_light" "$wallpapers_module_dir"/bluebuild-template.xml
      yq -i ".wallpapers.wallpaper.filename-dark = $wallpaper_destination/$wallpaper_dark" "$wallpapers_module_dir"/bluebuild-template.xml
      scaling_variable="SCALING_${scaling_option^^}_ALL"
      if [[ "${!scaling_variable}" = "all" ]] && [[ ${#scaling_variable[@]} -gt 0 ]]; then
        yq -i '.wallpapers.wallpaper.options = "'"$scaling_option"'"' "$wallpapers_module_dir"/bluebuild-template.xml
      fi
      cp "$wallpapers_module_dir"/bluebuild-template.xml "$wallpaper_gnome_xml"/bluebuild-"$wallpaper_light"_+_"$wallpaper_dark".xml
      rm "$wallpapers_module_dir"/bluebuild-template.xml
    done
  done
done

# Write XMLs to make default wallpaper appear in Gnome settings.
# Remove filename-dark field, as it's not needed for the default wallpaper
# Set name of the XML to BlueBuild-nameofthewallpaper.jpg.xml
# Also write global scaling option
for default_wallpaper in "${DEFAULT_WALLPAPER[*]}"; do
  for scaling_option in "${scaling_options[@]}"; do
    cp "$wallpapers_module_dir"/bluebuild.xml "$wallpapers_module_dir"/bluebuild-template.xml  
    yq -i '.wallpapers.wallpaper.name = "BlueBuild-'"$default_wallpaper"'"' "$wallpapers_module_dir"/bluebuild-template.xml
    yq -i ".wallpapers.wallpaper.filename = $wallpaper_destination/$default_wallpaper" "$wallpapers_module_dir"/bluebuild-template.xml
    yq 'del(.wallpapers.wallpaper.filename-dark)' "$wallpapers_module_dir"/bluebuild-template.xml -i
    scaling_variable="SCALING_${scaling_option^^}_ALL"
    if [[ "${!scaling_variable}" = "all" ]] && [[ ${#scaling_variable[@]} -gt 0 ]]; then
      yq -i '.wallpapers.wallpaper.options = "'"$scaling_option"'"' "$wallpapers_module_dir"/bluebuild-template.xml
    fi
    cp "$wallpapers_module_dir"/bluebuild-template.xml "$wallpaper_gnome_xml"/bluebuild-"$default_wallpaper".xml
    rm "$wallpapers_module_dir"/bluebuild-template.xml    
  done
done

# Write XMLs to make default light/dark wallpaper appear in Gnome settings.
# Set name of the wallpaper to BlueBuild-nameofthewallpaper.jpg.xml
# Also write global scaling option
for default_wallpaper_light in "${DEFAULT_WALLPAPER_LIGHT[*]}"; do
  for default_wallpaper_dark in "${DEFAULT_WALLPAPER_DARK[*]}"; do
    for scaling_option in "${scaling_options[@]}"; do
      cp "$wallpapers_module_dir"/bluebuild.xml "$wallpapers_module_dir"/bluebuild-template.xml      
      yq -i '.wallpapers.wallpaper.name = "BlueBuild-'"$default_wallpaper_light"_+_"$default_wallpaper_dark"'"' "$wallpapers_module_dir"/bluebuild-template.xml
      yq -i ".wallpapers.wallpaper.filename = $wallpaper_destination/$default_wallpaper_light" "$wallpapers_module_dir"/bluebuild-template.xml
      yq -i ".wallpapers.wallpaper.filename-dark = $wallpaper_destination/$default_wallpaper_dark" "$wallpapers_module_dir"/bluebuild-template.xml
      scaling_variable="SCALING_${scaling_option^^}_ALL"
      if [[ "${!scaling_variable}" = "all" ]] && [[ ${#scaling_variable[@]} -gt 0 ]]; then
        yq -i '.wallpapers.wallpaper.options = "'"$scaling_option"'"' "$wallpapers_module_dir"/bluebuild-template.xml
      fi
      cp "$wallpapers_module_dir"/bluebuild-template.xml "$wallpaper_gnome_xml"/bluebuild-"$default_wallpaper_light"_+_"$default_wallpaper_dark".xml
      rm "$wallpapers_module_dir"/bluebuild-template.xml
    done
  done
done

# Write per-wallpaper scaling settings
for scaling_option in "${scaling_options[@]}"; do
  scaling_variable="SCALING_${scaling_option^^}"
    if [[ ${#scaling_variable[@]} -gt 0 ]]; then
      yq -i '.wallpapers.wallpaper.options = "'"$scaling_option"'"' "$wallpaper_gnome_xml"/bluebuild-"$scaling_variable".xml
      echo "Writing custom per-wallpaper scaling value to XML file"
    fi
done

############################### GSCHEMA OVERRIDE ###################################

# Write default wallpaper to gschema override
if [[ ${#DEFAULT_WALLPAPER[@]} == 1 ]]; then
  printf "%s" "Setting ${DEFAULT_WALLPAPER[*]} as the default wallpaper in gschema override"
  printf '..%s..' "picture-uri='file://$wallpaper_destination/${DEFAULT_WALLPAPER[*]}'" >> "$wallpapers_module_dir"/zz2-bluebuild-wallpapers.gschema.override
elif [[ ${#DEFAULT_WALLPAPER[@]} -gt 1 ]]; then
  echo "Module failed because you included more than 1 wallpaper to be set as default, which is not allowed"
  exit 1
fi

# Write default light/dark theme wallpaper to gschema override
if [[ ${#DEFAULT_WALLPAPER_LIGHT_DARK[@]} == 1 ]]; then
  printf "%s" "Setting ${DEFAULT_WALLPAPER_LIGHT_DARK[*]} as the default light/dark wallpaper in gschema override"
  printf '..%s..' "picture-uri='file://$wallpaper_destination/${DEFAULT_WALLPAPER_LIGHT[*]}'" >> "$wallpapers_module_dir"/zz2-bluebuild-wallpapers.gschema.override
  printf '..%s..' "picture-uri-dark='file://$wallpaper_destination/${DEFAULT_WALLPAPER_DARK[*]}'" >> "$wallpapers_module_dir"/zz2-bluebuild-wallpapers.gschema.override 
elif [[ ${#DEFAULT_WALLPAPER_LIGHT_DARK[@]} -gt 1 ]]; then
  echo "Module failed because you included more than 1 light & dark wallpaper to be set as default for light/dark theme, which is not allowed"
  exit 1
fi

# Overwrite default "zoom" scaling value if user supplied their own option with global scaling in gschema override
for scaling_option in "${scaling_options[@]}"; do
  scaling_variable="SCALING_${scaling_option^^}_ALL"
  if [[ "${!scaling_variable}" = "all" ]] && [[ ${#scaling_variable[@]} -gt 0 ]]; then
    echo "Writing custom global scaling value to gschema override"
    sed -i "s/picture-options=.*/picture-options='$scaling_option'/" "$wallpapers_module_dir/zz2-bluebuild-wallpapers.gschema.override"
  fi
done

# Overwrite default "zoom" scaling value if user supplied their own options with scaling per-wallpaper in gschema override
for scaling_option in "${scaling_options[@]}"; do
    for value in "${DEFAULT_WALLPAPER[*]}" "${DEFAULT_WALLPAPER_LIGHT_DARK[*]}"; do
        scaling_variable="SCALING_${scaling_option^^}"
        if [[ "${!scaling_variable}" == *"$value"* ]] && [[ ${#scaling_variable[@]} -gt 0 ]]; then
            echo "Writing custom per-wallpaper scaling value to gschema override"
            sed -i "s/picture-options=.*/picture-options='$scaling_option'/" "$wallpapers_module_dir/zz2-bluebuild-wallpapers.gschema.override"
        fi
    done
done

echo "Copying gschema override to system & building it to include wallpaper defaults"
cp "$wallpapers_module_dir"/zz2-bluebuild-wallpapers.gschema.override /usr/share/glib-2.0/schemas
glib-compile-schemas --strict /usr/share/glib-2.0/schemas
  
echo "Wallpapers module installed successfully!"  
