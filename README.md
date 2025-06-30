# 🎯 Apache Docker Project + Vulhub - Laboratorio Completo de Penetration Testing

[![Docker](https://img.shields.io/bo/badge.shields.io/badge/Securitycripción

**Laboratorio completo de penetration testing** que combina aplicaciones web vulnerables con máquinas virtuales adicionales para entrenamientos comprehensivos en ciberseguridad ética. Incluye:

- 🌐 **Aplicaciones Web Vulnerables**: DVWA, Juice Shop, WebGoat, Mutillidae
- 🖥️ **Máquinas Virtuales Adicionales**: Vulhub con 500+ entornos vulnerables
- 🔒 **Segmentación de Red Avanzada**: DMZ, LAN, redes de atacantes y extendida
- 📊 **Monitoreo Integrado**: ELK Stack + Prometheus/Grafana
- 🤖 **Automatización Completa**: Scripts para despliegue y gestión

## 🏗️ Arquitectura Actualizada

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
└─────────────────────────────────────────────────────────┘
│
▼
┌─────────────────────────────────────────────────────────┐
│                     LAN Network (192.168.1.0/24)       │
│  ┌─────────────┐  ┌─────────────┐  ┌─────────────┐     │
│  │   MySQL     │  │  Monitoring │  │   Kali      │     │
│  │ Vulnerable  │  │   Services  │  │  Attacker   │     │
│  └─────────────┘  └─────────────┘  └─────────────┘     │
└─────────────────────────────────────────────────────────┘
│
▼
┌─────────────────────────────────────────────────────────┐
│              Extended Network (192.168.100.0/24)       │
│  ┌─────────────┐  ┌─────────────┐  ┌─────────────┐     │
│  │ Metasploita │  │ Ubuntu Vuln │  │ Windows Svr │     │
│  │   :2223     │  │   :2224     │  │   :3390     │     │
│  └─────────────┘  └─────────────┘  └─────────────┘     │
└─────────────────────────────────────────────────────────┘
```

## 🚀 Inicio Rápido

### Prerrequisitos
- **Docker Desktop** 20.10+ & **Docker Compose** 2.0+
- **8 GB RAM** mínimo (16 GB recomendado)
- **20 GB** espacio libre en disco
- Puertos **8080, 3000, 8081, 8082, 2222** disponibles

### Instalación Automatizada (Recomendada)

```bash
# 1. Clonar repositorio
git clone https://github.com/JosephJMRG/apache-docker-project.git
cd apache-docker-project

# 2. Dar permisos de ejecución
chmod +x automatizar_lab_completo.sh

# 3. Ejecutar automatización completa
./automatizar_lab_completo.sh
```

### Instalación en Windows 11

```powershell
# Como Administrador - Habilitar WSL 2
dism.exe /online /enable-feature /featurename:Microsoft-Windows-Subsystem-Linux /all /norestart
dism.exe /online /enable-feature /featurename:VirtualMachinePlatform /all /norestart
shutdown /r /t 0

# Después del reinicio - Ejecutar script principal
./automatizar_lab_completo.sh
```

## 🎯 Servicios del Laboratorio

| Servicio | URL | Credenciales | Descripción |
|----------|-----|--------------|-------------|
| **Apache Principal** | http://localhost:8080 | - | Servidor web principal |
| **DVWA** | http://localhost:8080 | admin/password | App web vulnerable |
| **Juice Shop** | http://localhost:3000 | - | OWASP Top 10 |
| **WebGoat** | http://localhost:8081 | - | Entrenamiento OWASP |
| **Mutillidae** | http://localhost:8082 | - | Multi-vulnerabilidades |
| **Kibana** | http://localhost:5601 | - | Visualización de logs |
| **Grafana** | http://localhost:3001 | admin/admin | Métricas y monitoreo |

## 🔧 Gestión del Laboratorio

```bash
# Controlador principal (nuevo)
./scripts/management/lab-controller.sh [comando]

# Comandos disponibles:
start       # Iniciar laboratorio completo
stop        # Detener laboratorio
status      # Ver estado de todos los servicios
attack      # Acceder a Kali Linux
logs        # Ver logs del sistema
cleanup     # Limpiar entorno completo
vulhub      # Gestionar máquinas Vulhub
```

### Gestión de Máquinas Vulhub

```bash
# Ver categorías disponibles
./scripts/management/deploy-vulhub.sh

# Desplegar vulnerabilidad específica
./scripts/management/deploy-vulhub.sh apache CVE-2021-41773

# Ver entornos activos
./scripts/management/deploy-vulhub.sh --list-active

# Limpiar entornos Vulhub
./scripts/management/deploy-vulhub.sh --cleanup
```

## 🎯 Escenarios de Pentesting

### Niveles Integrados

| Nivel | Tipo de Ataque | Herramientas |
|-------|----------------|--------------|
| **Básico** | Web Vulnerabilities | SQLMap, Nikto, Dirb |
| **Intermedio** | Network Exploitation | Metasploit, Nmap avanzado |
| **Avanzado** | Red Team Operations | Cobalt Strike, Custom Exploits |
| **Extendido (Vulhub)** | OS-Level Vulnerabilities | Kernel Exploits, Service Vulns |

### Comandos de Pentesting

```bash
# Escaneo de red extendida
nmap -sn 192.168.100.0/24

# Explotación de servicio Windows
msfconsole -q -x "use exploit/windows/smb/ms17_010_eternalblue; set RHOSTS 192.168.100.12; run"

# Análisis de vulnerabilidades con Vulhub
./scripts/management/lab-controller.sh vulhub spring
```

## 🛠️ Configuración Avanzada

### Despliegue Manual de Vulhub

```bash
cd vulhub-extensions/vulhub/apache/CVE-2021-41773
docker compose up -d
```

### Redes Personalizadas
Editar `configs/security/network-config.yml`:
```yaml
networks:
  extended_network:
    subnet: 192.168.200.0/24  # Personalizar subnet extendida
```

## 🔍 Troubleshooting

### Soluciones Comunes

**Error "ports are not available":**
```powershell
# Solución 1: Detener IIS
Stop-Service -Name 'W3SVC' -Force
Stop-Service -Name 'WAS' -Force

# Solución 2: Reiniciar WinNAT
net stop winnat
net start winnat
```

**Problemas con Vulhub:**
```bash
# Verificar redes Docker
docker network ls

# Conectar contenedor a red específica
docker network connect lab_extended_network [contenedor]
```

## ⚠️ Advertencias de Seguridad

### 🔴 IMPORTANTE - SOLO PARA LABORATORIO

- Contiene **vulnerabilidades REALES** en aplicaciones y sistemas operativos
- **NUNCA exponer a internet** - Mantener en red local aislada
- **Limpiar entornos después de usar** con `./scripts/management/lab-controller.sh cleanup`
- **Reportar vulnerabilidades críticas** siguiendo políticas de divulgación responsable

### Consideraciones Legales Actualizadas
- **Autorización requerida** para cualquier prueba fuera del laboratorio
- **Registrar todas las actividades** con fines de documentación
- **No almacenar datos reales** en los sistemas vulnerables
- **Responsabilidad del usuario** por uso indebido

## 📄 Licencia y Contribución

**Licencia:** MIT - Solo para uso educativo y ético en ciberseguridad.

**Contribuir:**
```bash
1. Fork el repositorio
2. Crear branch: git checkout -b feature/nueva-vulnerabilidad
3. Commit cambios: git commit -am 'Agregar CVE-XXXX-XXXX'
4. Push al branch: git push origin feature/nueva-vulnerabilidad
5. Crear Pull Request con documentación detallada
```

**Soporte:** [GitHub Issues](https://github.com/JosephJMRG/apache-docker-project/issues)

**Autor:** JosephJMRG | **Versión:** 3.0 | **Última actualización:** Junio 2025
