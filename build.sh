#!/usr/bin/env sh
# Gera dist/unimed-litoral-keycloak-theme.jar (copiar para /opt/keycloak/providers/).
set -e
cd "$(dirname "$0")"
mkdir -p dist
rm -f dist/unimed-litoral-keycloak-theme.jar
jar cf dist/unimed-litoral-keycloak-theme.jar META-INF theme
echo "Gerado: dist/unimed-litoral-keycloak-theme.jar"
