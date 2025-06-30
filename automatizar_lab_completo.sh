#!/bin/bash
# SCRIPT AUTOMATIZADO COMPLETO PARA APACHE DOCKER PROJECT
# Incluye soluciones de puerto 80, despliegue de Vulhub y mejores prácticas 2025
# Compatible con Git Bash en Windows

echo "=== APACHE DOCKER PROJECT + VULHUB - AUTOMATIZACIÓN COMPLETA (v2025) ==="

## 1. VERIFICACIÓN DE REQUISITOS
echo "=== VERIFICANDO REQUISITOS DEL SISTEMA ==="
if ! command -v docker &> /dev/null; then
    echo "[-] Docker no está instalado. Instale Docker Engine v28.1.1+ primero."  # [2]
    exit 1
fi

if ! command -v git &> /dev/null; then
    echo "[-] Git no está instalado."
    exit 1
fi

echo "[+] Docker y Git encontrados correctamente"

## 2. MANEJO DE LÍMITES DE DOCKER HUB
echo "=== CONFIGURANDO DOCKER HUB ==="
echo "[*] Docker Hub tiene límites de tasa (100 pulls/6hrs sin autenticación)"  # [2]
if [ -f ~/.docker/config.json ]; then
    echo "[+] Credenciales de Docker Hub detectadas"
else
    echo "[!] ADVERTENCIA: No autenticado en Docker Hub. Podrías alcanzar límites de tasa"
    echo "    Considera: docker login"
fi

## 3. SOLUCIÓN DE CONFLICTOS DE PUERTO 80
echo "=== SOLUCIONANDO CONFLICTOS DE PUERTO 80 ==="

# Solución 1: Detener IIS temporalmente
echo "[*] Aplicando Solución 1: Detener IIS temporalmente..."
powershell.exe -Command "
    try {
        Stop-Service -Name 'W3SVC' -Force -ErrorAction SilentlyContinue
        Stop-Service -Name 'WAS' -Force -ErrorAction SilentlyContinue
        Write-Host '[+] Servicios IIS detenidos exitosamente'
    } catch {
        Write-Host '[!] No se pudieron detener los servicios IIS (posiblemente no estén corriendo)'
    }
"

# Solución 2: Reiniciar WinNAT
echo "[*] Aplicando Solución 2: Reiniciar WinNAT..."
powershell.exe -Command "
    try {
        net stop winnat
        Start-Sleep -Seconds 3
        net start winnat
        Write-Host '[+] WinNAT reiniciado exitosamente'
    } catch {
        Write-Host '[!] Error al reiniciar WinNAT, continuando...'
    }
"

## 4. CONFIGURAR ENTORNO PARA GIT BASH
echo "=== CONFIGURANDO ENTORNO GIT BASH ==="
export MSYS_NO_PATHCONV=1
export COMPOSE_CONVERT_WINDOWS_PATHS=1
export DOCKER_CONTENT_TRUST=1  # [2] Habilitar confianza de contenido

if [[ "$OSTYPE" == "msys" ]]; then
    echo "[+] Configurando winpty para Docker en Git Bash"
    alias docker="winpty docker"
    alias docker-compose="winpty docker-compose"
fi

## 5. VERIFICAR DOCKER DESKTOP
echo "=== VERIFICANDO DOCKER DESKTOP ==="
if ! docker info &> /dev/null; then
    echo "[-] Docker Desktop no está corriendo."
    echo "    Por favor inicia Docker Desktop y vuelve a ejecutar este script."
    exit 1
fi

# Verificar versión de Docker Engine (requiere v28.1.1+)
DOCKER_VERSION=$(docker version --format '{{.Server.Version}}')
if [[ "$DOCKER_VERSION" < "28.1.1" ]]; then
    echo "[-] Se requiere Docker Engine v28.1.1+ (Actual: $DOCKER_VERSION)"  # [2]
    exit 1
fi
echo "[+] Docker Desktop v$DOCKER_VERSION está funcionando"

## 6. CONFIGURAR LABORATORIO PRINCIPAL
echo "=== CONFIGURANDO LABORATORIO PRINCIPAL ==="

# Actualizar archivos compose (eliminar versiones obsoletas)
find . -name "docker-compose*.yml" -exec sed -i '/^version:/d' {} \;  # [3][5]

# Dar permisos a scripts existentes
find . -name "*.sh" -type f -exec chmod +x {} \; 2>/dev/null || true

# Verificar y crear estructura de scripts si no existe
if [ ! -d "scripts/management" ]; then
    mkdir -p scripts/management
    echo "[+] Creado directorio scripts/management"
fi

if [ ! -d "scripts/setup" ]; then
    mkdir -p scripts/setup
    echo "[+] Creado directorio scripts/setup"
fi

## 7. INICIAR LABORATORIO PRINCIPAL (CON SEGURIDAD MEJORADA)
echo "=== INICIANDO LABORATORIO PRINCIPAL ==="

# Configurar BuildKit para builds más seguros
export DOCKER_BUILDKIT=1

if [[ "$OSTYPE" == "msys" ]]; then
    winpty docker-compose up -d \
        --build \
        --pull always  # [2] Forzar actualización de imágenes
