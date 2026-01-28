# Laboratório Local de Observabilidade Multi-Cluster (KIND)

> Este repositório contém o material completo para subir um laboratório local com **dois clusters Kubernetes separados**, focado em **observabilidade e logs**, pronto para estudo, testes e comparação entre **Loki** e **ELK**.

## 🎯 Objetivo

* Subir **2 clusters KIND** em **redes Docker separadas**
* Centralizar observabilidade em um cluster dedicado
* Coletar:

  * Logs via **Loki** e **Elasticsearch**
  * Métricas via **Prometheus**
* Ter **2 aplicações simples** gerando logs frequentes (200 / 404 / erro simulado)
* Comparar a experiência de uso entre **Loki (Grafana)** e **ELK (Kibana)**

## 🧱 Arquitetura

```
+----------------------+          +-----------------------------+
| Cluster apps        |          | Cluster observability       |
| (rede net-app)      |          | (rede net-obs)              |
|                      |          |                             |
|  Apps (nginx/echo)  |  logs →  |  Loki                        |
|  Traffic Generator  |--------> |  Elasticsearch + Kibana     |
|  Prometheus         | metrics→ |  Grafana                    |
|  Fluent Bit         |          |                             |
+----------------------+          +-----------------------------+
```

## 🧰 Tecnologias Utilizadas

* Kubernetes local: **KIND**
* Observabilidade: Grafana, Prometheus, Loki
* Logs: Fluent Bit, Elasticsearch + Kibana
* Apps de teste: nginx e http-echo

## ⚙️ Pré-requisitos

* Docker
* kind
* kubectl
* helm

Recomendado: **4 vCPU / 8GB RAM**

## 1️⃣ Criar Redes Docker Separadas

```bash
docker network create net-obs
docker network create net-app
```

## 2️⃣ Criar Clusters KIND

### Cluster Observability

```bash
kind create cluster --config kind-observability.yaml
docker network connect net-obs observability-control-plane
```

### Cluster Apps

```bash
kind create cluster --config kind-apps.yaml
docker network connect net-app apps-control-plane
```

## 3️⃣ Namespaces

```bash
kubectl --context kind-observability create ns observability
kubectl --context kind-observability create ns logging

kubectl --context kind-apps create ns apps
kubectl --context kind-apps create ns monitoring
```

## 4️⃣ Stack de Observabilidade (Cluster observability)

* **Loki**: logs estruturados, baixo consumo de recursos (NodePort 30001)
* **Elasticsearch + Kibana**: single-node, JVM limitada (ES: 30002 / Kibana: 30003)
* **Grafana**: centraliza métricas e logs (NodePort 30000)

## 5️⃣ Cluster Apps

* **Aplicações**: app-ok (nginx), app-err (http-echo)
* **Traffic Generator**: CronJob gera tráfego a cada minuto

## 6️⃣ Prometheus (Cluster apps)

* Scrape das aplicações
* Retenção curta (6h)
* Exposto via NodePort 31000

## 7️⃣ Fluent Bit (Logs → Loki + Elasticsearch)

* Lê logs do namespace `apps`
* Envia logs simultaneamente para Loki e Elasticsearch
* Comunicação via `host.docker.internal`

## 8️⃣ Grafana – Configuração de Datasources

* **Loki**: `http://loki.logging.svc.cluster.local:3100`
* **Prometheus (apps)**: `http://host.docker.internal:31000`
* **Elasticsearch (opcional)**: `http://host.docker.internal:30002`, index `logstash-*`, time field `@timestamp`

## 9️⃣ Validação

* **Loki**: Grafana → Explore → `{namespace="apps"}`
* **Kibana**: Discover → filtro `kubernetes.namespace_name: "apps"`
* **Métricas**: Grafana → Prometheus datasource

## 🔥 Comparações Esperadas

| Aspecto      | Loki    | ELK           |
| ------------ | ------- | ------------- |
| Setup        | Simples | Mais complexo |
| Consumo      | Baixo   | Alto          |
| Query        | LogQL   | Lucene        |
| UX           | Grafana | Kibana        |
| Ideal p/ K8s | ⭐⭐⭐⭐    | ⭐⭐⭐           |

## 🧹 Limpeza do Ambiente

```bash
kind delete cluster --name observability
kind delete cluster --name apps

docker network rm net-obs
docker network rm net-app
```

## 📌 Próximos Passos (Opcional)

* Criar app em Go/Node com erro 500 real
* Adicionar OpenTelemetry
* Dashboards customizados
* Exportar métricas via OTLP
* Testar Promtail vs Fluent Bit

> ✅ Laboratório ideal para estudos de SRE, Observabilidade e entrevistas técnicas.
