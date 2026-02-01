#!/bin/bash
# Verifica conectividade entre clusters antes de aplicar as correções

echo "=== 1. Verificando rede Docker net-shared ==="
docker network inspect net-shared 2>/dev/null | grep -A2 "apps-control-plane\|observability-control-plane" || echo "Rede net-shared não encontrada. Execute: bash docker-networks.sh"

echo ""
echo "=== 2. IPs dos control-planes na net-shared ==="
docker inspect apps-control-plane 2>/dev/null | grep -A5 '"net-shared"' | grep IPAddress || echo "apps-control-plane não conectado"
docker inspect observability-control-plane 2>/dev/null | grep -A5 '"net-shared"' | grep IPAddress || echo "observability-control-plane não conectado"

echo ""
echo "=== 3. Teste: node-exporter no apps (porta 31000) responde? ==="
curl -s --connect-timeout 2 http://localhost:31000/metrics 2>/dev/null | head -2 || echo "FALHOU - acesse do host. Se falhar, node-exporter pode não estar rodando"

echo ""
echo "=== 4. Teste: pod no observability alcança 172.28.0.2:31000? ==="
kubectl --context kind-observability run test-curl --rm -i --restart=Never --image=curlimages/curl -- curl -s --connect-timeout 3 http://172.28.0.2:31000/metrics 2>/dev/null | head -2 || echo "FALHOU - pods não alcançam a rede Docker. Prometheus precisa de hostNetwork."

echo ""
echo "Se o teste 4 falhou, execute: bash docker-networks.sh"
echo "Depois aplique: kubectl --context kind-observability apply -f obs-prometheus.yaml"
echo "E reinicie: kubectl --context kind-observability -n observability rollout restart deployment/prometheus"
