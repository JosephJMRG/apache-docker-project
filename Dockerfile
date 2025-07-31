FROM ubuntu:20.04

ENV DEBIAN_FRONTEND=noninteractive

# Instalar Apache y dependencias
RUN apt-get update && \
    apt-get install -y apache2 curl vim net-tools && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

# Configurar Apache y crear directorios
RUN mkdir -p /var/www/PwotoSite.cl/html && \
    mkdir -p /var/www/PwotoSite.cl/log && \
    chown -R www-data:www-data /var/www/PwotoSite.cl

# Habilitar módulos
RUN a2enmod rewrite headers expires deflate

# Copiar configuración
COPY config/apache/apache2.conf /etc/apache2/apache2.conf
COPY config/apache/sites/PwotoSite.cl.conf /etc/apache2/sites-available/

# Configurar sitio y ServerName
RUN a2ensite PwotoSite.cl.conf && a2dissite 000-default.conf && \
    echo "ServerName localhost" >> /etc/apache2/apache2.conf

# Script de inicio mejorado
RUN echo '#!/bin/bash\n\
echo "🔐 Iniciando Apache Docker Project v3.1..."\n\
echo "Configurando permisos..."\n\
chown -R www-data:www-data /var/www/PwotoSite.cl\n\
chmod -R 755 /var/www/PwotoSite.cl\n\
echo "Verificando configuración..."\n\
apache2ctl configtest\n\
echo "Iniciando Apache..."\n\
exec apache2ctl -D FOREGROUND' > /usr/local/bin/start-apache.sh && \
    chmod +x /usr/local/bin/start-apache.sh

EXPOSE 80

HEALTHCHECK --interval=30s --timeout=10s --start-period=5s --retries=3 \
    CMD curl -f http://localhost/ || exit 1

CMD ["/usr/local/bin/start-apache.sh"]
