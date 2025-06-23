
# Arquitectura de Red del Laboratorio de Penetración Testing

## Introducción

Este documento describe la arquitectura de red implementada en el laboratorio de penetración testing basado en el proyecto **apache-docker-project**. La arquitectura simula un entorno empresarial real con múltiples segmentos de red, aplicando principios de defensa en profundidad y segmentación de red.

## Diagrama de Arquitectura


┌─────────────────────────────────────────────────────────────────────────────────┐
│                           LABORATORIO DE PENETRACIÓN TESTING                    │
│                                                                                 │
│  ┌─────────────────┐    ┌─────────────────┐    ┌─────────────────┐              │
│  │   ATTACKER      │    │      DMZ        │    │      LAN        │              │
│  │   NETWORK       │    │    NETWORK      │    │    NETWORK      │              │
│  │  10.0.0.0/24    │    │ 192.168.90.0/24 │    │ 192.168.1.0/24  │              │
│  │                 │    │                 │    │                 │              │
│  │ ┌─────────────┐ │    │ ┌─────────────┐ │    │ ┌─────────────┐ │              │
│  │ │ Kali Linux  │ │◄───┤ │   Apache    │ │    │ │ MySQL DVWA  │ │              │
│  │ │   Attacker  │ │    │ │  PwotoSite  │ │    │ │  Database   │ │              │
│  │ │ 10.0.0.100  │ │    │ │192.168.90.5 │ │    │ │192.168.1.10 │ │              │
│  │ └─────────────┘ │    │ └─────────────┘ │    │ └─────────────┘ │              │
│  │                 │    │                 │    │                 │              │
│  │ ┌─────────────┐ │    │ ┌─────────────┐ │    │ ┌─────────────┐ │              │
│  │ │ Metasploit  │ │    │ │    DVWA     │ │    │ │ MySQL Vuln  │ │              │
│  │ │   Tools     │ │    │ │Web App Vuln │ │    │ │  Database   │ │              │
│  │ │ 10.0.0.101  │ │    │ │192.168.90.10│ │    │ │192.168.1.20 │ │              │
│  │ └─────────────┘ │    │ └─────────────┘ │    │ └─────────────┘ │              │
│  │                 │    │                 │    │                 │              │
│  │ ┌─────────────┐ │    │ ┌─────────────┐ │    │ ┌─────────────┐ │              │
│  │ │ Custom      │ │    │ │ Juice Shop  │ │    │ │ Internal    │ │              │
│  │ │ Tools       │ │    │ │  Web App    │ │    │ │ Services    │ │              │
│  │ │ 10.0.0.102  │ │    │ │192.168.90.15│ │    │ │192.168.1.30 │ │              │
│  │ └─────────────┘ │    │ └─────────────┘ │    │ └─────────────┘ │              │
│  │                 │    │                 │    │                 │              │
│  └─────────────────┘    │ ┌─────────────┐ │    └─────────────────┘              │
│                         │ │  WebGoat    │ │                                     │
│  ┌─────────────────┐    │ │  Web App    │ │    ┌─────────────────┐              │
│  │   MONITORING    │    │ │192.168.90.20│ │    │   FIREWALL      │              │
│  │ 172.20.0.0/24   │    │                 │    │                 │              │
│  │   NETWORK       │    │ └─────────────┘ │    │   RULES         │              │
│  │                 │    │ ┌─────────────┐ │    │ ┌─────────────┐ │              │
│  │ ┌─────────────┐ │    │ │ Mutillidae  │ │    │ │   iptables  │ │              │
│  │ │Elasticsearch│ │    │ │  Web App    │ │    │ │    Rules    │ │              │
│  │ │172.20.0.10  │ │    │ │192.168.90.25│ │    │ │   Manager   │ │              │
│  │ └─────────────┘ │    │ └─────────────┘ │    │ └─────────────┘ │              │
│  │                 │    │                 │    │                 │              │
│  │ ┌─────────────┐ │    │ ┌─────────────┐ │    │ ┌─────────────┐ │              │
│  │ │  Logstash   │ │    │ │SSH Honeypot │ │    │ │   Traffic   │ │              │
│  │ │172.20.0.20  │ │    │ │(Cowrie)     │ │    │ │  Analysis   │ │              │
│  │ └─────────────┘ │    │ │192.168.90.30│ │    │ │   Tools     │ │              │
│  │                 │    │ └─────────────┘ │    │ └─────────────┘ │              │
│  │ ┌─────────────┐ │    │                 │    │                 │              │
│  │ │   Kibana    │ │    │ ┌─────────────┐ │    └─────────────────┘              │
│  │ │172.20.0.30  │ │    │ │FTP Vulnerable│ │                                    │
│  │ └─────────────┘ │    │ │Server       │ │                                     │
│  │                 │    │ │192.168.90.35│ │                                     │
│  └─────────────────┘    │ └─────────────┘ │                                     │
│                         │                 │                                     │
│                         └─────────────────┘                                     │
└─────────────────────────────────────────────────────────────────────────────────┘

                                FLUJO DE TRÁFICO

    ┌─────────────┐         ┌─────────────┐         ┌─────────────┐
    │  ATACANTE   │ ──────► │     DMZ     │ ──────► │     LAN     │
    │ 10.0.0.0/24 │  ✓      │192.168.90.0 │  ✓*     │192.168.1.0  │
    └─────────────┘         └─────────────┘         └─────────────┘
                                   │                        │
                                   ▼                        ▼
                            ┌─────────────┐         ┌─────────────┐
                            │ MONITORING  │         │  FIREWALL   │
                            │172.20.0.0/24│         │   LOGGING   │
                            └─────────────┘         └─────────────┘

    Leyenda:
    ✓  = Acceso permitido
    ✓* = Acceso limitado (solo puertos específicos)
    ✗  = Acceso denegado



