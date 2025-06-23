# Comandos para Windows 11 Pro - Docker Desktop

## 1. Construir la imagen Docker
```powershell
# Abrir PowerShell como Administrador y navegar al directorio del proyecto
cd C:\ruta\a\tu\proyecto\apache-docker-project

# Construir la imagen
docker build -t apache-servidor .
```

## 2. Ejecutar el contenedor
```powershell
# Ejecutar el contenedor con puerto mapeado
docker run -d -p 80:80 --name mi-servidor-apache --privileged apache-servidor

# Verificar que está ejecutándose
docker ps
```

## 3. Verificar funcionamiento
```powershell
# Ver logs del contenedor
docker logs mi-servidor-apache

# Acceder al contenedor (opcional)
docker exec -it mi-servidor-apache /bin/bash
```

## 4. Acceder al sitio web
- Abrir navegador en Windows
- Ir a: http://localhost
- Debería mostrar la página de PwotoSite.cl

## 5. Comandos útiles para Windows
```powershell
# Detener el contenedor
docker stop mi-servidor-apache

# Iniciar el contenedor
docker start mi-servidor-apache

# Eliminar el contenedor
docker rm mi-servidor-apache

# Eliminar la imagen
docker rmi apache-servidor

# Ver todas las imágenes
docker images

# Ver todos los contenedores
docker ps -a
```

## 6. Backup y transporte
```powershell
# Guardar imagen como archivo
docker save apache-servidor > apache-servidor.tar

# Cargar imagen desde archivo
docker load < apache-servidor.tar
```

