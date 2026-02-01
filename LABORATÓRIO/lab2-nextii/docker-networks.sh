#!/bin/bash
# Cria redes Docker para o lab multi-cluster
# net-obs: cluster observability
# net-app: cluster apps  
# net-shared: rede compartilhada com IPs estáticos para comunicação entre clusters

set -e

# IPs fixos na rede compartilhada (evita host.docker.internal que não funciona no Kind)
APPS_IP="172.28.0.2"       # apps-control-plane
OBS_IP="172.28.0.3"        # observability-control-plane

echo "Criando redes Docker..."
docker network create net-obs 2>/dev/null || true
docker network create net-app 2>/dev/null || true

# Recria net-shared com subnet para IPs estáticos (host.docker.internal não funciona no Kind)
echo "Configurando rede compartilhada (net-shared) com IPs estáticos..."
docker network disconnect net-shared observability-control-plane 2>/dev/null || true
docker network disconnect net-shared apps-control-plane 2>/dev/null || true
docker network rm net-shared 2>/dev/null || true
docker network create --subnet 172.28.0.0/24 net-shared

echo "Conectando clusters às redes..."

# Cada cluster na sua rede principal
docker network connect net-obs observability-control-plane 2>/dev/null || true
docker network connect net-app apps-control-plane 2>/dev/null || true

# Ambos na rede compartilhada com IPs fixos
docker network connect --ip "$APPS_IP" net-shared apps-control-plane
docker network connect --ip "$OBS_IP" net-shared observability-control-plane

echo ""
echo "Redes configuradas:"
echo "  - net-obs: observability"
echo "  - net-app: apps"
echo "  - net-shared: ambos (IPs estáticos)"
echo "    - apps-control-plane: $APPS_IP"
echo "    - observability-control-plane: $OBS_IP"
echo ""
echo "Prometheus (obs) scrapeia: $APPS_IP:31000"
echo "Fluent Bit (apps) envia para: $OBS_IP:30001 (Loki), $OBS_IP:30002 (ES)"