## Segmentos de Red

### 1. Red de Atacantes (Attacker Network)

**Rango de IP**: `10.0.0.0/24`
**Gateway**: `10.0.0.1`
**Propósito**: Alojar herramientas de penetración testing

#### Servicios Desplegados:

| Servicio | IP | Descripción | Herramientas |
| :-- | :-- | :-- | :-- |
| Kali Linux | 10.0.0.100 | Distribución principal para pentesting | Nmap, Metasploit, Burp Suite, SQLMap |
| Metasploit Console | 10.0.0.101 | Framework de explotación | Módulos de exploit, payloads, auxiliares |
| Custom Tools | 10.0.0.102 | Herramientas personalizadas | Scripts Python, exploits custom |

#### Características de Seguridad:

- **Acceso a Internet**: ✅ Permitido
- **Acceso a DMZ**: ✅ Permitido (todos los puertos)
- **Acceso a LAN**: ❌ **BLOQUEADO** por firewall
- **Acceso a Monitoring**: ❌ Restringido


### 2. Red DMZ (Demilitarized Zone)

**Rango de IP**: `192.168.90.0/24`
**Gateway**: `192.168.90.1`
**Propósito**: Alojar servicios web vulnerables accesibles desde el exterior

#### Servicios Desplegados:

| Servicio | IP | Puerto | Descripción | Nivel de Vulnerabilidad |
| :-- | :-- | :-- | :-- | :-- |
| Apache (PwotoSite.cl) | 192.168.90.5 | 80 | Servidor web principal | Bajo |
| DVWA | 192.168.90.10 | 8080 | Damn Vulnerable Web Application | Alto |
| Juice Shop | 192.168.90.15 | 3000 | OWASP Juice Shop | Alto |
| WebGoat | 192.168.90.20 | 8081 | OWASP WebGoat | Alto |
| Mutillidae | 192.168.90.25 | 8082 | OWASP Mutillidae | Muy Alto |
| SSH Honeypot | 192.168.90.30 | 2222 | Cowrie SSH Honeypot | Monitoreo |
| FTP Vulnerable | 192.168.90.35 | 21 | Servidor FTP inseguro | Alto |

#### Características de Seguridad:

