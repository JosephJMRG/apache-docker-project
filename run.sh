#!/bin/bash
# run.sh - Script principal para Apache Docker Project
# Compatible con Linux nativo y Windows con Git Bash/WSL
# Incluye funcionalidad completa de Kali Linux

set -euo pipefail

PROJECT_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# Colores para output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m'

# Funciones de logging
log_info() { echo -e "${BLUE}[INFO]${NC} $1"; }
log_success() { echo -e "${GREEN}[SUCCESS]${NC} $1"; }
log_warning() { echo -e "${YELLOW}[WARNING]${NC} $1"; }
log_error() { echo -e "${RED}[ERROR]${NC} $1"; }

# Verificar entorno
check_environment() {
    log_info "Verificando entorno..."
    
    # Verificar que estamos en bash
    if [ -z "$BASH_VERSION" ]; then
        log_error "Este script requiere Bash. En Windows, usa Git Bash o WSL."
        exit 1
    fi
    
    # Verificar Docker
    if ! command -v docker &> /dev/null; then
        log_error "Docker no está instalado. Instala Docker Desktop."
        exit 1
    fi
    
    # Verificar docker-compose
    if ! command -v docker-compose &> /dev/null; then
        log_error "Docker Compose no está instalado."
        exit 1
    fi
    
    # Verificar que Docker está ejecutándose
    if ! docker info &> /dev/null; then
        log_error "Docker no está ejecutándose. Inicia Docker Desktop."
        exit 1
    fi
    
    # Verificar que docker-compose.yml existe
    if [ ! -f "$PROJECT_ROOT/docker-compose.yml" ]; then
        log_error "docker-compose.yml no encontrado en $PROJECT_ROOT"
        exit 1
    fi
    
    log_success "Entorno verificado correctamente"
}

# Limpiar redes problemáticas
clean_docker_networks() {
    log_info "Limpiando redes Docker problemáticas..."
    
    # Lista de redes a limpiar
    local networks=(
        "apache-docker-lab_dmz_network"
        "apache-docker-lab_lan_network"
        "dmz_network"
        "lan_network"
        "attacker_network"
        "monitoring_network"
    )
    
    # Detener contenedores que puedan estar usando las redes
    docker-compose down 2>/dev/null || true
    
    # Remover redes problemáticas
    for network in "${networks[@]}"; do
        if docker network ls --format "{{.Name}}" | grep -q "^${network}$"; then
            log_warning "Removiendo red problemática: $network"
            docker network rm "$network" 2>/dev/null || true
        fi
    done
    
    # Limpiar redes huérfanas
    docker network prune -f >/dev/null 2>&1
    
    log_success "Redes Docker limpiadas"
}

# Configurar permisos y directorios
setup_permissions() {
    log_info "Configurando permisos y directorios..."
    
    # Crear directorios necesarios
    mkdir -p "$PROJECT_ROOT/data/logs"
    mkdir -p "$PROJECT_ROOT/data/backups"
    mkdir -p "$PROJECT_ROOT/www/PwotoSite.cl/html"
    mkdir -p "$PROJECT_ROOT/www/PwotoSite.cl/log"
    
    # Configurar permisos
    chmod -R 755 "$PROJECT_ROOT/data" 2>/dev/null || true
    chmod -R 755 "$PROJECT_ROOT/www" 2>/dev/null || true
    
    log_success "Permisos configurados"
}

# Configurar redes Docker
setup_networks() {
    log_info "Configurando redes Docker..."
    
    # Crear redes manualmente para evitar conflictos
    docker network create apache-docker-lab_dmz_network \
        --driver bridge \
        --subnet=172.18.1.0/24 \
        --label com.docker.compose.network=dmz_network \
        --label com.docker.compose.project=apache-docker-lab \
        --label com.docker.compose.version=2.38.1 \
        2>/dev/null || true
    
    docker network create apache-docker-lab_lan_network \
        --driver bridge \
        --internal \
        --subnet=172.18.2.0/24 \
        --label com.docker.compose.network=lan_network \
        --label com.docker.compose.project=apache-docker-lab \
        --label com.docker.compose.version=2.38.1 \
        2>/dev/null || true
    
    log_success "Redes configuradas"
}

# Verificar y corregir docker-compose.yml
fix_docker_compose() {
    log_info "Verificando docker-compose.yml..."
    
    # Verificar que el archivo existe y es válido
    if ! docker-compose config &> /dev/null; then
        log_warning "Problemas detectados en docker-compose.yml, aplicando correcciones..."
        
        # Crear versión corregida si es necesario
        if ! grep -q "services:" "$PROJECT_ROOT/docker-compose.yml"; then
            log_error "docker-compose.yml corrupto, usa fix.sh para reparar"
            exit 1
        fi
    fi
}

