#!/bin/bash
# Script de restauración para el laboratorio de pentesting

if [ -z "$1" ]; then
  echo "Uso: $0 <ruta_backup>"
  exit 1
fi

BACKUP_DIR=$1

# Restaurar volúmenes
docker run --rm \
  -v pentest_lab_elastic-data:/data \
  -v $(pwd)/$BACKUP_DIR:/backup \
  alpine \
  sh -c "tar xzf /backup/elastic-data.tar.gz -C /data"

docker run --rm \
  -v pentest_lab_grafana-data:/data \
  -v $(pwd)/$BACKUP_DIR:/backup \
  alpine \
  sh -c "tar xzf /backup/grafana-data.tar.gz -C /data"

# Restaurar base de datos DVWA
cat $BACKUP_DIR/dvwa.sql | docker exec -i mysql-dvwa sh -c 'mysql -uroot -ppassword dvwa'

echo "Restauración completada desde $BACKUP_DIR"