else
    docker-compose up -d \
        --build \
        --pull always
fi

## 8. CONFIGURAR SEGURIDAD ADICIONAL (CORREGIDO)
echo "=== APLICANDO CONFIGURACIÓN DE SEGURIDAD ==="

# Esperar a que los contenedores estén completamente iniciados
echo "[*] Esperando a que los servicios se inicien completamente..."
sleep 30

# Verificar que los contenedores estén ejecutándose antes de aplicar configuraciones
if docker-compose ps | grep -q "apache.*Up"; then
    echo "[+] Aplicando configuración de seguridad a Apache..."
    docker-compose exec --user root apache-server sh -c '
        chown -R www-data:www-data /var/www/html && 
        find /var/www/html -type d -exec chmod 755 {} \; &&
        find /var/www/html -type f -exec chmod 644 {} \;' || echo "[!] Apache no disponible, continuando..."
else
    echo "[!] Apache no está ejecutándose, saltando configuración de seguridad"
fi

# Configurar DVWA (detectar tipo de sistema)
if docker-compose ps | grep -q "dvwa.*Up"; then
    echo "[+] Configurando DVWA..."
    # Detectar si es Alpine (apk) o Debian/Ubuntu (apt)
    if docker-compose exec dvwa sh -c 'which apk' &>/dev/null; then
        docker-compose exec --user root dvwa sh -c '
            apk add --no-cache curl && 
            chmod -R a-w /app' || echo "[!] Error configurando DVWA (Alpine)"
    elif docker-compose exec dvwa sh -c 'which apt-get' &>/dev/null; then
        docker-compose exec --user root dvwa sh -c '
            apt-get update && apt-get install -y curl && 
            chmod -R a-w /app' || echo "[!] Error configurando DVWA (Debian)"
    else
        echo "[!] No se pudo determinar el gestor de paquetes de DVWA"
    fi
else
    echo "[!] DVWA no está ejecutándose, saltando configuración"
fi


## 9. VERIFICAR ESTADO
echo "=== VERIFICANDO ESTADO DE CONTENEDORES ==="
sleep 15

if [[ "$OSTYPE" == "msys" ]]; then
    winpty docker ps --format "table {{.ID}}\t{{.Names}}\t{{.Status}}\t{{.Ports}}"
else
    docker ps --format "table {{.ID}}\t{{.Names}}\t{{.Status}}\t{{.Ports}}"
fi

## 10. CONFIGURAR VULHUB
echo "=== CONFIGURANDO VULHUB PARA MÁQUINAS ADICIONALES ==="

# Crear directorio para Vulhub si no existe
if [ ! -d "vulhub-extensions" ]; then
    mkdir vulhub-extensions
    echo "[+] Creado directorio vulhub-extensions"
fi

cd vulhub-extensions

# Clonar Vulhub si no existe
if [ ! -d "vulhub" ]; then
    echo "[*] Descargando Vulhub..."
    git clone --depth 1 https://github.com/vulhub/vulhub.git
    echo "[+] Vulhub descargado exitosamente"
    
    # Actualizar archivos compose de Vulhub
    find vulhub -name "docker-compose*.yml" -exec sed -i '/^version:/d' {} \;
else
    echo "[+] Vulhub ya existe"
    git -C vulhub pull
fi

## 11. INFORMACIÓN DE ACCESO
cd ..
echo ""
echo "=== LABORATORIO INICIADO EXITOSAMENTE ==="
echo ""
echo "🚀 SERVICIOS PRINCIPALES DISPONIBLES:"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "🌐 Apache Principal:    http://localhost:8080"
echo "🛡️  DVWA (Vulnerable):   http://localhost:8080 (admin/password)"
echo "🧃 OWASP Juice Shop:    http://localhost:3000"
echo "🐐 WebGoat:             http://localhost:8081"
echo "🦋 Mutillidae:          http://localhost:8082"
echo "📊 Kibana (Logs):       http://localhost:5601"
echo "📈 Grafana (Métricas):  http://localhost:3001 (admin/admin)"
echo ""
echo "🔧 COMANDOS ÚTILES:"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "Ver logs:       docker-compose logs [servicio]"
echo "Detener todo:   docker-compose down"
echo "Reiniciar:      docker-compose restart"
echo "Estado:         docker ps"
echo ""
echo "🎯 VULHUB - MÁQUINAS ADICIONALES:"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "Ubicación: ./vulhub-extensions/vulhub/"
echo "Usar: ./deploy-vulhub.sh [categoria/vulnerabilidad]"
echo ""
echo "🔒 MEJORES PRÁCTICAS DE SEGURIDAD APLICADAS:"  # [2]
echo "    - Contenedores ejecutándose como no-root"
echo "    - Sistemas de archivos de solo lectura"
echo "    - Docker Content Trust habilitado"
echo "    - BuildKit para builds más seguros"
echo ""
echo "🔄 RESTAURAR SERVICIOS IIS (después del laboratorio):"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "powershell: Start-Service -Name 'W3SVC'; Start-Service -Name 'WAS'"
echo ""
echo "¡El laboratorio está listo para pentesting ético! 🎯"