# Función de configuración inicial
install_project() {
    log_info "Configurando proyecto..."
    
    check_environment
    clean_docker_networks
    setup_permissions
    setup_networks
    fix_docker_compose
    
    log_success "Proyecto configurado. Usa '$0 start' para iniciar."
}

# Iniciar laboratorio
start_lab() {
    log_info "Iniciando laboratorio apache-docker-lab..."
    
    check_environment
    clean_docker_networks
    setup_permissions
    setup_networks
    fix_docker_compose
    
    cd "$PROJECT_ROOT"
    
    # Iniciar servicios
    docker-compose up -d
    
    # Esperar a que los servicios estén listos
    log_info "Esperando a que los servicios estén listos..."
    sleep 30
    
    # Verificar estado
    show_status
    
    log_success "Laboratorio iniciado"
}

# Detener laboratorio
stop_lab() {
    log_info "Deteniendo laboratorio..."
    
    cd "$PROJECT_ROOT"
    docker-compose down
    
    log_success "Laboratorio detenido"
}

# Mostrar estado
show_status() {
    log_info "Estado del laboratorio:"
    
    echo ""
    echo "📊 Contenedores:"
    docker-compose ps
    
    echo ""
    echo "🌐 Servicios web:"
    
    # Verificar servicios
    local services=(
        "Apache:9990"
        "DVWA:9998"
        "Juice Shop:9997"
        "WebGoat:9996"
        "Mutillidae:9995"
    )
    
    for service in "${services[@]}"; do
        local name="${service%%:*}"
        local port="${service##*:}"
        local url="http://localhost:$port"
        
        if curl -s --connect-timeout 5 "$url" > /dev/null 2>&1; then
            echo "✅ $name - $url"
        else
            echo "❌ $name - $url (no responde)"
        fi
    done
}

# Acceder a Kali Linux - NUEVA FUNCIONALIDAD
access_kali() {
    log_info "Accediendo a Kali Linux..."
    
    cd "$PROJECT_ROOT"
    
    # Verificar si el contenedor Kali existe en docker-compose
    if ! grep -q "kali" "$PROJECT_ROOT/docker-compose.yml"; then
        log_warning "Contenedor Kali no está configurado en docker-compose.yml"
        log_info "Creando contenedor Kali temporal..."
        create_temporary_kali
        return
    fi
    
    # Verificar si existe contenedor kali
    if docker-compose ps | grep -q "kali.*Up"; then
        log_success "Conectando a Kali Linux..."
        case "$OSTYPE" in
            msys*|cygwin*)
                winpty docker-compose exec kali-attacker //bin//bash
                ;;
            *)
                docker-compose exec kali-attacker /bin/bash
                ;;
        esac
    elif docker ps | grep -q "kali"; then
        log_success "Conectando a contenedor Kali independiente..."
        case "$OSTYPE" in
            msys*|cygwin*)
                winpty docker exec -it kali-attacker //bin//bash
                ;;
            *)
                docker exec -it kali-attacker /bin/bash
                ;;
        esac
    else
        log_warning "Contenedor Kali no está ejecutándose"
        log_info "Iniciando Kali Linux temporal..."
        create_temporary_kali
    fi
}

# Crear contenedor Kali temporal
create_temporary_kali() {
    log_info "Creando contenedor Kali Linux temporal..."
    
    # Crear contenedor Kali temporal con herramientas básicas
    local kali_container=$(docker run -d -it \
        --name kali-pentesting-temp \
        --network apache-docker-lab_dmz_network \
        kalilinux/kali-rolling /bin/bash)
    
    if [ $? -eq 0 ]; then
        log_success "Contenedor Kali creado: $kali_container"
        log_info "Instalando herramientas básicas..."
        
        # Instalar herramientas básicas
        docker exec -it kali-pentesting-temp bash -c "
            apt-get update > /dev/null 2>&1 && 
            apt-get install -y nmap curl wget net-tools dnsutils > /dev/null 2>&1 &&
            echo '✅ Herramientas básicas instaladas'
        " 2>/dev/null || log_warning "Algunas herramientas pueden no haberse instalado"
        
        log_info "Conectando a Kali Linux..."
        case "$OSTYPE" in
            msys*|cygwin*)
                winpty docker exec -it kali-pentesting-temp //bin//bash
                ;;
            *)
                docker exec -it kali-pentesting-temp /bin/bash
                ;;
        esac
        
        # Limpiar contenedor temporal al salir
        log_info "Limpiando contenedor temporal..."
        docker stop kali-pentesting-temp > /dev/null 2>&1
        docker rm kali-pentesting-temp > /dev/null 2>&1
        log_success "Contenedor temporal eliminado"
    else
        log_error "No se pudo crear el contenedor Kali temporal"
        log_info "Instalando herramientas en tu sistema local..."
        show_local_tools_info
    fi
}

