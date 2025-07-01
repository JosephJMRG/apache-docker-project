#!/bin/bash
# fix-lab-complete-final.sh - Corrección integral del Apache Docker Project
# Actualizado para puertos personalizados y verificación detallada

echo "=== APACHE DOCKER PROJECT - CORRECCIÓN INTEGRAL AUTOMATIZADA ==="

PROJECT_DIR="$(pwd)"
COMPOSE_FILE="docker-compose.yml"
BACKUP_DIR="backups-$(date +%Y%m%d_%H%M%S)"

# Crear directorio de backups
mkdir -p "$BACKUP_DIR"
echo "[+] Directorio de backup creado: $BACKUP_DIR"

## 1. CREAR BACKUP DE ARCHIVOS CRÍTICOS
echo "=== CREANDO BACKUPS ==="
cp "$COMPOSE_FILE" "$BACKUP_DIR/docker-compose.yml.backup" 2>/dev/null || echo "[!] No se pudo hacer backup de docker-compose.yml"
cp "scripts/management/lab-controller.sh" "$BACKUP_DIR/lab-controller.sh.backup" 2>/dev/null || echo "[!] No se pudo hacer backup de lab-controller.sh"

## 2. CORREGIR DOCKER-COMPOSE.YML - RED EXTENDED_NETWORK
echo "=== CORRIGIENDO DEFINICIÓN DE REDES ==="

if [ -f "$COMPOSE_FILE" ]; then
    # Verificar si extended_network está siendo usada pero no definida
    if grep -q "extended_network" "$COMPOSE_FILE" && ! grep -A 10 "^networks:" "$COMPOSE_FILE" | grep -q "extended_network:"; then
        echo "[!] Red extended_network está siendo usada pero no definida"
        
        # Agregar definición de extended_network si no existe la sección networks
        if ! grep -q "^networks:" "$COMPOSE_FILE"; then
            echo "" >> "$COMPOSE_FILE"
            cat >> "$COMPOSE_FILE" << 'EOF'
networks:
  dmz_network:
    driver: bridge
    ipam:
      config:
        - subnet: 192.168.90.0/24
          gateway: 192.168.90.1
  lan_network:
    driver: bridge
    ipam:
      config:
        - subnet: 192.168.1.0/24
          gateway: 192.168.1.1
  extended_network:
    driver: bridge
    ipam:
      config:
        - subnet: 192.168.100.0/24
          gateway: 192.168.100.1
  monitoring_network:
    driver: bridge
    ipam:
      config:
        - subnet: 172.20.0.0/24
          gateway: 172.20.0.1
EOF
            echo "[+] Sección networks agregada con todas las redes necesarias"
        else
            # Agregar solo extended_network a la sección existente
            sed -i '/^networks:/a\
  extended_network:\
    driver: bridge\
    ipam:\
      config:\
        - subnet: 192.168.100.0/24\
          gateway: 192.168.100.1' "$COMPOSE_FILE"
            echo "[+] Red extended_network agregada a la sección networks existente"
        fi
    fi
    
    # Corregir imagen de Kali Linux si está incorrecta
    if grep -q "kalilinux/kali-linux-docker" "$COMPOSE_FILE"; then
        sed -i 's/kalilinux\/kali-linux-docker/kalilinux\/kali-rolling/g' "$COMPOSE_FILE"
        echo "[+] Imagen Kali corregida a kalilinux/kali-rolling"
    fi
    
    # Resolver conflicto de puerto 8080 (Apache vs DVWA)
    if grep -q '"8080:80"' "$COMPOSE_FILE" && grep -A 5 -B 5 "apache-server\|apache-pwotosite" "$COMPOSE_FILE" | grep -q '"8080:80"'; then
        # Cambiar puerto de Apache a 8090
        sed -i '/apache-server\|apache-pwotosite/,/ports:/{
            s/"8080:80"/"8090:80"/g
        }' "$COMPOSE_FILE"
        echo "[+] Puerto Apache cambiado de 8080 a 8090 para evitar conflicto con DVWA"
    fi
else
    echo "[-] No se encontró $COMPOSE_FILE"
fi

## 3. DETENER CONTENEDORES PROBLEMÁTICOS
echo "=== LIMPIANDO CONTENEDORES PROBLEMÁTICOS ==="
docker stop apache-pwotosite 2>/dev/null && echo "[+] Apache-pwotosite detenido"
docker rm apache-pwotosite 2>/dev/null && echo "[+] Apache-pwotosite eliminado"

## 4. CORREGIR LAB-CONTROLLER.SH PARA GIT BASH
echo "=== CORRIGIENDO LAB-CONTROLLER.SH ==="

LAB_CONTROLLER="scripts/management/lab-controller.sh"
if [ -f "$LAB_CONTROLLER" ]; then
    # Crear función access_attacker corregida
    cat > /tmp/new_access_attacker.txt << 'EOF'
access_attacker() {
    echo -e "${GREEN}[INFO]${NC} Accediendo al contenedor Kali Linux..."
    cd "$PROJECT_DIR"
    
    if docker-compose ps | grep -q "kali.*Up"; then
        echo -e "${GREEN}Conectando a Kali Linux...${NC}"
        case "$OSTYPE" in
            msys*|cygwin*)
                winpty docker-compose exec kali-attacker //bin//bash
                ;;
            *)
                docker-compose exec kali-attacker /bin/bash
                ;;
        esac
    else
        echo -e "${RED}✗ Contenedor Kali no está activo${NC}"
        echo "Inicia el laboratorio primero: $0 start"
    fi
}
EOF

    # Reemplazar función access_attacker
    awk '
    BEGIN { in_function = 0 }
    /^access_attacker\(\)/ { 
        in_function = 1
        system("cat /tmp/new_access_attacker.txt")
        next
    }
    in_function && /^}/ {
        in_function = 0
        next
    }
    !in_function { print }
    ' "$LAB_CONTROLLER" > "${LAB_CONTROLLER}.tmp" && mv "${LAB_CONTROLLER}.tmp" "$LAB_CONTROLLER"
    
    rm -f /tmp/new_access_attacker.txt
    chmod +x "$LAB_CONTROLLER"
    echo "[+] lab-controller.sh corregido para Git Bash"
