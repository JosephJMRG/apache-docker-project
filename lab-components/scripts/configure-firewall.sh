#!/bin/bash

# Script para configurar iptables y reglas de firewall
# Proyecto: apache-docker-project
# Autor: JosephJMRG

# Colores para output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m'

echo -e "${BLUE}Configurando reglas de firewall para el laboratorio...${NC}"

# Verificar permisos de root
if [[ $EUID -ne 0 ]]; then
   echo -e "${RED}Este script debe ejecutarse como root${NC}"
   echo -e "${YELLOW}Uso: sudo $0${NC}"
   exit 1
fi

# Función para verificar si una cadena existe
chain_exists() {
    iptables -L "$1" -n >/dev/null 2>&1
}

# Función para crear cadena si no existe
create_chain_if_not_exists() {
    if ! chain_exists "$1"; then
        iptables -N "$1"
        echo -e "${GREEN}✓ Cadena $1 creada${NC}"
    else
        echo -e "${YELLOW}✓ Cadena $1 ya existe${NC}"
    fi
}

# Limpiar reglas existentes del laboratorio
echo -e "${YELLOW}Limpiando reglas existentes...${NC}"
iptables -F DOCKER-USER 2>/dev/null || true
iptables -F PENTEST-DMZ 2>/dev/null || true
iptables -F PENTEST-LAN 2>/dev/null || true
iptables -F PENTEST-ATTACK 2>/dev/null || true

# Crear cadenas personalizadas
echo -e "${YELLOW}Creando cadenas personalizadas...${NC}"
create_chain_if_not_exists "PENTEST-DMZ"
create_chain_if_not_exists "PENTEST-LAN"
create_chain_if_not_exists "PENTEST-ATTACK"

# Configurar logging
echo -e "${YELLOW}Configurando logging...${NC}"

# Reglas para red DMZ (192.168.90.0/24)
echo -e "${BLUE}Configurando reglas para DMZ...${NC}"

# Permitir tráfico HTTP/HTTPS hacia DMZ
iptables -A DOCKER-USER -d 192.168.90.0/24 -p tcp --dport 80 -j ACCEPT
iptables -A DOCKER-USER -d 192.168.90.0/24 -p tcp --dport 443 -j ACCEPT
iptables -A DOCKER-USER -d 192.168.90.0/24 -p tcp --dport 8080 -j ACCEPT
iptables -A DOCKER-USER -d 192.168.90.0/24 -p tcp --dport 3000 -j ACCEPT
iptables -A DOCKER-USER -d 192.168.90.0/24 -p tcp --dport 8081 -j ACCEPT
iptables -A DOCKER-USER -d 192.168.90.0/24 -p tcp --dport 8082 -j ACCEPT

# Permitir SSH al honeypot
iptables -A DOCKER-USER -d 192.168.90.0/24 -p tcp --dport 2222 -j ACCEPT

# Permitir FTP
iptables -A DOCKER-USER -d 192.168.90.0/24 -p tcp --dport 21 -j ACCEPT
iptables -A DOCKER-USER -d 192.168.90.0/24 -p tcp --dport 30000:30009 -j ACCEPT

# Reglas para red LAN (192.168.1.0/24)
echo -e "${BLUE}Configurando reglas para LAN...${NC}"

# Permitir acceso desde DMZ a MySQL en LAN
iptables -A DOCKER-USER -s 192.168.90.0/24 -d 192.168.1.0/24 -p tcp --dport 3306 -j ACCEPT

# Permitir tráfico interno en LAN
iptables -A DOCKER-USER -s 192.168.1.0/24 -d 192.168.1.0/24 -j ACCEPT

# Reglas para red de atacantes (10.0.0.0/24)
echo -e "${BLUE}Configurando reglas para red de atacantes...${NC}"

# Permitir que atacantes accedan a DMZ
iptables -A DOCKER-USER -s 10.0.0.0/24 -d 192.168.90.0/24 -j ACCEPT

# BLOQUEAR acceso directo de atacantes a LAN
iptables -A DOCKER-USER -s 10.0.0.0/24 -d 192.168.1.0/24 -j LOG --log-prefix "PENTEST-BLOCKED-ATTACK: "
iptables -A DOCKER-USER -s 10.0.0.0/24 -d 192.168.1.0/24 -j DROP

