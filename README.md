# Apache Docker Project - Laboratorio de Penetration Testing v3.1

## Descripción

Laboratorio completo de pentesting con aplicaciones web vulnerables, herramientas de ataque y monitoreo integral, todo containerizado con Docker. Diseñado para práctica de hacking ético y aprendizaje de ciberseguridad de manera controlada.

## 🚀 Instalación rápida

### Prerrequisitos

- Docker Desktop instalado y ejecutándose
- Git instalado
- 8 GB de RAM recomendada
- 10 GB libres en disco
- Permisos de administrador para red y firewall

### Pasos

```bash
# 1. Clonar el proyecto
git clone https://github.com/JosephJMRG/apache-docker-project.git
cd apache-docker-project

# 2. Dar permisos a scripts (Linux/WSL)
chmod +x run.sh monitor-lab.sh cleanup-project.sh
chmod +x bin/*

# 3. Configuración inicial del entorno
./run.sh install

# 4. Iniciar el laboratorio completo
./run.sh start

# 5. Verificar el estado de los servicios
./run.sh status
```

> Si usas **Windows 11 Pro**, abre Git Bash o WSL, navega al repositorio y ejecuta los mismos comandos.  
> Para acceso básico sin scripts:  
> `docker-compose up -d` y `docker-compose ps`

## 🌐 Servicios y Puertos

| Servicio                  | URL                   | Puerto | Descripción                                       | Credenciales   |
| ------------------------- | --------------------- | ------ | ------------------------------------------------- | -------------- |
| **Apache (PwotoSite.cl)** | http://localhost:9990 | 9990   | Servidor web principal                            | -              |
| **DVWA**                  | http://localhost:9998 | 9998   | Damn Vulnerable Web App                           | admin/password |
| **OWASP Juice Shop**      | http://localhost:9997 | 9997   | Aplicación moderna vulnerable OWASP Top 10        | -              |
| **OWASP WebGoat**         | http://localhost:9996 | 9996   | Plataforma educativa con lecciones de seguridad   | -              |
| **OWASP Mutillidae**      | http://localhost:9995 | 9995   | Aplicación de práctica deliberadamente vulnerable | -              |
| **Kali Linux**            | (por terminal, shell) | -      | Herramientas de pentesting preinstaladas          | -              |

## 🛠️ Comandos principales

```bash
./run.sh install         # Configurar proyecto por primera vez
./run.sh start           # Iniciar todos los servicios
./run.sh stop            # Detener todo el laboratorio
./run.sh restart         # Reiniciar laboratorio
./run.sh status          # Ver estado y accesibilidad de los servicios
./run.sh kali            # Acceder a Kali Linux para pentesting
./run.sh logs [SERVICIO] # Ver logs (opcional: nombre del servicio)
./run.sh clean           # Limpiar todo el entorno y volúmenes
./run.sh backup          # Crear backup del laboratorio
./run.sh help            # Mostrar ayuda completa
```

Monitor de servicios en tiempo real:

```bash
./monitor-lab.sh
```

Controlador avanzado alternativo:

```bash
bin/lab-controller start
bin/lab-controller kali
bin/lab-controller status
```

## 🏗️ Estructura del proyecto

```
apache-docker-project/
├── bin/                  # Scripts automatizados de gestión del lab
├── config/               # Configuración de Apache, apps, red y Docker
├── data/                 # Carpeta para logs, backups, uploads, volúmenes
├── docs/                 # Documentación técnica y guías de laboratorio
├── tools/                # Scripts/herramientas adicionales (opcional)
├── www/                  # Sitio PwotoSite.cl (html, logs, recursos)
├── docker-compose.yml    # Orquestación principal de servicios
├── Dockerfile            # Imagen de Apache personalizada
├── .env                  # Configuración central de variables y puertos
├── run.sh                # Script principal TODO EN UNO
├── monitor-lab.sh        # Monitor de servicios CLI
├── cleanup-project.sh    # Limpieza y reorganización del proyecto
└── README.md             # (Este archivo)
```

## 🎯 Comenzar con el pentesting

1. Asegúrate de que todos los contenedores estén “Up”:

   ```bash
   ./run.sh status
   ```

2. Prueba cada servicio desde tu navegador:

   - Apache: http://localhost:9990
   - DVWA: http://localhost:9998 (**usuario:** admin, **password:** password)
   - Juice Shop: http://localhost:9997
   - WebGoat: http://localhost:9996
   - Mutillidae: http://localhost:9995

3. Accede a Kali Linux:

   ```bash
   ./run.sh kali
   ```

   Ejecuta estos comandos luego de entrar a la máquina Kali

```bash
apt-get update
# luego
apt-get install -y nmap sqlmap nikto dirb
```

Algunos comandos de pentesting útiles:

```bash
nmap -sS -sV 192.168.90.0/24
sqlmap -u "http://localhost:9998/vulnerabilities/sqli/?id=1&Submit=Submit" --cookie="security=low; PHPSESSID=xxx" --dbs
nikto -h http://localhost:9997
dirb http://localhost:9997
```

## 🏢 Arquitectura y redes

- **DMZ (192.168.90.0/24):** Todos los servicios web vulnerables
- **LAN (192.168.1.0/24):** Bases de datos y servicios internos
- **Attacker Network (10.0.0.0/24):** Pentesting con Kali
- **Monitoring (172.20.0.0/24):** Logging y monitoreo

La segmentación de red y las reglas de firewall están preconfiguradas y documentadas en `config/network/`, `bin/setup-networks.sh` y en la documentación avanzada.

## ⚠️ Seguridad y advertencia

**¡Laboratorio con vulnerabilidades reales! Solo usar en entornos aislados o virtualizados.**

- 🚫 Nunca exponer a Internet
- 🔒 Sólo para investigación, práctica y educación
- ⚖️ Sigue siempre la ley y buenas prácticas

## 🐾 Documentación adicional

- **Guía de laboratorio y escenarios de pentesting:**  
  `docs/pentesting/lab-guide.md`

- **Documentación técnica completa:**  
  `docs/complete-documentation.md`

- **Arquitectura de red y seguridad:**  
  `docs/security/network-architecture.md`  
  `docs/security/security-guide.md`

- **Guía para Windows:**  
  `docs/windows-guide.md`

## 🦾 Troubleshooting

- Ver logs de contenedores:  
  `docker-compose logs [servicio]`
- Limpiar y resetear entorno:  
  `./run.sh clean`
- Reset de redes docker:  
  `bin/setup-networks.sh`

- Si algún servicio no inicia, revisa:
  - Que Docker esté ejecutándose correctamente
  - No haya conflicto de puertos
  - Suficiente RAM/disco disponible

## 🤝 Contribución

1. Haz _fork_ del repo
2. Crea una rama: `git checkout -b feature/mi-mejora`
3. Haz _commit_ a tus cambios
4. _Push_ a tu rama
5. Abre un Pull Request

## 📄 Licencia

MIT License.  
**Solo para formación y prácticas de ciberseguridad ética.**

##### Apache Docker Project v3.1 - by JosephJMRG, Última actualización: Julio 2025

##### [Derechos reservados - solo uso educativo y con autorización]