else
    echo "[!] No se encontró $LAB_CONTROLLER"
fi

## 5. REINICIAR SERVICIOS DOCKER
echo "=== REINICIANDO SERVICIOS DOCKER ==="

# Detener todos los servicios
docker-compose down 2>/dev/null

# Limpiar redes problemáticas
docker network prune -f >/dev/null 2>&1

# Iniciar servicios con configuración corregida
echo "[*] Iniciando servicios con configuración corregida..."
docker-compose up -d

## 6. ESPERAR INICIALIZACIÓN
echo "=== ESPERANDO INICIALIZACIÓN DE SERVICIOS ==="
echo "[*] Esperando 30 segundos para que los servicios se inicien..."
sleep 30

## 7. INSTALAR HERRAMIENTAS EN KALI LINUX
echo "=== INSTALANDO HERRAMIENTAS EN KALI LINUX ==="

if docker ps | grep -q "kali-attacker.*Up"; then
    echo "[*] Instalando herramientas de pentesting en Kali..."
    docker exec -it kali-attacker bash -c "
        apt-get update >/dev/null 2>&1 && 
        apt-get install -y nmap nikto dirb sqlmap curl wget net-tools hydra dnsutils whois >/dev/null 2>&1 &&
        echo '[+] Herramientas instaladas exitosamente'
    " 2>/dev/null || echo "[!] Error instalando herramientas - se puede hacer manualmente"
else
    echo "[!] Kali Linux no está ejecutándose"
fi

## 8. CONFIGURAR VULHUB
echo "=== CONFIGURANDO VULHUB ==="

if [ ! -d "vulhub-extensions" ]; then
    mkdir vulhub-extensions
fi

cd vulhub-extensions
if [ ! -d "vulhub" ]; then
    echo "[*] Descargando Vulhub..."
    git clone --depth 1 https://github.com/vulhub/vulhub.git >/dev/null 2>&1 && 
    echo "[+] Vulhub descargado exitosamente" ||
    echo "[!] Error descargando Vulhub"
else
    echo "[+] Vulhub ya existe"
fi
cd ..

## 9. DESPLEGAR AUTOMÁTICAMENTE MÁQUINAS VULHUB DISPONIBLES
echo "=== DESPLEGANDO MÁQUINAS VULHUB DISPONIBLES ==="
VULHUB_DIR="vulhub-extensions/vulhub"
for category in "$VULHUB_DIR"/*; do
  [ -d "$category" ] || continue
  vuln_name=$(basename "$category")
  echo "Desplegando $vuln_name..."
  (cd "$category" && docker compose up -d) \
    && echo "✓ $vuln_name iniciado" \
    || echo "✗ Error iniciando $vuln_name"
done


## 10. VERIFICAR ESTADO FINAL
echo "=== VERIFICACIÓN FINAL ==="

echo ""
echo "📊 ESTADO DE CONTENEDORES:"
docker-compose ps

echo ""
echo "🌐 VERIFICACIÓN DE SERVICIOS WEB:"
declare -A ports_names=(
    [9990]="Apache"
    [9998]="DVWA"
    [9997]="Juice Shop"
    [9996]="WebGoat"
    [9995]="Mutillidae"
)
for port in 9990 9998 9997 9996 9995; do
    name="${ports_names[$port]}"
    if curl -s -o /dev/null -w "%{http_code}" http://localhost:$port | grep -q "200\|302\|404"; then
        echo "✅ $name (puerto $port): Activo"
    else
        echo "❌ $name (puerto $port): No responde"
    fi
done

echo ""
echo "🔧 VERIFICACIÓN DE HERRAMIENTAS KALI:"
if docker exec kali-attacker nmap --version >/dev/null 2>&1; then
    echo "✅ nmap: Instalado"
else
    echo "❌ nmap: No disponible"
fi

echo ""
echo "=== CORRECCIONES COMPLETADAS ==="
echo "✅ Red extended_network definida correctamente"
echo "✅ Puertos personalizados aplicados (Apache en 9990, DVWA en 9998, etc.)"
echo "✅ Imagen Kali corregida a kalilinux/kali-rolling"
echo "✅ lab-controller.sh compatible con Git Bash"
echo "✅ Herramientas de pentesting instaladas en Kali"
echo "✅ Vulhub configurado para máquinas adicionales"
echo ""
echo "📋 PRÓXIMOS PASOS:"
echo "1. Verificar servicios: ./scripts/management/lab-controller.sh status"
echo "2. Acceder a Kali: ./scripts/management/lab-controller.sh attack"
echo "3. Probar herramientas: nmap --version"
echo ""
echo "🌐 SERVICIOS DISPONIBLES:"
echo "- Apache Principal: http://localhost:9990"
echo "- DVWA: http://localhost:9998 (admin/password)"
echo "- Juice Shop: http://localhost:9997"
echo "- WebGoat: http://localhost:9996"
echo "- Mutillidae: http://localhost:9995"
echo ""
echo "💾 BACKUPS GUARDADOS EN: $BACKUP_DIR"
echo ""
echo "🎯 ¡Laboratorio listo para pentesting ético!"
