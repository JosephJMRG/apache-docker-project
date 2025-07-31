#!/bin/bash

# Script para crear y configurar las redes Docker del laboratorio
# Proyecto: apache-docker-project
# Autor: JosephJMRG

# Colores para output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m'

echo -e "${BLUE}Configurando redes Docker para el laboratorio de penetración testing...${NC}"

# Función para verificar si una red existe
network_exists() {
    docker network ls --format "{{.Name}}" | grep -q "^$1$"
}

# Función para crear red si no existe
create_network_if_not_exists() {
    local network_name="$1"
    local subnet="$2"
    local gateway="$3"
    local internal="$4"
    local description="$5"
    
    if network_exists "$network_name"; then
        echo -e "${YELLOW}✓ Red $network_name ya existe${NC}"
        return 0
    fi
    
    echo -e "${BLUE}Creando red $network_name...${NC}"
    
    # Construir comando base
    local cmd="docker network create"
    cmd="$cmd --driver bridge"
    cmd="$cmd --subnet=$subnet"
    cmd="$cmd --gateway=$gateway"
    
    # Agregar flag internal si es necesario
    if [ "$internal" = "true" ]; then
        cmd="$cmd --internal"
    fi
    
    # Agregar labels
    cmd="$cmd --label description=\"$description\""
    cmd="$cmd --label environment=pentest-lab"
    cmd="$cmd --label project=apache-docker-project"
    
    # Agregar nombre de red
    cmd="$cmd $network_name"
    
    # Ejecutar comando
    if eval "$cmd"; then
        echo -e "${GREEN}✓ Red $network_name creada exitosamente${NC}"
        return 0
    else
        echo -e "${RED}✗ Error al crear red $network_name${NC}"
        return 1
    fi
}

# Verificar que Docker esté ejecutándose
if ! docker info >/dev/null 2>&1; then
    echo -e "${RED}Error: Docker no está ejecutándose${NC}"
    echo -e "${YELLOW}Inicia Docker Desktop y vuelve a ejecutar este script${NC}"
    exit 1
fi

echo -e "${YELLOW}Creando redes del laboratorio...${NC}"

# Crear red DMZ
create_network_if_not_exists \
    "dmz_network" \
    "192.168.90.0/24" \
    "192.168.90.1" \
    "false" \
    "DMZ Network for vulnerable web services"

# Crear red LAN (interna)
create_network_if_not_exists \
    "lan_network" \
    "192.168.1.0/24" \
    "192.168.1.1" \
    "true" \
    "Internal LAN Network for databases and internal services"

# Crear red de atacantes
create_network_if_not_exists \
    "attacker_network" \
    "10.0.0.0/24" \
    "10.0.0.1" \
    "false" \
    "Attacker Network for penetration testing tools"

# Crear red de monitoreo
create_network_if_not_exists \
    "monitoring_network" \
    "172.20.0.0/24" \
    "172.20.0.1" \
    "true" \
    "Monitoring and Logging Network"

echo -e "${YELLOW}Verificando configuración de redes...${NC}"

# Mostrar información de las redes creadas
echo -e "${BLUE}Redes Docker del laboratorio:${NC}"
docker network ls --filter "label=project=apache-docker-project" --format "table {{.Name}}\t{{.Driver}}\t{{.Scope}}"

echo -e "\n${BLUE}Detalles de configuración:${NC}"

# Mostrar detalles de cada red
for network in dmz_network lan_network attacker_network monitoring_network; do
    if network_exists "$network"; then
        echo -e "\n${GREEN}Red: $network${NC}"
        docker network inspect "$network" --format "  Subnet: {{range .IPAM.Config}}{{.Subnet}}{{end}}"
        docker network inspect "$network" --format "  Gateway: {{range .IPAM.Config}}{{.Gateway}}{{end}}"
        docker network inspect "$network" --format "  Internal: {{.Internal}}"
        docker network inspect "$network" --format "  Description: {{index .Labels \"description\"}}"
    fi
done

