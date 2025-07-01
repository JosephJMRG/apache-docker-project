#!/bin/bash
# fix-kali-docker-image.sh - Corrección de imagen Kali Linux en docker-compose.yml

echo "=== CORRIGIENDO IMAGEN KALI LINUX EN DOCKER-COMPOSE ==="

COMPOSE_FILE="docker-compose.yml"
BACKUP_FILE="docker-compose.yml.backup-$(date +%Y%m%d_%H%M%S)"

# Verificar que el archivo existe
if [ ! -f "$COMPOSE_FILE" ]; then
    echo "[-] Error: No se encontró $COMPOSE_FILE"
    exit 1
fi

# Crear backup
cp "$COMPOSE_FILE" "$BACKUP_FILE"
echo "[+] Backup creado: $BACKUP_FILE"

# Buscar y corregir la imagen de Kali
if grep -q "kalilinux/kali-linux-docker" "$COMPOSE_FILE"; then
    echo "[*] Imagen incorrecta detectada: kalilinux/kali-linux-docker"
    
    # Reemplazar imagen incorrecta por la correcta
    sed -i 's/kalilinux\/kali-linux-docker/kalilinux\/kali-rolling/g' "$COMPOSE_FILE"
    
    echo "[+] Imagen corregida a: kalilinux/kali-rolling"
    
    # Agregar instalación automática de herramientas
    echo "[*] Agregando instalación automática de herramientas de pentesting..."
    
    # Crear archivo temporal con configuración mejorada para Kali
    cat > temp_kali_config.txt << 'EOF'
  kali-attacker:
    image: kalilinux/kali-rolling
    container_name: kali-attacker
    networks:
      - dmz_network
      - lan_network
      - extended_network
    stdin_open: true
    tty: true
    privileged: true
    volumes:
      - ./logs/kali:/var/log
    command: |
      bash -c "
        apt-get update && 
        apt-get install -y nmap nikto dirb sqlmap curl wget net-tools hydra metasploit-framework dnsutils whois &&
        /bin/bash
      "
EOF

    # Reemplazar sección de kali-attacker si existe
    if grep -A 15 "kali-attacker:" "$COMPOSE_FILE" | grep -q "image:"; then
        # Usar awk para reemplazar la sección completa del servicio kali-attacker
        awk '
        /^  kali-attacker:/ {
            system("cat temp_kali_config.txt")
            # Skip hasta el próximo servicio o final
            while ((getline > 0) && !/^  [a-zA-Z]/ && !/^[a-zA-Z]/) { }
            if (/^  [a-zA-Z]/ || /^[a-zA-Z]/) {
                print
            }
            next
        }
        { print }
        ' "$COMPOSE_FILE" > "${COMPOSE_FILE}.tmp" && mv "${COMPOSE_FILE}.tmp" "$COMPOSE_FILE"
    fi
    
    rm -f temp_kali_config.txt
    echo "[+] Configuración de Kali mejorada aplicada"
    
else
    echo "[!] No se encontró la imagen incorrecta en $COMPOSE_FILE"
fi

# Verificar otras imágenes problemáticas comunes
echo "[*] Verificando otras posibles imágenes problemáticas..."

# Lista de correcciones comunes
declare -A image_corrections=(
    ["kalilinux/kali-linux-docker"]="kalilinux/kali-rolling"
    ["kalilinux/kali"]="kalilinux/kali-rolling"
    ["kali-linux"]="kalilinux/kali-rolling"
)

for incorrect_image in "${!image_corrections[@]}"; do
    correct_image="${image_corrections[$incorrect_image]}"
    if grep -q "$incorrect_image" "$COMPOSE_FILE"; then
        sed -i "s|$incorrect_image|$correct_image|g" "$COMPOSE_FILE"
        echo "[+] Corregido: $incorrect_image → $correct_image"
    fi
done

echo ""
echo "=== CORRECCIONES COMPLETADAS ==="
echo "✅ Imagen Kali corregida a: kalilinux/kali-rolling"
echo "✅ Backup guardado en: $BACKUP_FILE"
echo "✅ Herramientas de pentesting se instalarán automáticamente"
echo ""
echo "📋 PRÓXIMOS PASOS:"
echo "1. Ejecutar: docker-compose down"
echo "2. Ejecutar: docker-compose pull"
echo "3. Ejecutar: docker-compose up -d"
echo "4. Verificar: docker-compose ps"
echo ""
echo "🎯 HERRAMIENTAS QUE SE INSTALARÁN AUTOMÁTICAMENTE:"
echo "- nmap, nikto, dirb, sqlmap"
echo "- curl, wget, net-tools, hydra"
echo "- metasploit-framework"
echo "- dnsutils, whois"