# Mostrar información de herramientas locales
show_local_tools_info() {
    echo ""
    echo "🔧 Herramientas de pentesting para Windows:"
    echo ""
    echo "📥 Descargas recomendadas:"
    echo "  • Nmap: https://nmap.org/download.html"
    echo "  • Burp Suite: https://portswigger.net/burp/communitydownload"
    echo "  • OWASP ZAP: https://www.zaproxy.org/download/"
    echo "  • Wireshark: https://www.wireshark.org/download.html"
    echo ""
    echo "💻 Comandos básicos con herramientas locales:"
    echo "  • nmap -sS -p 80,443,9990-9998 localhost"
    echo "  • curl -I http://localhost:9990"
    echo "  • powershell Invoke-WebRequest http://localhost:9998"
    echo ""
    echo "🌐 Servicios disponibles para testing:"
    echo "  • Apache: http://localhost:9990"
    echo "  • DVWA: http://localhost:9998 (admin/password)"
    echo "  • Juice Shop: http://localhost:9997"
    echo "  • WebGoat: http://localhost:9996"
    echo "  • Mutillidae: http://localhost:9995"
}

# Ver logs
show_logs() {
    log_info "Mostrando logs del laboratorio..."
    
    cd "$PROJECT_ROOT"
    if [ -n "${1:-}" ]; then
        docker-compose logs -f "$1"
    else
        docker-compose logs -f
    fi
}

# Limpiar entorno
clean_lab() {
    log_warning "Limpiando entorno completo..."
    
    read -p "¿Estás seguro? Esto eliminará todos los contenedores y volúmenes (y/N): " -r
    if [[ $REPLY =~ ^[Yy]$ ]]; then
        cd "$PROJECT_ROOT"
        docker-compose down -v
        clean_docker_networks
        docker system prune -f
        log_success "Entorno limpiado"
    else
        log_info "Operación cancelada"
    fi
}

# Crear backup
create_backup() {
    log_info "Creando backup del laboratorio..."
    
    local backup_dir="$PROJECT_ROOT/data/backups/backup-$(date +%Y%m%d_%H%M%S)"
    mkdir -p "$backup_dir"
    
    # Backup de configuraciones
    cp -r "$PROJECT_ROOT/config" "$backup_dir/" 2>/dev/null || true
    cp -r "$PROJECT_ROOT/www" "$backup_dir/" 2>/dev/null || true
    cp "$PROJECT_ROOT/docker-compose.yml" "$backup_dir/" 2>/dev/null || true
    cp "$PROJECT_ROOT/.env" "$backup_dir/" 2>/dev/null || true
    
    log_success "Backup creado en: $backup_dir"
}

# Mostrar ayuda
show_help() {
    cat << EOF
Apache Docker Project - Laboratorio de Pentesting

Uso: $0 [COMANDO]

Comandos disponibles:
  install     - Configurar proyecto (primera vez)
  start       - Iniciar laboratorio completo
  stop        - Detener laboratorio
  restart     - Reiniciar laboratorio
  status      - Mostrar estado de servicios
  kali        - Acceder a Kali Linux para pentesting
  logs        - Ver logs del laboratorio
  clean       - Limpiar entorno completo
  backup      - Crear backup del laboratorio
  help        - Mostrar esta ayuda

Ejemplos:
  $0 install  # Primera configuración
  $0 start    # Iniciar laboratorio
  $0 kali     # Acceder a herramientas de pentesting
  $0 status   # Ver estado de servicios

Servicios del laboratorio:
  • Apache:     http://localhost:9990
  • DVWA:       http://localhost:9998
  • Juice Shop: http://localhost:9997
  • WebGoat:    http://localhost:9996
  • Mutillidae: http://localhost:9995

Proyecto: apache-docker-project
EOF
}

# Función principal
main() {
    local command="${1:-help}"
    
    case "$command" in
        install)
            install_project
            ;;
        start)
            start_lab
            ;;
        stop)
            stop_lab
            ;;
        restart)
            stop_lab
            sleep 5
            start_lab
            ;;
        status)
            check_environment
            show_status
            ;;
        kali)
            access_kali
            ;;
        logs)
            shift
            show_logs "$@"
            ;;
        clean)
            clean_lab
            ;;
        backup)
            create_backup
            ;;
        help|--help|-h)
            show_help
            ;;
        *)
            log_error "Comando desconocido: $command"
            echo ""
            show_help
            exit 1
            ;;
    esac
}

# Verificar que no se ejecute directamente desde Windows CMD
if [[ "$OSTYPE" == "msys" || "$OSTYPE" == "win32" ]]; then
    if [ -z "$BASH" ]; then
        echo "ERROR: Este script debe ejecutarse desde Git Bash o WSL en Windows."
        echo "Instala Git Bash: https://git-scm.com/download/win"
        exit 1
    fi
fi

# Ejecutar función principal
main "$@"
