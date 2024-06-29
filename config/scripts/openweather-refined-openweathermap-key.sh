#!/usr/bin/env bash

# Tell build process to exit if there are any errors.
set -euo pipefail

# Use custom OpenWeatherMap API key to solve "too many users" issue, which makes weather finally working
sed -i 's/b4d6a638dd4af5e668ccd8574fd90cec/d590dd084a24e33ee2198033e927543e/g' /usr/share/gnome-shell/extensions/openweather-extension@penguin-teal.github.io/getweather.js
