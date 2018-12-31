#!/usr/bin/env sh

vpn=$(for fn in /var/run/openvpn/*.pid ; do
  service=$(basename "$fn" .pid)
  status=$(systemctl is-active "openvpn@$service.service")
  case "$status" in
    *'active' ) printf "%s," "$service"
  esac
done | sort | sed 's/,$/\n/')

printf "%s\n" "$vpn"
printf "\n"

