function gnome --description='start gnome-wayland'
  XDG_SESSION_TYPE=wayland dbus-run-session gnome-session
end
