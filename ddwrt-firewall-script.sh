# MSS clamping (Fixes website timeouts)
ip6tables -t mangle -A POSTROUTING -p tcp --tcp-flags SYN,RST SYN -j TCPMSS --clamp-mss-to-pmtu

# Pinhole template for forwarding (Replace [IPv6] with your actual server global address)
ip6tables -I FORWARD -p tcp -d [YOUR_SERVER_IPV6] --dport 80 -j ACCEPT

# Basic Security
ip6tables -A FORWARD -m state --state ESTABLISHED,RELATED -j ACCEPT
ip6tables -I INPUT -p icmpv6 -j ACCEPT