# Reglas de logging para análisis
echo -e "${BLUE}Configurando logging avanzado...${NC}"

# Log conexiones a servicios vulnerables
iptables -A DOCKER-USER -d 192.168.90.0/24 -p tcp --dport 80 -j LOG --log-prefix "PENTEST-HTTP: "
iptables -A DOCKER-USER -d 192.168.90.0/24 -p tcp --dport 8080 -j LOG --log-prefix "PENTEST-DVWA: "
iptables -A DOCKER-USER -d 192.168.90.0/24 -p tcp --dport 3000 -j LOG --log-prefix "PENTEST-JUICE: "
iptables -A DOCKER-USER -d 192.168.90.0/24 -p tcp --dport 2222 -j LOG --log-prefix "PENTEST-SSH: "
iptables -A DOCKER-USER -d 192.168.90.0/24 -p tcp --dport 21 -j LOG --log-prefix "PENTEST-FTP: "

# Log intentos de acceso a LAN
iptables -A DOCKER-USER -d 192.168.1.0/24 -j LOG --log-prefix "PENTEST-LAN-ACCESS: "

# Permitir tráfico establecido y relacionado
iptables -A DOCKER-USER -m conntrack --ctstate ESTABLISHED,RELATED -j ACCEPT

# Permitir loopback
iptables -A DOCKER-USER -i lo -j ACCEPT

# Configurar límites de rate limiting
echo -e "${BLUE}Configurando rate limiting...${NC}"

# Limitar conexiones SSH al honeypot
iptables -A DOCKER-USER -d 192.168.90.0/24 -p tcp --dport 2222 -m limit --limit 10/minute --limit-burst 5 -j ACCEPT
iptables -A DOCKER-USER -d 192.168.90.0/24 -p tcp --dport 2222 -j DROP

# Limitar conexiones HTTP para prevenir DDoS
iptables -A DOCKER-USER -d 192.168.90.0/24 -p tcp --dport 80 -m limit --limit 25/minute --limit-burst 100 -j ACCEPT

# Configurar logging del kernel
echo -e "${BLUE}Configurando logging del kernel...${NC}"
echo "# Configuración de logging para laboratorio de penetración testing" >> /etc/rsyslog.conf
echo "kern.warning /var/log/pentest-firewall.log" >> /etc/rsyslog.conf

# Reiniciar rsyslog
systemctl restart rsyslog 2>/dev/null || service rsyslog restart 2>/dev/null || true

# Guardar reglas
echo -e "${YELLOW}Guardando reglas de iptables...${NC}"
if command -v iptables-save >/dev/null 2>&1; then
    iptables-save > /etc/iptables/rules.v4 2>/dev/null || \
    iptables-save > /etc/iptables.rules 2>/dev/null || \
    iptables-save > ./lab-components/configs/iptables-backup.rules
    echo -e "${GREEN}✓ Reglas guardadas${NC}"
else
    echo -e "${YELLOW}⚠ No se pudo guardar las reglas automáticamente${NC}"
fi

# Mostrar resumen de reglas
echo -e "${GREEN}Configuración de firewall completada${NC}"
echo -e "${BLUE}Resumen de reglas configuradas:${NC}"
echo "- Permitido: HTTP/HTTPS hacia DMZ"
echo "- Permitido: Servicios web vulnerables (8080, 3000, 8081, 8082)"
echo "- Permitido: SSH honeypot (2222)"
echo "- Permitido: FTP vulnerable (21, 30000-30009)"
echo "- Permitido: MySQL desde DMZ hacia LAN"
echo "- BLOQUEADO: Acceso directo de atacantes a LAN"
echo "- Configurado: Logging y rate limiting"

echo -e "${YELLOW}Logs disponibles en:${NC}"
echo "- /var/log/kern.log (logs del kernel)"
echo "- /var/log/pentest-firewall.log (logs específicos del laboratorio)"
echo "- dmesg (logs recientes del kernel)"

echo -e "${GREEN}✓ Configuración de firewall completada exitosamente${NC}"
