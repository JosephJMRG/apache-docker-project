# Apache Docker Project - Laboratorio de Penetración Testing

[![Docker](https://img.shields.io/badge/Docker-20.10+-blue)](https://www.docker.com/)
[![License](https://img.shields.io/badge/License-MIT-green)](LICENSE)
[![Security](https://img.shields.io/badge/Security-Educational%20Only-red)](SECURITY.md)

## 📋 Descripción

**Laboratorio completo de penetración testing** diseñado para entrenamiento en ciberseguridad ética. Incluye aplicaciones web vulnerables, segmentación de red y herramientas de monitoreo, todo ejecutándose en contenedores Docker.

### ✨ Características Principales

- 🌐 **Aplicaciones Vulnerables**: DVWA, Juice Shop, WebGoat, Mutillidae
- 🔒 **Segmentación de Red**: DMZ, LAN y redes de atacantes
- 📊 **Monitoreo**: ELK Stack + Prometheus/Grafana
- 🛡️ **Firewall**: Configuración automatizada con iptables
- 🔧 **Gestión**: Scripts para backup, restore y control completo

## 🏗️ Arquitectura


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
│  │   :80       │  │    :8080    │  │   :3000     │     │
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


## 🚀 Inicio Rápido

### Prerrequisitos
- **Docker Desktop** 20.10+ & **Docker Compose** 2.0+
- **8 GB RAM** mínimo (16 GB recomendado)
- **20 GB** espacio libre en disco
- Puertos **80, 8080, 3000, 8081, 8082, 2222, 21** disponibles

### Instalación


# 1. Clonar repositorio
git clone https://github.com/JosephJMRG/apache-docker-project.git
cd apache-docker-project

# 2. Dar permisos a scripts
chmod +x scripts/**/*.sh

# 3. Configurar e iniciar
sudo scripts/setup/setup-networks.sh
sudo scripts/setup/configure-firewall.sh
scripts/management/lab-controller.sh start


### Instalación en Windows 11

powershell
# Como Administrador - Habilitar WSL 2
dism.exe /online /enable-feature /featurename:Microsoft-Windows-Subsystem-Linux /all /norestart
dism.exe /online /enable-feature /featurename:VirtualMachinePlatform /all /norestart
shutdown /r /t 0

# Después del reinicio - Configurar firewall
New-NetFirewallRule -DisplayName "Apache HTTP" -Direction Inbound -Port 80 -Protocol TCP -Action Allow
New-NetFirewallRule -DisplayName "DVWA" -Direction Inbound -Port 8080 -Protocol TCP -Action Allow
New-NetFirewallRule -DisplayName "Juice Shop" -Direction Inbound -Port 3000 -Protocol TCP -Action Allow

# Iniciar laboratorio
cd apache-docker-project
.\scripts\management\lab-controller.sh start


## 🎯 Servicios del Laboratorio

| Servicio | URL | Credenciales | Descripción |
|----------|-----|--------------|-------------|
| **Apache (PwotoSite)** | http://localhost | - | Servidor web principal |
| **DVWA** | http://localhost:8080 | admin/password | App web vulnerable |
| **Juice Shop** | http://localhost:3000 | - | OWASP Top 10 |
| **WebGoat** | http://localhost:8081 | - | Entrenamiento OWASP |
| **Mutillidae** | http://localhost:8082 | - | Multi-vulnerabilidades |
| **Kibana** | http://localhost:5601 | - | Visualización de logs |
| **Grafana** | http://localhost:3001 | admin/admin | Métricas y monitoreo |

## 🔧 Gestión del Laboratorio


# Comandos principales
scripts/management/lab-controller.sh start     # Iniciar laboratorio
scripts/management/lab-controller.sh status    # Ver estado
scripts/management/lab-controller.sh attack    # Acceder a Kali Linux
scripts/management/lab-controller.sh logs      # Ver logs
scripts/management/lab-controller.sh stop      # Detener laboratorio

# Backup y restore
scripts/management/backup-lab.sh                           # Crear backup
scripts/management/restore-lab.sh ./backups/lab-backup-*   # Restaurar


## 🎯 Escenarios de Pentesting

### Nivel Básico

# Reconocimiento de red
nmap -sn 192.168.90.0/24
nmap -sS -sV 192.168.90.0/24

# Escaneo web básico
nikto -h http://192.168.90.10:8080
dirb http://192.168.90.10:8080

# SQL Injection
sqlmap -u "http://192.168.90.10:8080/vulnerabilities/sqli/?id=1" --dbs


### Nivel Avanzado
- Blind SQL Injection y XSS Persistente
- CSRF Attacks y File Upload Vulnerabilities
- Movimiento lateral y túneles SSH
- Custom Exploit Development

## 🛠️ Configuración Avanzada

### Modo Aislado

# Sin acceso a Internet
docker-compose -f configs/docker/docker-compose-isolated.yml up -d


### Red Personalizada
Editar `configs/security/network-config.yml`:
yaml
networks:
  dmz_network:
    subnet: 192.168.90.0/24  # Personalizar subnet
  lan_network:
    subnet: 192.168.1.0/24   # Personalizar subnet


## 🔍 Troubleshooting

### Problemas Comunes

**Docker no inicia:**

systemctl status docker
sudo systemctl restart docker


**Problemas de red:**

docker network ls
scripts/setup/setup-networks.sh


**Contenedores no se conectan:**

docker exec kali-attacker ping 192.168.90.10
docker logs dvwa-target


## ⚠️ Advertencias de Seguridad

### 🔴 IMPORTANTE - SOLO PARA LABORATORIO

- Contiene **vulnerabilidades REALES**
- **NO usar en redes de producción**
- **Mantener aislado** de sistemas críticos
- Solo usar en entornos controlados y autorizados

### Consideraciones Legales
- Obtener **autorización escrita** antes de pruebas
- Respetar **leyes locales** de ciberseguridad
- No usar para **actividades maliciosas**
- Reportar vulnerabilidades reales **responsablemente**

## 📄 Licencia y Contribución

**Licencia:** MIT - Solo para uso educativo y ético en ciberseguridad.

**Contribuir:**
1. Fork el repositorio
2. Crear branch (`git checkout -b feature/nueva-funcionalidad`)
3. Commit cambios (`git commit -am 'Agregar funcionalidad'`)
4. Push al branch (`git push origin feature/nueva-funcionalidad`)
5. Crear Pull Request

**Soporte:** [GitHub Issues](https://github.com/JosephJMRG/apache-docker-project/issues)

---

**Autor:** JosephJMRG | **Versión:** 2.0 | **Última actualización:** Diciembre 2024
