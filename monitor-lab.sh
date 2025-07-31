#!/bin/bash
# Monitor del laboratorio Apache Docker Project

RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m'

echo -e "${BLUE}=== Monitor del Laboratorio PwotoSite.cl ===${NC}"
echo "Fecha: $(date)"
echo ""

echo -e "${YELLOW}📊 Estado de contenedores:${NC}"
docker-compose ps

echo -e "\n${YELLOW}🌐 Servicios web:${NC}"
services=("apache-server:9990:Apache" "dvwa:9998:DVWA" "juice-shop:9997:Juice Shop" "webgoat:9996:WebGoat")

for service in "${services[@]}"; do
    container="${service%%:*}"
    temp="${service#*:}"
    port="${temp%%:*}"
    name="${service##*:}"
    
    if docker-compose ps "$container" 2>/dev/null | grep -q "Up"; then
        if curl -s --connect-timeout 3 "http://localhost:$port" > /dev/null 2>&1; then
            echo -e "${GREEN}✅ $name - http://localhost:$port${NC}"
        else
            echo -e "${YELLOW}⚠️ $name - http://localhost:$port (iniciando...)${NC}"
        fi
    else
        echo -e "${RED}❌ $name - Contenedor detenido${NC}"
    fi
done

echo -e "\n${YELLOW}💾 Uso de recursos:${NC}"
docker stats --no-stream --format "table {{.Container}}\t{{.CPUPerc}}\t{{.MemUsage}}" 2>/dev/null || echo "No se pudo obtener estadísticas"

echo -e "\n${BLUE}=== Fin del reporte ===${NC}"
