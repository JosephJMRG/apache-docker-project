#!/bin/bash
# SCRIPT AUTOMATIZADO PARA DESPLIEGUE DE VULHUB
# Autor: Complemento para Apache Docker Project
# Ubicación: scripts/management/deploy-vulhub.sh

echo "=== VULHUB - DESPLIEGUE AUTOMATIZADO DE MÁQUINAS VULNERABLES ==="

# Directorio base del proyecto
PROJECT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/../.." && pwd)"
VULHUB_BASE_DIR="$PROJECT_DIR/vulhub-extensions/vulhub"

# Verificar si Vulhub está disponible
if [ ! -d "$VULHUB_BASE_DIR" ]; then
    echo "[-] Vulhub no encontrado. Ejecuta primero el script principal de automatización."
    exit 1
fi

# Función para mostrar categorías disponibles
show_categories() {
    echo "=== CATEGORÍAS DISPONIBLES EN VULHUB ==="
    cd "$VULHUB_BASE_DIR"
    
    echo "📂 Aplicaciones Web:"
    echo "   - apache         (Vulnerabilidades Apache HTTP Server)"
    echo "   - nginx          (Vulnerabilidades Nginx)"
    echo "   - tomcat         (Vulnerabilidades Apache Tomcat)"
    echo "   - wordpress      (Vulnerabilidades WordPress)"
    echo "   - drupal         (Vulnerabilidades Drupal)"
    
    echo ""
    echo "🗄️  Bases de Datos:"
    echo "   - mysql          (Vulnerabilidades MySQL)"
    echo "   - mongodb        (Vulnerabilidades MongoDB)"
    echo "   - redis          (Vulnerabilidades Redis)"
    echo "   - elasticsearch  (Vulnerabilidades Elasticsearch)"
    
    echo ""
    echo "☕ Frameworks:"
    echo "   - spring         (Vulnerabilidades Spring Framework)"
    echo "   - struts2        (Vulnerabilidades Apache Struts)"
    echo "   - flask          (Vulnerabilidades Flask)"
    echo "   - django         (Vulnerabilidades Django)"
    
    echo ""
    echo "🔧 Sistemas y Servicios:"
    echo "   - jenkins        (Vulnerabilidades Jenkins)"
    echo "   - docker         (Vulnerabilidades Docker)"
    echo "   - samba          (Vulnerabilidades Samba)"
    echo "   - vsftpd         (Vulnerabilidades FTP)"
    
    echo ""
    echo "Uso: $0 [categoria] [opcional: vulnerabilidad específica]"
    echo "Ejemplo: $0 apache"
    echo "Ejemplo: $0 spring CVE-2022-22947"
}

# Función para listar vulnerabilidades de una categoría
list_vulnerabilities() {
    local category="$1"
    local category_path="$VULHUB_BASE_DIR/$category"
    
    if [ ! -d "$category_path" ]; then
        echo "[-] Categoría '$category' no encontrada"
        show_categories
        return 1
    fi
    
    echo "=== VULNERABILIDADES DISPONIBLES EN: $category ==="
    cd "$category_path"
    
    local count=0
    for vuln_dir in */; do
        if [ -d "$vuln_dir" ] && [ -f "$vuln_dir/docker-compose.yml" ]; then
            vuln_name=$(basename "$vuln_dir")
            echo "   🎯 $vuln_name"
            ((count++))
        fi
    done
    
    echo ""
    echo "Total: $count vulnerabilidades encontradas"
    echo "Para desplegar: $0 $category [nombre_vulnerabilidad]"
}

