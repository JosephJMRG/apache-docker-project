# Configuraciones de Seguridad para Apache
# Este archivo documenta las medidas de seguridad implementadas

## 1. Ocultación de información del servidor
- ServerTokens Prod: Oculta la versión de Apache
- ServerSignature Off: Elimina la firma del servidor en páginas de error

## 2. Protección contra archivos sensibles
- Bloqueo de archivos .htaccess y .htpasswd
- Bloqueo de archivos de backup (.bak, .backup, .old, etc.)
- Bloqueo de archivos de configuración (.conf, .config, .ini)

## 3. Headers de seguridad HTTP
- X-Content-Type-Options: nosniff (previene MIME sniffing)
- X-Frame-Options: DENY/SAMEORIGIN (previene clickjacking)
- X-XSS-Protection: activa protección XSS del navegador
- Strict-Transport-Security: fuerza HTTPS (preparado para SSL)
- Content-Security-Policy: controla recursos que puede cargar la página

## 4. Configuración de directorios
- Options -Indexes: desactiva listado de directorios
- AllowOverride None: mejora rendimiento y seguridad
- Require all granted: acceso controlado

## 5. Protección específica del virtual host
- Bloqueo de archivos PHP (si no se necesitan)
- Logs detallados para análisis de seguridad
- Configuración de compresión y caché

## 6. Firewall (configurado en scripts)
- Reglas permanentes para puerto 80
- Servicio HTTP habilitado
- Configuración persistente tras reinicios

## 7. Permisos del sistema de archivos
- /var/www con permisos 755
- Propietario apache:apache para archivos web
- Separación de logs por sitio

## Vulnerabilidades mitigadas:
1. Information Disclosure (ocultación de versión)
2. Directory Traversal (configuración de directorios)
3. XSS (headers de seguridad)
4. Clickjacking (X-Frame-Options)
5. MIME Sniffing (X-Content-Type-Options)
6. Acceso no autorizado a archivos sensibles
7. DDoS básico (configuración de límites)

## Recomendaciones adicionales para producción:
1. Implementar SSL/TLS
2. Configurar fail2ban
3. Actualizar regularmente el sistema
4. Monitorear logs de seguridad
5. Implementar WAF (Web Application Firewall)

