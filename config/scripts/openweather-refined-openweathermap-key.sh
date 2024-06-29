#!/usr/bin/env bash

# Tell build process to exit if there are any errors.
set -euo pipefail

DEFAULT_KEY="b4d6a638dd4af5e668ccd8574fd90cec"
CUSTOM_KEY="d590dd084a24e33ee2198033e927543e"

# Use custom OpenWeatherMap API key to solve "too many users" issue, which makes OpenWeather Refined finally working
sed -i "s/${DEFAULT_KEY}/${CUSTOM_KEY}/g" /usr/share/gnome-shell/extensions/openweather-extension@penguin-teal.github.io/getweather.js
