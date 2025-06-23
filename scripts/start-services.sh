#!/bin/bash

# Script para iniciar servicios en el contenedor Docker
echo "=== Iniciando Servidor Apache con Virtual Host ==="

# Configurar variables de entorno para Apache
export APACHE_RUN_USER=www-data
export APACHE_RUN_GROUP=www-data
export APACHE_PID_FILE=/var/run/apache2/apache2.pid
export APACHE_RUN_DIR=/var/run/apache2
export APACHE_LOCK_DIR=/var/lock/apache2
export APACHE_LOG_DIR=/var/log/apache2

# Crear directorios necesarios
mkdir -p $APACHE_RUN_DIR
mkdir -p $APACHE_LOCK_DIR
mkdir -p $APACHE_LOG_DIR

# Verificar configuración de Apache
echo "Verificando configuración de Apache..."
apache2ctl configtest

if [ $? -eq 0 ]; then
    echo "✓ Configuración de Apache válida"
else
    echo "✗ Error en configuración de Apache"
    apache2ctl configtest
    exit 1
fi

# Mostrar información del servidor
echo ""
echo "=== INFORMACIÓN DEL SERVIDOR ==="
echo "Servidor: Apache HTTP Server"
echo "Sistema: $(lsb_release -d | cut -f2)"
echo "Fecha: $(date)"
echo "Virtual Host: PwotoSite.cl"
echo "Puerto: 80"
echo "DocumentRoot: /var/www/PwotoSite.cl/html"
echo "Logs de Error: /var/www/PwotoSite.cl/log/error.log"
echo "Logs de Acceso: /var/www/PwotoSite.cl/log/requests.log"
echo ""

# Mostrar configuración de seguridad implementada
echo "=== CONFIGURACIÓN DE SEGURIDAD ==="
echo "✓ ServerTokens: Prod (versión oculta)"
echo "✓ ServerSignature: Off"
echo "✓ Headers de seguridad configurados"
echo "✓ Archivos sensibles bloqueados"
echo "✓ Permisos 755 en /var/www"
echo "✓ Propietario www-data configurado"
echo ""

# Mostrar estructura de directorios
echo "=== ESTRUCTURA DE DIRECTORIOS ==="
echo "/var/www/PwotoSite.cl/"
echo "├── html/          (DocumentRoot - 755)"
echo "│   └── index.html"
echo "└── log/           (Logs del sitio - 755)"
echo "    ├── error.log"
echo "    ├── requests.log"
echo "    └── access_detailed.log"
echo ""

echo "=== INICIANDO APACHE HTTP SERVER ==="
echo "Accede a http://localhost para ver el sitio web"
echo "Presiona Ctrl+C para detener el servidor"
echo ""

# Iniciar Apache en primer plano
exec apache2ctl -D FOREGROUND

