#!/bin/sh
# --- adblocker Section ---
# wait up to 60s for internet connection
TRIES=0
while [ $TRIES -lt 6 ] && ! ping -c 1 -w 3 google.com >/dev/null 2>&1; do # ping google to check internet access
    sleep 10
    TRIES=$((TRIES + 1))
done

# get masterlist
# use >> to append if you want multiple, but one good list is usually better for router RAM
wget -qO- https://raw.githubusercontent.com/StevenBlack/hosts/master/hosts | grep "^0.0.0.0" > /tmp/adhosts.raw

# create dual-stack blocklist (IPv4 and IPv6)
# convert "0.0.0.0 domain.com" into both "0.0.0.0 domain.com" AND ":: domain.com"
awk '{print "0.0.0.0 " $2 "\n:: " $2}' /tmp/adhosts.raw | sort -u > /tmp/adhosts

# remove temporary file
rm /tmp/adhosts.raw

# hard restart DNS service to ensure it uses the new file
stopservice dnsmasq
startservice dnsmasq
