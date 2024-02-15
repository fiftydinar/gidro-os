#!/usr/bin/env bash

set -euo pipefail

############################### VARIABLE FUNCTIONS ###################################
sanitize_file_names() {
    # If file-name has whitespace, convert it to _ character.
    local -n files_array=$1
    files_array=("${files_array[@]// /_}")
}

extract_default_wallpaper_light() {
    # Extract default light theme wallpaper from light/dark recipe input.
    # It always assumes that light wallpaper is set as 1st in light.jpg + dark.jpg recipe format.
    readarray -t "$1" < <(printf '%s\n' "$DEFAULT_WALLPAPER_LIGHT_DARK" | awk -F '_\\+_' '{print $1}')
}

extract_default_wallpaper_dark() {
    # Extract default dark theme wallpaper from light/dark recipe input.
    # It always assumes that dark wallpaper is set as 2nd in light.jpg + dark.jpg recipe format.
    readarray -t "$1" < <(printf '%s\n' "$DEFAULT_WALLPAPER_LIGHT_DARK" | awk -F '_\\+_' '{print $NF}')
}

extract_wallpaper_light_dark() {
    # Extract included light/dark wallpapers from default light/dark wallpapers which are inputted into recipe file.
    # Exclude default light/dark wallpaper from the list.
    # Also don't include ./ prefix in files & include filenames only for `find` command.    
    readarray -t "$1" < <(find "$wallpaper_light_dark_dir" -type f ! \( -name "$DEFAULT_WALLPAPER_LIGHT" -o -name "$DEFAULT_WALLPAPER_DARK" \) -printf "%f\n")
}

extract_wallpaper_light() {
    # Extract included light wallpaper from default light/dark wallpapers which are inputted into recipe file.
    # Light wallpaper must contain "-bb-light" word in filename.
    readarray -t "$1" < <(printf '%s\n' "${WALLPAPER_LIGHT_DARK[@]}" | awk '/-bb-light/')
}

extract_wallpaper_dark() {
    # Extract included dark wallpaper from default light/dark wallpapers which are inputted into recipe file.
    # Dark wallpaper must contain "-bb-dark" word in filename.
    readarray -t "$1" < <(printf '%s\n' "${WALLPAPER_LIGHT_DARK[@]}" | awk '/-bb-dark/')
}

extract_wallpaper() {
    # Extract regular included wallpaper.
    # Exclude directory for light/dark wallpapers inclusion.
    # Exclude default wallpaper from the list.
    # Also don't include ./ prefix in files & include filenames only for `find` command.
    readarray -t "$1" < <(find "$wallpaper_include_dir" -type d -not -path "$wallpaper_light_dark" -type f -not -name "$DEFAULT_WALLPAPER" -printf "%f\n")
}

############################### VARIABLES ###################################

# File & folder location variables

wallpapers_module_dir="$MODULE_DIRECTORY"/wallpapers
wallpaper_include_dir="$CONFIG_DIRECTORY"/wallpapers
wallpaper_destination="/usr/share/backgrounds/bluebuild"
# Gnome file & folder locations
wallpaper_light_dark_dir="$wallpaper_include_dir"/bluebuild-gnome-light-dark
xml_default_template="$wallpapers_module_dir"/bluebuild.xml
xml_modified_template="$wallpapers_module_dir"/bluebuild-template.xml
xml_destination="/usr/share/gnome-background-properties"
gschema_override="$wallpapers_module_dir"/zz2-bluebuild-wallpapers.gschema.override
gschema_override_destination="/usr/share/glib-2.0/schemas"

# Wallpaper variables (for Gnome)

# Default wallpapers
get_yaml_array DEFAULT_WALLPAPER '.default.wallpaper[]' "$1"
sanitize_file_names DEFAULT_WALLPAPER
#
get_yaml_array DEFAULT_WALLPAPER_LIGHT_DARK '.default.wallpaper-light-dark[]' "$1"
sanitize_file_names DEFAULT_WALLPAPER_LIGHT_DARK
#
extract_default_wallpaper_light DEFAULT_WALLPAPER_LIGHT
extract_default_wallpaper_dark DEFAULT_WALLPAPER_DARK
# Included wallpapers
extract_wallpaper_light_dark WALLPAPER_LIGHT_DARK
sanitize_file_names WALLPAPER_LIGHT_DARK
#
extract_wallpaper_light WALLPAPER_LIGHT
extract_wallpaper_dark WALLPAPER_DARK
#
extract_wallpaper WALLPAPER
sanitize_file_names WALLPAPER