# Función para desplegar una vulnerabilidad específica
deploy_vulnerability() {
    local category="$1"
    local vulnerability="$2"
    local vuln_path="$VULHUB_BASE_DIR/$category/$vulnerability"
    
    if [ ! -d "$vuln_path" ]; then
        echo "[-] Vulnerabilidad '$vulnerability' no encontrada en categoría '$category'"
        list_vulnerabilities "$category"
        return 1
    fi
    
    if [ ! -f "$vuln_path/docker-compose.yml" ]; then
        echo "[-] docker-compose.yml no encontrado en $vuln_path"
        return 1
    fi
    
    echo "=== DESPLEGANDO: $category/$vulnerability ==="
    cd "$vuln_path"
    
    # Verificar conflictos de puertos
    echo "[*] Verificando conflictos de puertos..."
    local ports_in_use=$(docker ps --format "table {{.Ports}}" | grep -E ":[0-9]+->" | wc -l)
    if [ "$ports_in_use" -gt 0 ]; then
        echo "[!] Advertencia: Hay contenedores usando puertos. Verifica conflictos."
    fi
    
    # Desplegar la vulnerabilidad
    echo "[*] Iniciando contenedores..."
    if docker-compose up -d; then
        echo "[+] Vulnerabilidad $vulnerability desplegada exitosamente"
        
        # Mostrar información de acceso
        echo ""
        echo "=== INFORMACIÓN DE ACCESO ==="
        docker-compose ps
        
        # Buscar archivo README
        if [ -f "README.md" ]; then
            echo ""
            echo "📖 Información adicional disponible en:"
            echo "   $vuln_path/README.md"
        fi
        
        # Mostrar puertos expuestos
        echo ""
        echo "🌐 Puertos expuestos:"
        docker-compose ps --format "table {{.Service}}\t{{.Ports}}" | grep -E ":[0-9]+->"
        
        echo ""
        echo "🔧 Para detener este entorno:"
        echo "   cd $vuln_path && docker-compose down"
        
    else
        echo "[-] Error desplegando $vulnerability"
        return 1
    fi
}

# Función para mostrar estado de vulnerabilidades activas
show_active_vulns() {
    echo "=== VULNERABILIDADES VULHUB ACTIVAS ==="
    cd "$VULHUB_BASE_DIR"
    
    local active_count=0
    find . -name "docker-compose.yml" -type f | while read compose_file; do
        dir_path=$(dirname "$compose_file")
        cd "$VULHUB_BASE_DIR/$dir_path"
        
        if docker-compose ps 2>/dev/null | grep -q "Up"; then
            echo "🟢 $(pwd | sed "s|$VULHUB_BASE_DIR/||")"
            ((active_count++))
        fi
    done
    
    if [ $active_count -eq 0 ]; then
        echo "No hay vulnerabilidades Vulhub activas"
    fi
}

# Función para limpiar todas las vulnerabilidades
cleanup_all() {
    echo "=== LIMPIANDO TODAS LAS VULNERABILIDADES VULHUB ==="
    read -p "¿Estás seguro de que quieres detener todas las vulnerabilidades Vulhub? (y/N): " -r
    
    if [[ $REPLY =~ ^[Yy]$ ]]; then
        cd "$VULHUB_BASE_DIR"
        
        find . -name "docker-compose.yml" -type f | while read compose_file; do
            dir_path=$(dirname "$compose_file")
            cd "$VULHUB_BASE_DIR/$dir_path"
            
            if docker-compose ps 2>/dev/null | grep -q "Up"; then
                echo "[*] Deteniendo $(pwd | sed "s|$VULHUB_BASE_DIR/||")"
                docker-compose down
            fi
        done
        
        echo "[+] Limpieza completada"
    else
        echo "Operación cancelada"
    fi
}

# Función principal
main() {
    # Verificar argumentos
    if [ $# -eq 0 ]; then
        show_categories
        echo ""
        echo "Comandos especiales:"
        echo "  $0 --list-active    # Mostrar vulnerabilidades activas"
        echo "  $0 --cleanup        # Limpiar todas las vulnerabilidades"
        exit 0
    fi
    
    case "$1" in
        --list-active)
            show_active_vulns
            ;;
        --cleanup)
            cleanup_all
            ;;
        --help|-h)
            show_categories
            ;;
        *)
            if [ $# -eq 1 ]; then
                # Solo categoría especificada
                list_vulnerabilities "$1"
            elif [ $# -eq 2 ]; then
                # Categoría y vulnerabilidad especificadas
                deploy_vulnerability "$1" "$2"
            else
                echo "[-] Demasiados argumentos"
                show_categories
                exit 1
            fi
            ;;
    esac
}

# Ejecutar función principal
main "$@"
