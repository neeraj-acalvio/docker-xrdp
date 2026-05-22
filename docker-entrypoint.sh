#!/bin/bash
set -euo pipefail

# Generate TLS keys on first start (required before xrdp accepts connections)
if [[ ! -f /etc/xrdp/rsakeys.ini ]]; then
    /usr/sbin/xrdp-keygen xrdp auto
fi

# Session manager must be running before xrdp accepts RDP connections
if ! pgrep -x xrdp-sesman >/dev/null 2>&1; then
    /usr/sbin/xrdp-sesman &
fi

# Run xrdp in the foreground so the container stays up
exec /usr/sbin/xrdp -n
