# Usar Ubuntu como base (más compatible)
FROM ubuntu:20.04

# Evitar prompts interactivos durante la instalación
ENV DEBIAN_FRONTEND=noninteractive

# Actualizar sistema e instalar Apache
RUN apt-get update && \
    apt-get install -y apache2 && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

# Crear estructura de directorios
RUN mkdir -p /var/www/PwotoSite.cl/html && \
    mkdir -p /var/www/PwotoSite.cl/log && \
    mkdir -p /etc/apache2/sites-available && \
    mkdir -p /etc/apache2/sites-enabled

# Establecer permisos correctos (755 para www)
RUN chmod 755 /var/www && \
    chmod 755 /var/www/PwotoSite.cl && \
    chmod 755 /var/www/PwotoSite.cl/html && \
    chmod 755 /var/www/PwotoSite.cl/log && \
    chown -R www-data:www-data /var/www/PwotoSite.cl

# Copiar archivos de configuración
COPY config/apache2.conf /etc/apache2/apache2.conf
COPY sites-available/PwotoSite.cl.conf /etc/apache2/sites-available/
COPY www/PwotoSite.cl/html/ /var/www/PwotoSite.cl/html/
COPY scripts/start-services.sh /usr/local/bin/

# Hacer ejecutable el script
RUN chmod +x /usr/local/bin/start-services.sh

# Habilitar módulos de Apache necesarios
RUN a2enmod rewrite headers expires deflate

# Habilitar el sitio
RUN a2ensite PwotoSite.cl.conf && \
    a2dissite 000-default.conf

# Exponer puerto 80
EXPOSE 80

# Comando de inicio
CMD ["/usr/local/bin/start-services.sh"]