- **Acceso a Internet**: ✅ Permitido
- **Acceso desde Atacantes**: ✅ Permitido (todos los puertos)
- **Acceso a LAN**: ✅ Limitado (solo MySQL puerto 3306)
- **Acceso a Monitoring**: ✅ Permitido (para logs)


### 3. Red LAN (Local Area Network)

**Rango de IP**: `192.168.1.0/24`
**Gateway**: `192.168.1.1`
**Propósito**: Alojar servicios internos críticos (bases de datos, servicios backend)

#### Servicios Desplegados:

| Servicio | IP | Puerto | Descripción | Datos Almacenados |
| :-- | :-- | :-- | :-- | :-- |
| MySQL DVWA | 192.168.1.10 | 3306 | Base de datos para DVWA | Usuarios, credenciales |
| MySQL Vulnerable | 192.168.1.20 | 3306 | Base de datos intencionalmente insegura | Datos financieros, PII |
| Internal Services | 192.168.1.30 | Varios | Servicios internos | Configuraciones, logs |

#### Características de Seguridad:

- **Acceso a Internet**: ❌ **BLOQUEADO** (red interna)
- **Acceso desde Atacantes**: ❌ **BLOQUEADO** por firewall
- **Acceso desde DMZ**: ✅ Limitado (solo puerto 3306)
- **Acceso a Monitoring**: ✅ Permitido (para logs)


### 4. Red de Monitoreo (Monitoring Network)

**Rango de IP**: `172.20.0.0/24`
**Gateway**: `172.20.0.1`
**Propósito**: Centralizar logging, monitoreo y análisis de seguridad

#### Servicios Desplegados:

| Servicio | IP | Puerto | Descripción | Función |
| :-- | :-- | :-- | :-- | :-- |
| Elasticsearch | 172.20.0.10 | 9200 | Motor de búsqueda y análisis | Almacenamiento de logs |
| Logstash | 172.20.0.20 | 5044 | Procesamiento de logs | Agregación y parsing |
| Kibana | 172.20.0.30 | 5601 | Visualización de datos | Dashboards y análisis |

#### Características de Seguridad:

- **Acceso a Internet**: ❌ **BLOQUEADO** (red interna)
- **Acceso desde todas las redes**: ✅ Permitido (solo para envío de logs)
- **Acceso de gestión**: ✅ Restringido a administradores


## Configuración de Firewall

### Matriz de Comunicación


┌─────────────────┬─────┬─────┬─────────────┬───────────┐
│ Desde \ Hacia   │ DMZ │ LAN │ Atacantes   │ Monitoreo │
├─────────────────┼─────┼─────┼─────────────┼───────────┤
│ DMZ             │ ✓   │ ✓*  │ ✗           │ ✓         │
│ LAN             │ ✓   │ ✓   │ ✗           │ ✓         │
│ Atacantes       │ ✓   │ ✗   │ ✓           │ ✗         │
│ Monitoreo       │ ✓   │ ✓   │ ✗           │ ✓         │
│ Internet        │ ✓   │ ✗   │ ✓           │ ✗         │
└─────────────────┴─────┴─────┴─────────────┴───────────┘

Leyenda:
✓  = Acceso permitido
✓* = Acceso limitado (puertos específicos)
✗  = Acceso denegado



### Reglas de Firewall Detalladas

#### Reglas para DMZ (Entrada)


# Permitir HTTP/HTTPS desde Internet
iptables -A INPUT -d 192.168.90.0/24 -p tcp --dport 80 -j ACCEPT
iptables -A INPUT -d 192.168.90.0/24 -p tcp --dport 443 -j ACCEPT

# Permitir aplicaciones web vulnerables
iptables -A INPUT -d 192.168.90.0/24 -p tcp --dport 8080 -j ACCEPT  # DVWA
iptables -A INPUT -d 192.168.90.0/24 -p tcp --dport 3000 -j ACCEPT  # Juice Shop
iptables -A INPUT -d 192.168.90.0/24 -p tcp --dport 8081 -j ACCEPT  # WebGoat
iptables -A INPUT -d 192.168.90.0/24 -p tcp --dport 8082 -j ACCEPT  # Mutillidae

