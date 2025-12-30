case "$XDG_DATA_DIRS" in
  *"${XDG_DATA_HOME:-$HOME/.local/share}:"*);;
  *) export XDG_DATA_DIRS="${XDG_DATA_HOME:-$HOME/.local/share}:${XDG_DATA_DIRS}";;
esac