# Scaling variables
scaling_options=("none" "scaled" "stretched" "zoom" "centered" "spanned" "wallpaper")

# Automatically generate global & per-wallpaper scaling variable based on available options above as
# SCALING_$option_ALL
# SCALING_$option_WALLPAPER
for option in "${scaling_options[@]}"; do
    variable_name="SCALING_${option^^}_ALL"
    variable_value=$(echo "$1" | yq -I=0 ".scaling.$option")
    eval "$variable_name=\$variable_value"
    
    array_variable_name="SCALING_${option^^}_WALLPAPER"
    array_variable_value=$(echo "$1" | yq -I=0 ".scaling.$option[]")
    sanitize_file_names "$array_variable_value"
    eval "$array_variable_name=\$array_variable_value"
done

############################### INSTALLATION CHECKS ###################################

# Fail if no wallpapers are detected in `config/wallpapers` directory.
if [ ! -d "$wallpaper_include_dir" ] || [[ ! $(find "$wallpaper_include_dir" -type f) ]]; then
  echo "Module failed because wallpapers aren't included in config/wallpapers directory"
  exit 1
fi

# Fail if included light+dark wallpaper does not contain `-bb-light` or `-bb-dark` suffix.
if [[ ${#WALLPAPER_LIGHT_DARK[@]} -gt 0 ]]; then
  for wallpaper in "${WALLPAPER_LIGHT_DARK[@]}"; do
    if [[ ! $wallpaper =~ "-bb-light" ]]; then
      echo "Module failed because included light wallpaper $wallpaper does not contain '-bb-light' suffix"
      exit 1
    fi
  done
  for wallpaper in "${WALLPAPER_DARK[@]}"; do
    if [[ ! $wallpaper =~ "-bb-dark" ]]; then
      echo "Module failed because included dark wallpaper $wallpaper does not contain '-bb-dark' suffix"
      exit 1
    fi
  done
fi

# Fail if more than 1 default wallpaper is included.
if [[ ${#DEFAULT_WALLPAPER[@]} -gt 1 ]]; then
  echo "Module failed because you included more than 1 regular wallpaper to be set as default, which is not allowed"
  exit 1
fi
if [[ ${#DEFAULT_WALLPAPER_LIGHT_DARK[@]} -gt 1 ]]; then
  echo "Module failed because you included more than 1 light & dark wallpaper to be set as default for light/dark theme, which is not allowed"
  exit 1
fi

# Fail if default light+dark wallpaper does not contain '-bb-light' or '-bb-dark' suffix.
if [[ ${#DEFAULT_WALLPAPER_LIGHT_DARK[@]} == 1 ]]; then
  if [[ ! "$DEFAULT_WALLPAPER_LIGHT" =~ "-bb-light" ]]; then
    echo "Module failed because default light wallpaper does not contain '-bb-light' suffix"
    exit 1
  fi
  if [[ ! "$DEFAULT_WALLPAPER_DARK" =~ "-bb-dark" ]]; then
    echo "Module failed because default dark wallpaper does not contain '-bb-dark' suffix"
    exit 1
  fi
fi

# Stop the script after copying wallpapers if non-Gnome DE is detected
function gnome_section ()
gnome_detection=$(find /usr/bin -type f -name "gnome-session" -printf "%f\n")
if [[ ! $gnome_detection == gnome-session ]]; then
  echo "Wallpapers module installed successfully!"
  exit 0
fi

############################### INSTALLATION PROCESS ###################################

echo "Installing wallpapers module"

echo "Copying wallpapers into system backgrounds directory"
# If file-names & wallpaper folders have whitespaces, convert them to _ character.
find "$wallpaper_include_dir" -depth -name "* *" -execdir bash -c 'mv "$0" "${0// /_}"' {} \;
cp -r "$wallpaper_include_dir"/* "$wallpaper_destination"

############################### GNOME-SPECIFIC CODE ###################################
####################################################################################
############################### WALLPAPER XML ###################################

gnome_section

# Included wallpapers XML section
# Write XMLs to make included wallpapers appear in Gnome settings.
# Remove filename-dark field, as it's not needed for classic wallpapers
# Set name of the XML to bluebuild-nameofthewallpaper.jpg.xml
if [[ ${#WALLPAPER[@]} -gt 0 ]]; then
echo "Writing XMLs for included wallpapers to appear in Gnome settings"
  for wallpaper in "${WALLPAPER[@]}"; do
      cp "$xml_default_template" "$xml_modified_template"
      yq -i '.wallpapers.wallpaper.name = "BlueBuild-'"$wallpaper"'"' "$xml_modified_template"
      yq -i ".wallpapers.wallpaper.filename = $wallpaper_destination/$wallpaper" "$xml_modified_template"
      yq 'del(.wallpapers.wallpaper.filename-dark)' "$xml_modified_template" -i
      cp "$xml_modified_template" "$wallpaper_gnome_xml"/bluebuild-"$wallpaper".xml
      rm "$xml_modified_template"
  done
fi

# Included light+dark wallpapers XML section
# Write XMLs to make included light+dark wallpapers appear in Gnome settings.
# Set name of the XML to bluebuild-wallpaper-bb-light.jpg_+_bluebuild-wallpaper-bb-dark.jpg.xml
if [[ ${#WALLPAPER_LIGHT_DARK[@]} -gt 0 ]]; then
echo "Writing XMLs for included light+dark wallpapers to appear in Gnome settings"
  for wallpaper_light in "${WALLPAPER_LIGHT[@]}"; do
    for wallpaper_dark in "${WALLPAPER_DARK[@]}"; do
        cp "$xml_default_template" "$xml_modified_template"
        yq -i '.wallpapers.wallpaper.name = "BlueBuild-'"$wallpaper_light"_+_"$wallpaper_dark"'"' "$xml_modified_template"
        yq -i ".wallpapers.wallpaper.filename = $wallpaper_destination/$wallpaper_light" "$xml_modified_template"
        yq -i ".wallpapers.wallpaper.filename-dark = $wallpaper_destination/$wallpaper_dark" "$xml_modified_template"
        cp "$xml_modified_template" "$wallpaper_gnome_xml"/bluebuild-"$wallpaper_light"_+_"$wallpaper_dark".xml
        rm "$xml_modified_template"
    done
  done
fi

# Default wallpaper XML section
# Write XML to make default wallpaper appear in Gnome settings.
# Remove filename-dark field, as it's not needed for the default wallpaper
# Set name of the XML to bluebuild-nameofthewallpaper.jpg.xml
if [[ ${#DEFAULT_WALLPAPER[@]} == 1 ]]; then
echo "Writing XML for default wallpaper to appear in Gnome settings"
  for default_wallpaper in "${DEFAULT_WALLPAPER[@]}"; do
      cp "$xml_default_template" "$xml_modified_template"
      yq -i '.wallpapers.wallpaper.name = "BlueBuild-'"$default_wallpaper"'"' "$xml_modified_template"
      yq -i ".wallpapers.wallpaper.filename = $wallpaper_destination/$default_wallpaper" "$xml_modified_template"
      yq 'del(.wallpapers.wallpaper.filename-dark)' "$xml_modified_template" -i
      cp "$xml_modified_template" "$wallpaper_gnome_xml"/bluebuild-"$default_wallpaper".xml
      rm "$xml_modified_template"    
  done
fi

# Default light+dark wallpaper XML section
# Write XMLs to make default light+dark wallpaper appear in Gnome settings.
# Set name of the XML to bluebuild-wallpaper-bb-light.jpg_+_bluebuild-wallpaper-bb-dark.jpg.xml
if [[ ${#DEFAULT_WALLPAPER_LIGHT_DARK[@]} == 1 ]]; then
echo "Writing XML for default light+dark wallpaper to appear in Gnome settings"
  for default_wallpaper_light in "${DEFAULT_WALLPAPER_LIGHT[@]}"; do
    for default_wallpaper_dark in "${DEFAULT_WALLPAPER_DARK[@]}"; do
        cp "$xml_default_template" "$xml_modified_template"
        yq -i '.wallpapers.wallpaper.name = "BlueBuild-'"$default_wallpaper_light"_+_"$default_wallpaper_dark"'"' "$xml_modified_template"
        yq -i ".wallpapers.wallpaper.filename = $wallpaper_destination/$default_wallpaper_light" "$xml_modified_template"
        yq -i ".wallpapers.wallpaper.filename-dark = $wallpaper_destination/$default_wallpaper_dark" "$xml_modified_template"
        cp "$xml_modified_template" "$wallpaper_gnome_xml"/bluebuild-"$default_wallpaper_light"_+_"$default_wallpaper_dark".xml
        rm "$xml_modified_template"
    done
  done
fi

# Write global scaling settings to XML
for scaling_option in "${scaling_options[@]}"; do
  scaling_variable="SCALING_${scaling_option^^}_ALL"
  if [[ "$scaling_variable" == "all" ]]; then
    echo "Writing global scaling value to XML file(s)"
    for xml_included in "${WALLPAPER[@]}"; do
      yq -i '.wallpapers.wallpaper.options = "'"$scaling_option"'"' "$wallpaper_gnome_xml"/bluebuild-"$xml_included".xml
    done
    for xml_light_dark in "${WALLPAPER_LIGHT_DARK[@]}"; do
      yq -i '.wallpapers.wallpaper.options = "'"$scaling_option"'"' "$wallpaper_gnome_xml"/bluebuild-"$xml_light_dark".xml
    done
    for xml_default in "${DEFAULT_WALLPAPER[@]}"; do
      yq -i '.wallpapers.wallpaper.options = "'"$scaling_option"'"' "$wallpaper_gnome_xml"/bluebuild-"$xml_default".xml
    done
    for xml_default_light_dark in "${DEFAULT_WALLPAPER_LIGHT_DARK[@]}"; do
      yq -i '.wallpapers.wallpaper.options = "'"$scaling_option"'"' "$wallpaper_gnome_xml"/bluebuild-"$xml_default_light_dark".xml
    done      
  fi
done

# Write per-wallpaper scaling settings to XML
for scaling_option in "${scaling_options[@]}"; do
  scaling_variable=("SCALING_${scaling_option^^}")
  if [[ ${#scaling_variable[@]} -gt 0 ]]; then
    for scaling_per_wallpaper in ${scaling_variable[@]}; do
        echo "Writing per-wallpaper scaling value to XML file(s)"
        yq -i '.wallpapers.wallpaper.options = "'"$scaling_option"'"' "$wallpaper_gnome_xml"/bluebuild-"$scaling_per_wallpaper".xml
    done
  fi
done

############################### GSCHEMA OVERRIDE ###################################

# Write default wallpaper to gschema override
if [[ ${#DEFAULT_WALLPAPER[@]} == 1 ]]; then
  printf "%s" "Setting $DEFAULT_WALLPAPER as the default wallpaper in gschema override"
  printf '..%s..' "picture-uri='file://$wallpaper_destination/$DEFAULT_WALLPAPER'" >> "$gschema_override"
fi

# Write default light/dark theme wallpaper to gschema override
if [[ ${#DEFAULT_WALLPAPER_LIGHT_DARK[@]} == 1 ]]; then
  printf "%s" "Setting $DEFAULT_WALLPAPER_LIGHT_DARK as the default light+dark wallpaper in gschema override"
  printf '..%s..' "picture-uri='file://$wallpaper_destination/$DEFAULT_WALLPAPER_LIGHT'" >> "$gschema_override"
  printf '..%s..' "picture-uri-dark='file://$wallpaper_destination/$DEFAULT_WALLPAPER_DARK'" >> "$gschema_override"
fi

# Overwrite default "zoom" scaling value if user supplied their own option with global scaling in gschema override
for scaling_option in "${scaling_options[@]}"; do
  scaling_variable="SCALING_${scaling_option^^}_ALL"
  if [[ "$scaling_variable" = "all" ]]; then
    echo "Writing global scaling value to gschema override"
    sed -i "s/picture-options=.*/picture-options='$scaling_option'/" "$gschema_override"
  fi
done

# Overwrite default "zoom" scaling value if user supplied their own options with scaling per-wallpaper in gschema override
for scaling_option in "${scaling_options[@]}"; do
    for value in "${DEFAULT_WALLPAPER[@]}"; do
        for light_dark_value in "${DEFAULT_WALLPAPER_LIGHT_DARK[@]}"; do
            scaling_variable="SCALING_${scaling_option^^}"
            if [[ ${#scaling_variable[@]} -gt 0 ]]; then
              if [[ "$scaling_variable" == *"$value"* ]] || [[ "$scaling_variable" == *"$light_dark_value"* ]]; then
                  echo "Writing per-wallpaper scaling value to gschema override"
                  sed -i "s/picture-options=.*/picture-options='$scaling_option'/" "$gschema_override"
              fi
            fi  
        done    
    done
done

if [[ ${#DEFAULT_WALLPAPER[@]} == 1 ]] || [[ ${#DEFAULT_WALLPAPER_LIGHT_DARK[@]} == 1 ]]; then
  echo "Copying gschema override to system & building it to include wallpaper defaults"
  cp "$wallpapers_module_dir"/zz2-bluebuild-wallpapers.gschema.override /usr/share/glib-2.0/schemas
  glib-compile-schemas --strict /usr/share/glib-2.0/schemas
fi

echo "Wallpapers module installed successfully!"  
