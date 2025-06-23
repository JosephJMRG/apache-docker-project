#!/bin/bash

# Limpiar reglas existentes
iptables -F DOCKER-USER

# Permitir tráfico HTTP/HTTPS hacia DMZ
iptables -A DOCKER-USER -p tcp --dport 80 -j ACCEPT
iptables -A DOCKER-USER -p tcp --dport 443 -j ACCEPT

# Bloquear comunicación directa entre atacante y LAN
iptables -A DOCKER-USER -s 10.0.0.0/24 -d 192.168.1.0/24 -j DROP

# Logging de conexiones sospechosas
iptables -A DOCKER-USER -j LOG --log-prefix "DOCKER-FIREWALL: "

# Hacer reglas persistentes
/sbin/iptables-save > /etc/iptables/rules.v4
