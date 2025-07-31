#!/bin/bash
# Apache Docker Project - Controlador Principal Consolidado
# Gestiona todo el ciclo de vida del laboratorio

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_ROOT="$(dirname "$SCRIPT_DIR")"

# Colores para output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m'

log_info() { echo -e "${BLUE}[INFO]${NC} $1"; }
log_success() { echo -e "${GREEN}[SUCCESS]${NC} $1"; }
log_warning() { echo -e "${YELLOW}[WARNING]${NC} $1"; }
log_error() { echo -e "${RED}[ERROR]${NC} $1"; }

# Verificar requisitos del sistema
check_requirements() {
    log_info "Verificando requisitos del sistema..."
    
    if ! command -v docker &> /dev/null; then
        log_error "Docker no está instalado"
        exit 1
    fi
    
    if ! command -v docker-compose &> /dev/null; then
        log_error "Docker Compose no está instalado"
        exit 1
    fi
    
    if ! docker ps &> /dev/null; then
        log_error "No tienes permisos para ejecutar Docker o Docker no está ejecutándose"
        exit 1
    fi
    
    log_success "Todos los requisitos están satisfechos"
}

# Configurar entorno
setup_environment() {
    log_info "Configurando entorno del laboratorio..."
    
    cd "$PROJECT_ROOT"
    
    # Crear directorios necesarios
    mkdir -p data/logs data/backups
    
    # Configurar redes Docker si el script existe
    if [ -f "$SCRIPT_DIR/setup-networks.sh" ]; then
        chmod +x "$SCRIPT_DIR/setup-networks.sh"
        "$SCRIPT_DIR/setup-networks.sh"
    fi
    
    # Configurar firewall si el script existe
    if [ -f "$SCRIPT_DIR/configure-firewall.sh" ]; then
        chmod +x "$SCRIPT_DIR/configure-firewall.sh"
        "$SCRIPT_DIR/configure-firewall.sh"
    fi
    
    log_success "Entorno configurado correctamente"
}

# Iniciar laboratorio completo
start_lab() {
    log_info "Iniciando laboratorio completo..."
    
    cd "$PROJECT_ROOT"
    
    # Verificar que existe docker-compose.yml
    if [ ! -f "docker-compose.yml" ]; then
        log_error "No se encontró docker-compose.yml en el directorio raíz"
        exit 1
    fi
    
    # Iniciar servicios
    docker-compose up -d
    
    # Esperar a que los servicios estén listos
    log_info "Esperando a que los servicios estén listos..."
    sleep 30
    
    # Verificar estado
    check_status
    
    log_success "Laboratorio iniciado correctamente"
}

# Verificar estado de servicios
check_status() {
    log_info "Verificando estado de servicios..."
    
    cd "$PROJECT_ROOT"
    
    echo ""
    echo "📊 Estado de contenedores:"
    docker-compose ps
    
    echo ""
    echo "🌐 Servicios disponibles:"
    echo "- Apache: http://localhost:9990"
    echo "- DVWA: http://localhost:9998"
    echo "- Juice Shop: http://localhost:9997"
    echo "- WebGoat: http://localhost:9996"
    echo "- Mutillidae: http://localhost:9995"
    echo "- Kibana: http://localhost:5601"
    echo ""
    
    # Verificar servicios activos
    local services_up=0
    local total_services=6
    
    if curl -s http://localhost:9990 > /dev/null 2>&1; then ((services_up++)); fi
    if curl -s http://localhost:9998 > /dev/null 2>&1; then ((services_up++)); fi
    if curl -s http://localhost:9997 > /dev/null 2>&1; then ((services_up++)); fi
    if curl -s http://localhost:9996 > /dev/null 2>&1; then ((services_up++)); fi
    if curl -s http://localhost:9995 > /dev/null 2>&1; then ((services_up++)); fi
    if curl -s http://localhost:5601 > /dev/null 2>&1; then ((services_up++)); fi
    
    echo "✅ Servicios activos: $services_up/$total_services"
}