# Permitir SSH al honeypot
iptables -A INPUT -d 192.168.90.0/24 -p tcp --dport 2222 -j ACCEPT

# Permitir FTP vulnerable
iptables -A INPUT -d 192.168.90.0/24 -p tcp --dport 21 -j ACCEPT
iptables -A INPUT -d 192.168.90.0/24 -p tcp --dport 30000:30009 -j ACCEPT



#### Reglas para LAN (Acceso Restrictivo)


# Permitir solo MySQL desde DMZ
iptables -A FORWARD -s 192.168.90.0/24 -d 192.168.1.0/24 -p tcp --dport 3306 -j ACCEPT

# Bloquear acceso directo desde atacantes a LAN
iptables -A FORWARD -s 10.0.0.0/24 -d 192.168.1.0/24 -j LOG --log-prefix "BLOCKED-ATTACK: "
iptables -A FORWARD -s 10.0.0.0/24 -d 192.168.1.0/24 -j DROP

# Permitir tráfico interno en LAN
iptables -A FORWARD -s 192.168.1.0/24 -d 192.168.1.0/24 -j ACCEPT



#### Reglas de Monitoreo y Logging


# Logging de conexiones sospechosas
iptables -A FORWARD -p tcp --dport 80 -j LOG --log-prefix "HTTP-ACCESS: "
iptables -A FORWARD -p tcp --dport 8080 -j LOG --log-prefix "DVWA-ACCESS: "
iptables -A FORWARD -p tcp --dport 3000 -j LOG --log-prefix "JUICE-SHOP: "
iptables -A FORWARD -p tcp --dport 2222 -j LOG --log-prefix "SSH-HONEYPOT: "

# Rate limiting para prevenir DDoS
iptables -A INPUT -p tcp --dport 80 -m limit --limit 25/minute --limit-burst 100 -j ACCEPT
iptables -A INPUT -p tcp --dport 8080 -m limit --limit 20/minute --limit-burst 50 -j ACCEPT



## Protocolos de Comunicación

### Protocolos Permitidos por Segmento

#### DMZ Network

- **HTTP (80)**: Apache, aplicaciones web
- **HTTPS (443)**: Conexiones seguras (si están configuradas)
- **HTTP Alt (8080, 3000, 8081, 8082)**: Aplicaciones vulnerables
- **SSH (2222)**: Honeypot SSH
- **FTP (21, 30000-30009)**: Servidor FTP vulnerable
- **ICMP**: Ping y diagnósticos de red


#### LAN Network

- **MySQL (3306)**: Solo desde DMZ
- **ICMP**: Comunicación interna
- **DNS (53)**: Resolución de nombres (interno)


#### Attacker Network

- **Todos los protocolos**: Hacia DMZ
- **HTTP/HTTPS**: Hacia Internet
- **SSH (22)**: Conexiones salientes
- **DNS (53)**: Resolución de nombres


#### Monitoring Network

- **Elasticsearch (9200)**: API y búsquedas
- **Logstash (5044)**: Ingesta de logs
- **Kibana (5601)**: Interfaz web de visualización
- **Syslog (514)**: Recepción de logs


## Configuración de Red Avanzada

### VLANs Virtuales

Aunque Docker no usa VLANs tradicionales, simula la segmentación mediante:


# Redes bridge personalizadas
docker network create --driver bridge \
  --subnet=192.168.90.0/24 \
  --gateway=192.168.90.1 \
  dmz_network

docker network create --driver bridge \
  --subnet=192.168.1.0/24 \
  --gateway=192.168.1.1 \
  --internal \
  lan_network

docker network create --driver bridge \
  --subnet=10.0.0.0/24 \
  --gateway=10.0.0.1 \
  attacker_network

docker network create --driver bridge \
  --subnet=172.20.0.0/24 \
  --gateway=172.20.0.1 \
  --internal \
  monitoring_network



### Routing y Gateway Configuration

#### DMZ Gateway (192.168.90.1)

- **Función**: Gateway principal para servicios públicos
- **Routing**: Permite salida a Internet, acceso limitado a LAN
- **NAT**: Configurado para traducción de direcciones