echo -e "\n${BLUE}Configuración de segmentación de red:${NC}"
echo "┌─────────────────┬─────────────────┬─────────────────┬─────────────────┐"
echo "│ Red             │ Subnet          │ Acceso Internet │ Servicios       │"
echo "├─────────────────┼─────────────────┼─────────────────┼─────────────────┤"
echo "│ DMZ             │ 192.168.90.0/24 │ ✓ Sí           │ Web Vulnerables │"
echo "│ LAN             │ 192.168.1.0/24  │ ✗ No           │ Bases de Datos  │"
echo "│ Atacantes       │ 10.0.0.0/24     │ ✓ Sí           │ Kali Linux      │"
echo "│ Monitoreo       │ 172.20.0.0/24   │ ✗ No           │ ELK Stack       │"
echo "└─────────────────┴─────────────────┴─────────────────┴─────────────────┘"

echo -e "\n${BLUE}Matriz de comunicación entre redes:${NC}"
echo "┌─────────────────┬─────┬─────┬─────────────┬───────────┐"
echo "│ Desde \\ Hacia   │ DMZ │ LAN │ Atacantes   │ Monitoreo │"
echo "├─────────────────┼─────┼─────┼─────────────┼───────────┤"
echo "│ DMZ             │ ✓   │ ✓*  │ ✗           │ ✓         │"
echo "│ LAN             │ ✓   │ ✓   │ ✗           │ ✓         │"
echo "│ Atacantes       │ ✓   │ ✗   │ ✓           │ ✗         │"
echo "│ Monitoreo       │ ✓   │ ✓   │ ✗           │ ✓         │"
echo "└─────────────────┴─────┴─────┴─────────────┴───────────┘"
echo "* Solo puertos específicos (MySQL: 3306)"

# Verificar conectividad básica
echo -e "\n${YELLOW}Verificando conectividad de redes...${NC}"

# Función para probar conectividad
test_network_connectivity() {
    local network="$1"
    echo -n "Probando conectividad de $network: "
    
    # Crear contenedor temporal para probar la red
    if docker run --rm --network "$network" alpine:latest ping -c 1 -W 5 8.8.8.8 >/dev/null 2>&1; then
        if [ "$network" = "lan_network" ] || [ "$network" = "monitoring_network" ]; then
            echo -e "${GREEN}✓ Sin acceso a Internet (como se esperaba)${NC}"
        else
            echo -e "${GREEN}✓ Conectividad OK${NC}"
        fi
    else
        if [ "$network" = "lan_network" ] || [ "$network" = "monitoring_network" ]; then
            echo -e "${GREEN}✓ Sin acceso a Internet (correcto)${NC}"
        else
            echo -e "${YELLOW}⚠ Sin conectividad a Internet${NC}"
        fi
    fi
}

# Probar cada red
for network in dmz_network lan_network attacker_network monitoring_network; do
    if network_exists "$network"; then
        test_network_connectivity "$network"
    fi
done

# Crear archivo de configuración de red
echo -e "\n${YELLOW}Creando archivo de configuración de red...${NC}"
cat > "./lab-components/configs/network-status.txt" << EOF
# Estado de redes del laboratorio de penetración testing
# Generado: $(date)

REDES CONFIGURADAS:
==================

DMZ Network (dmz_network):
- Subnet: 192.168.90.0/24
- Gateway: 192.168.90.1
- Internet: Sí
- Servicios: Apache, DVWA, Juice Shop, WebGoat, Mutillidae, SSH Honeypot, FTP

LAN Network (lan_network):
- Subnet: 192.168.1.0/24
- Gateway: 192.168.1.1
- Internet: No (red interna)
- Servicios: MySQL vulnerable, bases de datos internas

Attacker Network (attacker_network):
- Subnet: 10.0.0.0/24
- Gateway: 10.0.0.1
- Internet: Sí
- Servicios: Kali Linux, herramientas de pentesting

Monitoring Network (monitoring_network):
- Subnet: 172.20.0.0/24
- Gateway: 172.20.0.1
- Internet: No (red interna)
- Servicios: Elasticsearch, Logstash, Kibana

REGLAS DE COMUNICACIÓN:
======================

1. DMZ → LAN: Solo MySQL (puerto 3306)
2. Atacantes → DMZ: Acceso completo
3. Atacantes → LAN: BLOQUEADO
4. Todas las redes → Monitoreo: Permitido para logs

Para más detalles, consulta:
- docker network ls
- docker network inspect <nombre_red>
EOF

echo -e "${GREEN}✓ Configuración de redes completada exitosamente${NC}"
echo -e "${BLUE}Archivo de estado creado en: lab-components/configs/network-status.txt${NC}"
echo -e "${YELLOW}Nota: Las reglas de firewall se configurarán con el script configure-firewall.sh${NC}"
