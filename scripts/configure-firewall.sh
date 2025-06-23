#!/bin/bash

# Script para configurar firewall UFW en Ubuntu
echo "=== Configurando Firewall UFW ==="

# Habilitar UFW
echo "y" | ufw enable

# Configurar reglas para HTTP
echo "Configurando reglas para HTTP..."
ufw allow 80/tcp
ufw allow 'Apache'

# Mostrar estado del firewall
echo "=== Estado del Firewall ==="
ufw status verbose

echo "✓ Firewall UFW configurado correctamente con reglas para HTTP"

