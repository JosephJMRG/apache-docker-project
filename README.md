# README - Servidor Apache con Docker para Windows 11 Pro

## 🚀 Proyecto Completo Listo para Usar

Este proyecto contiene todo lo necesario para levantar un servidor Apache con virtual host usando Docker en Windows 11 Pro.

## 📁 Archivos Incluidos

### Documentación Principal
- **`DOCUMENTACION-COMPLETA.md`** - Documentación completa con evidencias
- **`DOCUMENTACION-COMPLETA.pdf`** - Versión PDF para entrega
- **`COMANDOS-WINDOWS.md`** - Guía específica para Windows 11
- **`SEGURIDAD.md`** - Medidas de seguridad implementadas
- **`EVIDENCIAS.md`** - Resumen de evidencias del proyecto

### Configuraciones
- **`Dockerfile`** - Configuración del contenedor Docker
- **`config/apache2.conf`** - Configuración principal de Apache
- **`sites-available/PwotoSite.cl.conf`** - Virtual host configurado
- **`scripts/start-services.sh`** - Script de inicio automatizado

### Contenido Web
- **`www/PwotoSite.cl/html/index.html`** - Página web principal
- **`www/PwotoSite.cl/log/`** - Directorio para logs

### Evidencias Visuales
- **`screenshots/estructura-proyecto.png`** - Estructura de directorios
- **`screenshots/docker-build.png`** - Construcción de imagen
- **`screenshots/docker-run.png`** - Ejecución del contenedor
- **`screenshots/sitio-web.png`** - Sitio web funcionando
- **`screenshots/configuracion-seguridad.png`** - Verificación de seguridad

## 🛠️ Instrucciones para Windows 11 Pro

### 1. Preparar el Entorno
```powershell
# Asegúrate de tener Docker Desktop instalado y ejecutándose
# Abre PowerShell como Administrador
# Navega al directorio del proyecto
cd C:\ruta\a\tu\proyecto\apache-docker-project
```

### 2. Construir la Imagen
```powershell
docker build -t apache-servidor .
```

### 3. Ejecutar el Contenedor
```powershell
docker run -d -p 80:80 --name mi-servidor-apache apache-servidor
```

### 4. Verificar Funcionamiento
```powershell
# Ver contenedores activos
docker ps

# Ver logs del servidor
docker logs mi-servidor-apache

# Acceder al sitio web
# Abrir navegador en: http://localhost
```

## ✅ Características Implementadas

### Servidor Linux
- ✅ Ubuntu 20.04 en contenedor Docker
- ✅ Apache HTTP Server instalado y configurado
- ✅ Interfaz de red configurada (puerto 80)

### Configuración Apache
- ✅ Virtual host para PwotoSite.cl
- ✅ DocumentRoot: `/var/www/PwotoSite.cl/html`
- ✅ Logs separados: `/var/www/PwotoSite.cl/log`
- ✅ Configuración httpd.conf personalizada

### Seguridad
- ✅ Headers de seguridad HTTP
- ✅ Protección de archivos sensibles
- ✅ ServerTokens Prod (versión oculta)
- ✅ Permisos 755 en /var/www
- ✅ Usuario www-data configurado

### Firewall
- ✅ Configuración automática en Windows 11
- ✅ Puerto 80 habilitado
- ✅ Reglas persistentes

### Estructura de Directorios
- ✅ `/var/www/PwotoSite.cl/html` (DocumentRoot)
- ✅ `/var/www/PwotoSite.cl/log` (Logs)
- ✅ Sites-available y sites-enabled
- ✅ Permisos correctos (755)

## 🔧 Comandos Útiles

### Gestión del Contenedor
```powershell
# Detener
docker stop mi-servidor-apache

# Iniciar
docker start mi-servidor-apache

# Reiniciar
docker restart mi-servidor-apache

# Eliminar
docker rm mi-servidor-apache
```

### Diagnóstico
```powershell
# Acceder al contenedor
docker exec -it mi-servidor-apache /bin/bash

# Ver configuración Apache
docker exec mi-servidor-apache apache2ctl configtest

# Ver logs en tiempo real
docker logs -f mi-servidor-apache
```

### Backup y Transporte
```powershell
# Exportar imagen
docker save apache-ser8 idor.tar

# Importar imagen
docker load < apache-servidor.tar
```

## 📋 Verificación de Funcionamiento

1. **Construcción exitosa**: Imagen Docker creada sin errores
2. **Contenedor ejecutándose**: `docker ps` muestra el contenedor activo
3. **Sitio web accesible**: http://localhost muestra la página
4. **Configuración válida**: `apache2ctl configtest` retorna "Syntax OK"
5. **Headers de seguridad**: Verificables con `curl -I localhost`
6. **Logs funcionando**: Archivos de log generándose correctamente

## 🎯 Entregables

- ✅ Proyecto Docker completo y funcional
- ✅ Documentación con capturas de pantalla
- ✅ Explicación de cada comando ejecutado
- ✅ Configuración de seguridad implementada
- ✅ Estructura de directorios según especificaciones
- ✅ Virtual host configurado y probado
- ✅ Proyecto portable para Windows 11 Pro

## 📞 Soporte

Si encuentras algún problema:

1. Verifica que Docker Desktop esté ejecutándose
2. Asegúrate de ejecutar PowerShell como Administrador
3. Revisa los logs con `docker logs mi-servidor-apache`
4. Consulta la documentación completa en `DOCUMENTACION-COMPLETA.pdf`

---

**¡Proyecto listo para usar en Windows 11 Pro!** 🎉

