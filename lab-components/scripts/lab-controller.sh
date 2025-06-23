#!/bin/bash

# Controlador principal del laboratorio de penetración testing
# Proyecto: apache-docker-project
# Autor: JosephJMRG

# Colores para output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Función para mostrar banner
show_banner() {
    echo -e "${BLUE}"
    echo "=================================================="
    echo "    LABORATORIO DE PENETRACIÓN TESTING"
    echo "         Apache Docker Project Lab"
    echo "=================================================="
    echo -e "${NC}"
}

# Función para mostrar estado
show_status() {
    echo -e "${YELLOW}Verificando estado del laboratorio...${NC}"
    docker-compose ps
    echo -e "\n${BLUE}Redes Docker creadas:${NC}"
    docker network ls | grep -E "(dmz_network|lan_network|attacker_network)"
    echo -e "\n${BLUE}Servicios disponibles:${NC}"
    echo "- Apache (PwotoSite.cl): http://localhost"
    echo "- DVWA: http://localhost:8080"
    echo "- Juice Shop: http://localhost:3000"
    echo "- WebGoat: http://localhost:8081"
    echo "- Mutillidae: http://localhost:8082"
    echo "- SSH Honeypot: localhost:2222"
    echo "- FTP Vulnerable: localhost:21"
    echo "- MySQL Vulnerable: localhost:3306"
}

# Función para iniciar laboratorio
start_lab() {
    show_banner
    echo -e "${GREEN}Iniciando laboratorio de penetración testing...${NC}"
    
    # Verificar si Docker está ejecutándose
    if ! docker info >/dev/null 2>&1; then
        echo -e "${RED}Error: Docker no está ejecutándose${NC}"
        exit 1
    fi
    
    # Crear redes si no existen
    echo -e "${YELLOW}Configurando redes Docker...${NC}"
    ./lab-components/scripts/setup-networks.sh
    
    # Iniciar servicios
    echo -e "${YELLOW}Iniciando contenedores...${NC}"
    docker-compose up -d
    
    # Configurar firewall
    echo -e "${YELLOW}Configurando reglas de firewall...${NC}"
    ./lab-components/scripts/configure-firewall.sh
    
    # Esperar a que los servicios estén listos
    echo -e "${YELLOW}Esperando a que los servicios estén listos...${NC}"
    sleep 30
    
    echo -e "${GREEN}✓ Laboratorio iniciado exitosamente${NC}"
    show_status
}

# Función para detener laboratorio
stop_lab() {
    echo -e "${YELLOW}Deteniendo laboratorio...${NC}"
    docker-compose down
    echo -e "${GREEN}✓ Laboratorio detenido${NC}"
}

# Función para reiniciar laboratorio
restart_lab() {
    echo -e "${YELLOW}Reiniciando laboratorio...${NC}"
    stop_lab
    sleep 5
    start_lab
}

# Función para acceder al contenedor atacante
access_attacker() {
    echo -e "${GREEN}Accediendo al contenedor Kali Linux...${NC}"
    echo -e "${YELLOW}Tip: Usa 'exit' para salir del contenedor${NC}"
    docker exec -it kali-attacker /bin/bash
}

# Función para mostrar logs
show_logs() {
    if [ -z "$2" ]; then
        echo -e "${YELLOW}Mostrando logs de todos los contenedores...${NC}"
        docker-compose logs --tail=50
    else
        echo -e "${YELLOW}Mostrando logs de $2...${NC}"
        docker-compose logs --tail=50 "$2"
    fi
}

# Función para limpiar todo
cleanup() {
    echo -e "${RED}¿Estás seguro de que quieres eliminar todo el laboratorio? (y/N)${NC}"
    read -r response
    if [[ "$response" =~ ^([yY][eE][sS]|[yY])$ ]]; then
        echo -e "${YELLOW}Eliminando contenedores, volúmenes y redes...${NC}"
        docker-compose down -v
        docker network rm dmz_network lan_network attacker_network 2>/dev/null || true
        echo -e "${GREEN}✓ Laboratorio completamente eliminado${NC}"
    else
        echo -e "${BLUE}Operación cancelada${NC}"
    fi
}

# Función para backup
backup_lab() {
    echo -e "${YELLOW}Iniciando backup del laboratorio...${NC}"
    ./lab-components/scripts/backup-lab.sh
}

# Función para mostrar ayuda
show_help() {
    show_banner
    echo -e "${BLUE}Uso: $0 {comando} [opciones]${NC}"
    echo ""
    echo "Comandos disponibles:"
    echo "  start         Iniciar el laboratorio completo"
    echo "  stop          Detener el laboratorio"
    echo "  restart       Reiniciar el laboratorio"
    echo "  status        Mostrar estado actual"
    echo "  attack        Acceder al contenedor atacante (Kali)"
    echo "  logs [servicio] Mostrar logs (todos o de un servicio específico)"
    echo "  backup        Crear backup del laboratorio"
    echo "  cleanup       Eliminar todo el laboratorio"
    echo "  help          Mostrar esta ayuda"
    echo ""
    echo "Ejemplos:"
    echo "  $0 start"
    echo "  $0 logs dvwa"
    echo "  $0 attack"
}

# Verificar argumentos
if [ $# -eq 0 ]; then
    show_help
    exit 1
fi

# Procesar comandos
case "$1" in
    start)
        start_lab
        ;;
    stop)
        stop_lab
        ;;
    restart)
        restart_lab
        ;;
    status)
        show_status
        ;;
    attack)
        access_attacker
        ;;
    logs)
        show_logs "$@"
        ;;
    backup)
        backup_lab
        ;;
    cleanup)
        cleanup
        ;;
    help|--help|-h)
        show_help
        ;;
    *)
        echo -e "${RED}Error: Comando desconocido '$1'${NC}"
        echo -e "${YELLOW}Usa '$0 help' para ver los comandos disponibles${NC}"
        exit 1
        ;;
esac

exit 0
