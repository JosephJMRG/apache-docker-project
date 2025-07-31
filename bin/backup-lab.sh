#!/bin/bash
# Script de backup para el laboratorio de pentesting

# Fecha para el archivo de backup
TIMESTAMP=$(date +"%Y%m%d_%H%M")

# Directorio destino
BACKUP_DIR=./backups/$TIMESTAMP
mkdir -p $BACKUP_DIR

# Respaldar volúmenes Docker
docker run --rm \
  -v pentest_lab_elastic-data:/data \
  -v $(pwd)/$BACKUP_DIR:/backup \
  alpine \
  tar czf /backup/elastic-data.tar.gz -C /data .

docker run --rm \
  -v pentest_lab_grafana-data:/data \
  -v $(pwd)/$BACKUP_DIR:/backup \
  alpine \
  tar czf /backup/grafana-data.tar.gz -C /data .

# Exportar base de datos DVWA
docker exec mysql-dvwa mysqldump -uroot -ppassword dvwa > $BACKUP_DIR/dvwa.sql

echo "Backup completado en $BACKUP_DIR"