#### LAN Gateway (192.168.1.1)

- **Función**: Gateway interno para servicios críticos
- **Routing**: Solo comunicación interna y hacia monitoreo
- **Aislamiento**: Sin acceso directo a Internet


#### Attacker Gateway (10.0.0.1)

- **Función**: Gateway para herramientas de pentesting
- **Routing**: Acceso completo a DMZ, bloqueado hacia LAN
- **Internet**: Permitido para descargas de herramientas


#### Monitoring Gateway (172.20.0.1)

- **Función**: Gateway para servicios de monitoreo
- **Routing**: Recibe logs de todas las redes
- **Aislamiento**: Sin acceso a Internet


## DNS y Resolución de Nombres

### Configuración DNS


# DNS interno para el laboratorio
# /etc/hosts en cada contenedor

# DMZ Services
192.168.90.5    apache.lab pwotosite.cl
192.168.90.10   dvwa.lab
192.168.90.15   juiceshop.lab
192.168.90.20   webgoat.lab
192.168.90.25   mutillidae.lab
192.168.90.30   honeypot.lab
192.168.90.35   ftp.lab

# LAN Services
192.168.1.10    mysql-dvwa.lab
192.168.1.20    mysql-vuln.lab
192.168.1.30    internal.lab

# Attacker Tools
10.0.0.100      kali.lab attacker.lab
10.0.0.101      metasploit.lab
10.0.0.102      custom-tools.lab

# Monitoring Services
172.20.0.10     elasticsearch.lab
172.20.0.20     logstash.lab
172.20.0.30     kibana.lab



### Configuración de Resolución


# Configuración DNS en contenedores
nameserver 8.8.8.8          # DNS público para atacantes
nameserver 192.168.90.1     # DNS interno para DMZ
nameserver 192.168.1.1      # DNS interno para LAN
nameserver 172.20.0.1       # DNS interno para monitoreo



## QoS y Traffic Shaping

### Configuración de Bandwidth


# Limitación de ancho de banda por servicio
docker run --cpus="2.0" --memory="2g" vulnerables/web-dvwa
docker run --cpus="1.0" --memory="1g" bkimminich/juice-shop
docker run --cpus="4.0" --memory="4g" kalilinux/kali-rolling

# Traffic shaping con tc (Traffic Control)
tc qdisc add dev docker0 root handle 1: htb default 30
tc class add dev docker0 parent 1: classid 1:1 htb rate 100mbit
tc class add dev docker0 parent 1:1 classid 1:10 htb rate 50mbit ceil 80mbit
tc class add dev docker0 parent 1:1 classid 1:20 htb rate 30mbit ceil 50mbit
tc class add dev docker0 parent 1:1 classid 1:30 htb rate 20mbit ceil 30mbit



### Priorización de Tráfico


# Alta prioridad: Monitoreo y logs
tc filter add dev docker0 protocol ip parent 1:0 prio 1 u32 \
  match ip dst 172.20.0.0/24 flowid 1:10

# Media prioridad: Servicios web
tc filter add dev docker0 protocol ip parent 1:0 prio 2 u32 \
  match ip dst 192.168.90.0/24 flowid 1:20

# Baja prioridad: Herramientas de ataque
tc filter add dev docker0 protocol ip parent 1:0 prio 3 u32 \
  match ip src 10.0.0.0/24 flowid 1:30



## Monitoreo de Red

### Herramientas de Monitoreo

#### Network Monitoring


# Captura de tráfico en tiempo real
tcpdump -i docker0 -w network-capture.pcap

# Análisis de flujos de red
nfcapd -D -l /var/log/netflow -p 9995
nfdump -R /var/log/netflow -s record/bytes



#### Intrusion Detection


# Configuración de Suricata para detección
suricata -c /etc/suricata/suricata.yaml -i docker0 -D

# Reglas personalizadas para el laboratorio
alert tcp 10.0.0.0/24 any -> 192.168.1.0/24 any (msg:"Blocked attack to LAN"; sid:1000001;)
alert tcp any any -> 192.168.90.0/24 80 (msg:"HTTP attack detected"; sid:1000002;)



