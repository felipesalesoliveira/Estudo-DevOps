#!/bin/bash
# Deploy do lab em cluster ÚNICO (kind lab2)
# Comunicação via DNS interno - sem problemas de rede entre clusters

set -e
CTX="kind-lab2"

echo "=== Deploy Lab2 (cluster único) ==="
echo "Context: $CTX"
echo ""

# 1. Criar namespaces
echo "1. Criando namespaces..."
kubectl --context $CTX create namespace observability 2>/dev/null || true
kubectl --context $CTX create namespace logging 2>/dev/null || true
kubectl --context $CTX create namespace apps 2>/dev/null || true
kubectl --context $CTX create namespace monitoring 2>/dev/null || true

# 2. Observability (Loki, ES, Kibana, Grafana, Prometheus)
echo "2. Deploy observability..."
kubectl --context $CTX apply -f obs-elasticsearch.yaml
kubectl --context $CTX apply -f obs-loki.yaml
kubectl --context $CTX apply -f obs-kibana.yaml
kubectl --context $CTX apply -f obs-grafana.yaml
kubectl --context $CTX apply -f obs-prometheus.yaml

# 3. Apps (aplicações + node-exporter + fluentbit)
echo "3. Deploy apps..."
kubectl --context $CTX apply -f app-app-ok.yaml
kubectl --context $CTX apply -f app-app-error.yaml 2>/dev/null || true
kubectl --context $CTX apply -f app-traficgenerator.yaml 2>/dev/null || true
kubectl --context $CTX apply -f app-prometheusexporter.yaml
kubectl --context $CTX apply -f app-fluentbit.yaml

echo ""
echo "=== Aguardando pods subirem (30s) ==="
sleep 30

echo ""
echo "=== Status ==="
kubectl --context $CTX get pods -A | grep -E "observability|logging|apps|monitoring"

echo ""
echo "=== URLs ==="
echo "  Grafana:    http://localhost:30000 (admin/admin)"
echo "  Prometheus: http://localhost:30004/targets"
echo "  Loki:       http://localhost:30001"
echo "  Kibana:     http://localhost:30003"
echo ""
echo "Verificar target Prometheus: kubectl --context $CTX -n observability exec deploy/prometheus -- wget -qO- http://localhost:9090/api/v1/targets | grep -A2 exporter"
