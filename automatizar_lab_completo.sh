#!/bin/bash
# SCRIPT AUTOMATIZADO COMPLETO PARA APACHE DOCKER PROJECT
# Incluye soluciones de puerto 80 y despliegue de Vulhub
# Compatible con Git Bash en Windows

echo "=== APACHE DOCKER PROJECT + VULHUB - AUTOMATIZACIÓN COMPLETA ==="

## 1. VERIFICACIÓN DE REQUISITOS
echo "=== VERIFICANDO REQUISITOS DEL SISTEMA ==="
if ! command -v docker &> /dev/null; then
    echo "[-] Docker no está instalado. Por favor instálelo primero."
    exit 1
fi

if ! command -v git &> /dev/null; then
    echo "[-] Git no está instalado."
    exit 1
fi

echo "[+] Docker y Git encontrados correctamente"

## 2. SOLUCIÓN DE CONFLICTOS DE PUERTO 80
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

## 3. CONFIGURAR ENTORNO PARA GIT BASH
echo "=== CONFIGURANDO ENTORNO GIT BASH ==="
export MSYS_NO_PATHCONV=1
export COMPOSE_CONVERT_WINDOWS_PATHS=1

if [[ "$OSTYPE" == "msys" ]]; then
    echo "[+] Configurando winpty para Docker en Git Bash"
    alias docker="winpty docker"
    alias docker-compose="winpty docker-compose"
fi

## 4. VERIFICAR DOCKER DESKTOP
echo "=== VERIFICANDO DOCKER DESKTOP ==="
if ! docker info &> /dev/null; then
    echo "[-] Docker Desktop no está corriendo."
    echo "    Por favor inicia Docker Desktop y vuelve a ejecutar este script."
    exit 1
fi
echo "[+] Docker Desktop está funcionando"

## 5. CONFIGURAR LABORATORIO PRINCIPAL
echo "=== CONFIGURANDO LABORATORIO PRINCIPAL ==="

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

## 6. INICIAR LABORATORIO PRINCIPAL
echo "=== INICIANDO LABORATORIO PRINCIPAL ==="

if [[ "$OSTYPE" == "msys" ]]; then
    winpty docker-compose up -d
else
    docker-compose up -d
fi

## 7. VERIFICAR ESTADO
echo "=== VERIFICANDO ESTADO DE CONTENEDORES ==="
sleep 15

if [[ "$OSTYPE" == "msys" ]]; then
    winpty docker ps
else
    docker ps
fi

## 8. CONFIGURAR VULHUB
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
else
    echo "[+] Vulhub ya existe"
fi

## 9. INFORMACIÓN DE ACCESO
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
echo "🔄 RESTAURAR SERVICIOS IIS (después del laboratorio):"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "powershell: Start-Service -Name 'W3SVC'; Start-Service -Name 'WAS'"
echo ""
echo "¡El laboratorio está listo para pentesting ético! 🎯"