### Métricas de Red


# Estadísticas de interfaces
cat /proc/net/dev

# Conexiones activas
netstat -tulpn

# Estadísticas de firewall
iptables -L -n -v --line-numbers

# Análisis de tráfico por protocolo
ss -tuln



## Seguridad de Red

### Controles de Seguridad Implementados

#### Segmentación de Red

- **Micro-segmentación**: Cada servicio en su propia subred
- **Zero Trust**: Validación de cada conexión
- **Least Privilege**: Mínimos permisos necesarios


#### Detección y Prevención

- **IDS/IPS**: Suricata para detección de intrusiones
- **Honeypots**: SSH y FTP para detectar atacantes
- **Log Analysis**: ELK Stack para análisis centralizado


#### Controles de Acceso

- **Network ACLs**: Listas de control en cada segmento
- **Rate Limiting**: Prevención de ataques DDoS
- **Connection Tracking**: Monitoreo de estados de conexión


### Hardening de Red


# Configuración segura del kernel
echo 0 > /proc/sys/net/ipv4/ip_forward
echo 1 > /proc/sys/net/ipv4/icmp_echo_ignore_broadcasts
echo 1 > /proc/sys/net/ipv4/icmp_ignore_bogus_error_responses
echo 1 > /proc/sys/net/ipv4/tcp_syncookies

# Configuración de parámetros de red
sysctl -w net.ipv4.conf.all.accept_source_route=0
sysctl -w net.ipv4.conf.all.accept_redirects=0
sysctl -w net.ipv4.conf.all.log_martians=1



## Escenarios de Testing

### Scenarios por Nivel de Red

#### Nivel 2 (Data Link)

- **ARP Spoofing**: Envenenamiento de cache ARP
- **MAC Flooding**: Saturación de tabla MAC
- **VLAN Hopping**: Escape entre VLANs


#### Nivel 3 (Network)

- **IP Spoofing**: Falsificación de direcciones IP
- **Routing Attacks**: Manipulación de tablas de ruteo
- **ICMP Tunneling**: Túneles a través de ICMP


#### Nivel 4 (Transport)

- **Port Scanning**: Descubrimiento de servicios
- **TCP Hijacking**: Secuestro de sesiones TCP
- **UDP Flooding**: Ataques de inundación UDP


#### Nivel 7 (Application)

- **HTTP Attacks**: Ataques específicos de aplicación
- **DNS Poisoning**: Envenenamiento de cache DNS
- **SSL/TLS Attacks**: Ataques a protocolos seguros


## Troubleshooting de Red

### Comandos de Diagnóstico


# Verificar conectividad
ping -c 4 192.168.90.10
traceroute 192.168.1.20
mtr 172.20.0.30

# Verificar DNS
nslookup dvwa.lab
dig @8.8.8.8 pwotosite.cl

# Verificar puertos
nmap -p 80,8080,3000 192.168.90.0/24
telnet 192.168.90.10 8080

# Verificar routing
ip route show
route -n



### Problemas Comunes

#### Conectividad


# Verificar interfaces Docker
docker network ls
docker network inspect dmz_network

# Reiniciar networking
systemctl restart docker
systemctl restart networking



#### Firewall


# Verificar reglas
iptables -L DOCKER-USER -n -v
iptables -t nat -L -n -v

# Limpiar reglas problemáticas
iptables -F DOCKER-USER
iptables -X DOCKER-USER



#### DNS


# Verificar resolución
cat /etc/resolv.conf
systemd-resolve --status

# Reiniciar DNS
systemctl restart systemd-resolved



## Conclusión

La arquitectura de red del laboratorio de penetración testing proporciona un entorno realista y seguro para practicar técnicas de hacking ético. La segmentación de red, las reglas de firewall y los sistemas de monitoreo crean un escenario que simula fielmente un entorno empresarial real, permitiendo a los usuarios desarrollar habilidades prácticas en un entorno controlado y legal.

---

**Última actualización**: Diciembre 2024
**Versión**: 1.0
**Autor**: JosephJMRG
**Proyecto**: apache-docker-project

