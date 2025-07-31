# Evidencias del Servidor Apache con Docker

## Información del Proyecto
- **Proyecto**: Servidor Web Apache con Virtual Host
- **Sistema Base**: Windows 11 Pro con Docker Desktop
- **Contenedor**: Ubuntu 20.04 con Apache HTTP Server
- **Fecha**: $(date)

## 1. Estructura del Proyecto Creada

### Directorios y Archivos
```
apache-docker-project/
├── Dockerfile                          # Configuración del contenedor
├── COMANDOS-WINDOWS.md                  # Guía para Windows 11
├── SEGURIDAD.md                        # Documentación de seguridad
├── config/
│   └── apache2.conf                    # Configuración principal Apache
├── scripts/
│   └── start-services.sh               # Script de inicio
├── sites-available/
│   └── PwotoSite.cl.conf            # Configuración virtual host
├── sites-enabled/                      # Enlaces simbólicos
└── www/
    └── PwotoSite.cl/
        ├── html/
        │   └── index.html              # Página web principal
        └── log/                        # Directorio para logs
```

### Permisos Configurados
- `/var/www/` con permisos 755
- Propietario: www-data:www-data
- Estructura de logs separada por sitio

## 2. Configuración de Apache

### Archivo httpd.conf Principal
- ServerTokens Prod (oculta versión)
- ServerSignature Off
- Headers de seguridad configurados
- Configuración de directorios segura
- Inclusión de virtual hosts

### Virtual Host PwotoSite.cl
```apache
<VirtualHost *:80>
    ServerName www.PwotoSite.cl
    ServerAlias PwotoSite.cl
    DocumentRoot /var/www/PwotoSite.cl/html
    ErrorLog /var/www/PwotoSite.cl/log/error.log
    CustomLog /var/www/PwotoSite.cl/log/requests.log combined
</VirtualHost>
```

## 3. Medidas de Seguridad Implementadas

### Headers de Seguridad HTTP
- X-Content-Type-Options: nosniff
- X-Frame-Options: DENY/SAMEORIGIN
- X-XSS-Protection: 1; mode=block
- Strict-Transport-Security (preparado para HTTPS)
- Content-Security-Policy

### Protección de Archivos
- Bloqueo de archivos .htaccess
- Bloqueo de archivos de backup
- Bloqueo de archivos de configuración
- Options -Indexes (sin listado de directorios)

### Configuración del Sistema
- Usuario/Grupo: www-data
- Permisos restrictivos en directorios
- Logs separados por sitio
- Configuración de módulos de seguridad

## 4. Firewall y Red

### Configuración de Red
- Puerto 80 expuesto
- Configuración para Windows 11 Pro
- Docker Desktop compatible

### Firewall (Windows 11)
- Windows Defender Firewall activo
- Reglas para Docker Desktop
- Puerto 80 permitido para contenedor

## 5. Comandos para Windows 11 Pro

### Construcción de la Imagen
```powershell
# En PowerShell como Administrador
cd C:\ruta\a\tu\proyecto\apache-docker-project
docker build -t apache-servidor .
```

### Ejecución del Contenedor
```powershell
# Ejecutar contenedor
docker run -d -p 80:80 --name mi-servidor-apache apache-servidor

# Verificar estado
docker ps
docker logs mi-servidor-apache
```

### Acceso al Sitio Web
- URL: http://localhost
- Virtual Host: PwotoSite.cl
- Página principal funcional

## 6. Verificación de Funcionamiento

### Pruebas Realizadas
1. ✓ Construcción exitosa de imagen Docker
2. ✓ Configuración de Apache válida
3. ✓ Virtual Host configurado correctamente
4. ✓ Permisos de archivos establecidos
5. ✓ Headers de seguridad activos
6. ✓ Logs funcionando correctamente

### Logs Generados
- `/var/www/PwotoSite.cl/log/error.log`
- `/var/www/PwotoSite.cl/log/requests.log`
- `/var/www/PwotoSite.cl/log/access_detailed.log`

## 7. Vulnerabilidades Mitigadas

1. **Information Disclosure**: Versión de Apache oculta
2. **Directory Traversal**: Configuración restrictiva de directorios
3. **XSS**: Headers de protección configurados
4. **Clickjacking**: X-Frame-Options implementado
5. **MIME Sniffing**: X-Content-Type-Options configurado
6. **Acceso no autorizado**: Archivos sensibles bloqueados

## 8. Portabilidad del Proyecto

### Backup y Transporte
```powershell
# Guardar imagen como archivo
docker save apache-servidor > apache-servidor.tar

# Cargar en otro sistema
docker load < apache-servidor.tar
```

### Compatibilidad
- ✓ Windows 11 Pro con Docker Desktop
- ✓ Windows 10 Pro con Docker Desktop
- ✓ Linux con Docker
- ✓ macOS con Docker Desktop

## Conclusión

El servidor Apache con virtual host ha sido configurado exitosamente usando Docker, implementando todas las medidas de seguridad requeridas y manteniendo la portabilidad completa del proyecto.

