# Multi-Cluster Observability Lab (KIND)

## 📌 Objetivo

Este repositório demonstra como montar **localmente** um laboratório de **observabilidade multi-cluster** usando **KIND**, com **clusters isolados em redes Docker separadas**.

A ideia é comparar **logs no Loki vs Elasticsearch (ELK)** e centralizar **métricas no Prometheus + Grafana**, tudo com consumo reduzido de recursos.

---

## 🧱 Arquitetura

### Clusters

| Cluster         | Rede Docker | Função                               |
| --------------- | ----------- | ------------------------------------ |
| `observability` | `net-obs`   | Grafana, Loki, Elasticsearch, Kibana |
| `apps`          | `net-app`   | Aplicações, Prometheus, Fluent Bit   |

### Fluxo de dados

```
Apps Cluster
  ├─ Logs ──► Fluent Bit ──► Loki (Obs Cluster)
  │                         └─► Elasticsearch (Obs Cluster)
  └─ Metrics ──► Prometheus (Apps Cluster)
                    └─► Grafana (Obs Cluster)
```

---

## ⚙️ Pré-requisitos

* Docker Desktop
* KIND
* kubectl
* Helm
* Máquina recomendada: **4 vCPU / 8GB RAM**

---

## 📝 Passo a Passo Cronológico com Arquivos YAML

### 1️⃣ Criar redes Docker isoladas

Arquivo: `docker-networks.sh`

```bash
docker network create net-obs net-app net-shared || true
```

Executar (após criar os clusters):

```bash
bash docker-networks.sh
```

---

### 2️⃣ Criar clusters KIND

Arquivo: `kind-observability.yaml`

```yaml
kind: Cluster
apiVersion: kind.x-k8s.io/v1alpha4
name: observability
nodes:
  - role: control-plane
    extraPortMappings:
      - containerPort: 30000
        hostPort: 30000
        protocol: TCP
      - containerPort: 30001
        hostPort: 30001
        protocol: TCP
      - containerPort: 30002
        hostPort: 30002
        protocol: TCP
      - containerPort: 30003
        hostPort: 30003
        protocol: TCP
```

Arquivo: `kind-apps.yaml`

```yaml
kind: Cluster
apiVersion: kind.x-k8s.io/v1alpha4
name: apps
nodes:
  - role: control-plane
    extraPortMappings:
      - containerPort: 31000
        hostPort: 31000
        protocol: TCP
```

Criar os clusters:

```bash
kind create cluster --config kind-observability.yaml
kind create cluster --config kind-apps.yaml
```

Conectar clusters às redes Docker (execute após criar os clusters):

```bash
bash docker-networks.sh
```

Ou manualmente:

```bash
docker network create net-obs net-app net-shared || true
docker network connect net-obs observability-control-plane || true
docker network connect net-app apps-control-plane || true
docker network connect net-shared observability-control-plane || true
docker network connect net-shared apps-control-plane || true
```

> **Comunicação entre clusters**: O Fluent Bit (apps) e Prometheus (observability) usam `host.docker.internal` para alcançar Loki/Elasticsearch e o Prometheus Exporter via NodePorts expostos no host. Funciona no Mac/Windows. No Linux, use Docker 20.10+.

---

### 3️⃣ Criar namespaces base

```bash
kubectl --context kind-observability create ns observability
kubectl --context kind-observability create ns logging
kubectl --context kind-apps create ns apps
kubectl --context kind-apps create ns monitoring
```

---

### 4️⃣ Deploy Observability Cluster

#### Loki

Arquivo: `observability/loki-values.yaml`

```yaml
deploymentMode: SingleBinary
auth_enabled: false
singleBinary:
  replicas: 1
  resources:
    requests:
      cpu: 50m
      memory: 128Mi
    limits:
      memory: 512Mi
```

Instalar:

```bash
helm repo add grafana https://grafana.github.io/helm-charts
helm upgrade --install loki grafana/loki -n logging --kube-context kind-observability -f observability/loki-values.yaml
```

#### Elasticsearch + Kibana

Arquivo: `observability/elastic-values.yaml`

```yaml
replicas: 1
minimumMasterNodes: 1
resources:
  requests:
    cpu: 200m
    memory: 1Gi
  limits:
    memory: 2Gi
esJavaOpts: "-Xms512m -Xmx512m"
volumeClaimTemplate:
  resources:
    requests:
      storage: 5Gi
```

Instalar:

```bash
helm repo add elastic https://helm.elastic.co
helm upgrade --install elasticsearch elastic/elasticsearch -n logging --kube-context kind-observability -f observability/elastic-values.yaml
helm upgrade --install kibana elastic/kibana -n logging --kube-context kind-observability
```

#### Grafana

Arquivo: `observability/grafana-values.yaml`

```yaml
adminUser: admin
adminPassword: admin
resources:
  requests:
    cpu: 50m
    memory: 128Mi
  limits:
    memory: 512Mi
```

Instalar:

```bash
helm upgrade --install grafana grafana/grafana -n observability --kube-context kind-observability -f observability/grafana-values.yaml
```

---

### 5️⃣ Deploy Apps Cluster

Arquivo: `apps/apps.yaml` (aplicações + cronjob de tráfego)

```yaml
# app-ok, app-err, serviços e CronJob de tráfego
# (conteúdo conforme exemplos anteriores)
```

Aplicar:

```bash
kubectl --context kind-apps apply -f apps/apps.yaml
```

#### Prometheus

Arquivo: `apps/prometheus-values.yaml`

```yaml
grafana:
  enabled: false
alertmanager:
  enabled: false
prometheus:
  prometheusSpec:
    retention: 6h
    resources:
      requests:
        cpu: 100m
        memory: 256Mi
      limits:
        memory: 512Mi
```

Instalar:

```bash
helm repo add prometheus-community https://prometheus-community.github.io/helm-charts
helm upgrade --install kps prometheus-community/kube-prometheus-stack -n monitoring --kube-context kind-apps -f apps/prometheus-values.yaml
```

#### Fluent Bit (envio de logs para Loki + Elasticsearch)

Arquivo: `apps/fluent-bit-values.yaml`

```yaml
# Configuração conforme exemplos anteriores
```

Instalar:

```bash
helm repo add fluent https://fluent.github.io/helm-charts
helm upgrade --install fluent-bit fluent/fluent-bit -n monitoring --kube-context kind-apps -f apps/fluent-bit-values.yaml
```

---

### 6️⃣ Configurar datasources no Grafana (Obs Cluster)

* Prometheus (Apps Cluster): `http://host.docker.internal:31000`
* Loki: `http://loki.logging.svc.cluster.local:3100`
* Elasticsearch: `http://host.docker.internal:30002`

---

### 7️⃣ Validações

```bash
kubectl --context kind-apps -n apps get pods
kubectl --context kind-apps -n monitoring logs ds/fluent-bit
```

* Logs no Grafana (Loki) e Kibana (ELK)
* Métricas das apps no Grafana (Prometheus)

---

### 8️⃣ Cleanup

```bash
kind delete cluster --name observability
kind delete cluster --name apps

docker network rm net-obs
docker network rm net-app
```