# Detener laboratorio
stop_lab() {
    log_info "Deteniendo laboratorio..."
    cd "$PROJECT_ROOT"
    docker-compose down
    log_success "Laboratorio detenido"
}

# Limpiar entorno completo
cleanup() {
    log_warning "Limpiando entorno completo..."
    cd "$PROJECT_ROOT"
    docker-compose down -v
    docker system prune -f
    log_success "Limpieza completada"
}

# Acceder a Kali Linux
access_kali() {
    log_info "Accediendo a Kali Linux..."
    cd "$PROJECT_ROOT"
    
    # Verificar si el contenedor existe y está ejecutándose
    if docker-compose ps | grep -q "kali-attacker.*Up"; then
        docker-compose exec kali-attacker /bin/bash
    else
        log_error "El contenedor Kali no está ejecutándose. Usa 'start' primero."
        exit 1
    fi
}

# Crear backup
backup_lab() {
    log_info "Creando backup del laboratorio..."
    if [ -f "$SCRIPT_DIR/backup-lab.sh" ]; then
        chmod +x "$SCRIPT_DIR/backup-lab.sh"
        "$SCRIPT_DIR/backup-lab.sh"
    else
        log_warning "Script de backup no encontrado"
    fi
}

# Restaurar backup
restore_lab() {
    if [ -z "${1:-}" ]; then
        log_error "Especifica la ruta del backup"
        exit 1
    fi
    log_info "Restaurando backup: $1"
    if [ -f "$SCRIPT_DIR/restore-lab.sh" ]; then
        chmod +x "$SCRIPT_DIR/restore-lab.sh"
        "$SCRIPT_DIR/restore-lab.sh" "$1"
    else
        log_warning "Script de restore no encontrado"
    fi
}

# Gestionar Vulhub
manage_vulhub() {
    log_info "Gestionando Vulhub..."
    if [ -f "$SCRIPT_DIR/deploy-vulhub.sh" ]; then
        chmod +x "$SCRIPT_DIR/deploy-vulhub.sh"
        "$SCRIPT_DIR/deploy-vulhub.sh" "${@}"
    else
        log_warning "Script de Vulhub no encontrado"
    fi
}

# Mostrar ayuda
show_help() {
    cat << EOF
Apache Docker Project - Controlador Principal

Uso: $0 [COMANDO] [OPCIONES]

Comandos:
  setup           Configurar entorno inicial
  start           Iniciar laboratorio completo
  stop            Detener laboratorio
  status          Verificar estado de servicios
  restart         Reiniciar laboratorio
  cleanup         Limpiar entorno completo
  kali            Acceder a Kali Linux
  backup          Crear backup del laboratorio
  restore <path>  Restaurar desde backup
  vulhub [args]   Gestionar entornos Vulhub
  logs [service]  Ver logs de servicios
  help            Mostrar esta ayuda

Ejemplos:
  $0 setup        # Configuración inicial
  $0 start        # Iniciar todo el laboratorio
  $0 kali         # Acceder al contenedor atacante
  $0 vulhub list  # Listar vulnerabilidades disponibles
  $0 logs apache-server  # Ver logs de Apache

EOF
}

# Función principal
main() {
    case "${1:-help}" in
        setup)
            check_requirements
            setup_environment
            ;;
        start)
            check_requirements
            setup_environment
            start_lab
            ;;
        stop)
            stop_lab
            ;;
        status)
            check_status
            ;;
        restart)
            stop_lab
            sleep 5
            start_lab
            ;;
        cleanup)
            cleanup
            ;;
        kali)
            access_kali
            ;;
        backup)
            backup_lab
            ;;
        restore)
            restore_lab "${2:-}"
            ;;
        vulhub)
            shift
            manage_vulhub "$@"
            ;;
        logs)
            cd "$PROJECT_ROOT"
            if [ -n "${2:-}" ]; then
                docker-compose logs -f "$2"
            else
                docker-compose logs -f
            fi
            ;;
        help|--help|-h)
            show_help
            ;;
        *)
            log_error "Comando desconocido: $1"
            show_help
            exit 1
            ;;
    esac
}

# Ejecutar función principal
main "$@"
