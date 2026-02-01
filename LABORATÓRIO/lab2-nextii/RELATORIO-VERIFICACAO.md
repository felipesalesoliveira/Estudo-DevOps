# Relatório de Verificação - Observability vs Apps

**Data:** 30/01/2026  
**Setup:** Clusters dual (kind-observability + kind-apps)

---

## Resumo

| Componente | Status | Detalhes |
|------------|--------|----------|
| **Métricas** (Prometheus → node-exporter) | ❌ DOWN | host.docker.internal:31000 - context deadline exceeded |
| **Logs** (Fluent Bit → Loki/ES) | ⚠️ PARCIAL | Fluent Bit rodando, mas Loki/ES em outro cluster (DNS não resolve) |

---

## 1. Métricas (Prometheus)

### Status atual
```
Job: apps-exporter | Instance: host.docker.internal:31000 | Health: DOWN
Error: Get "http://host.docker.internal:31000/metrics": context deadline exceeded

Job: self | Instance: localhost:9090 | Health: UP
```

### Causa
- Prometheus (cluster observability) tenta scrapear `host.docker.internal:31000`
- `host.docker.internal` **não funciona** entre containers Kind (timeout)
- O node-exporter está rodando no cluster apps (1/1 Running)
- A comunicação cross-cluster via host falha

### Solução
Migrar para **cluster único** (kind-lab2) - ver instruções abaixo.

---

## 2. Logs (Fluent Bit)

### Status atual (após correção)
- **Fluent Bit**: ✅ Rodando (1/1 Running) - ServiceAccount criado
- **Loki**: ❌ Sem logs do namespace apps (result: [])
- **Causa**: Fluent Bit usa `loki.logging.svc.cluster.local` - esse DNS **não existe** no cluster apps (Loki está no cluster observability)

### Correção aplicada
- ServiceAccount + RBAC adicionados ao app-fluentbit.yaml
- Fluent Bit agora inicia corretamente

### Problema pendente
- Em clusters separados, Fluent Bit (apps) não consegue alcançar Loki/ES (observability) via DNS
- Loki e Elasticsearch estão no cluster observability; o cluster apps não tem esses serviços

---

## 3. Recomendação: Cluster Único

A comunicação entre clusters Kind é **instável**. A solução mais confiável:

```bash
# 1. Deletar clusters atuais
kind delete cluster --name observability
kind delete cluster --name apps

# 2. Criar cluster único
kind create cluster --config kind-unified.yaml

# 3. Deploy completo
bash deploy-unified.sh
```

Com cluster único, toda comunicação usa **DNS interno** do Kubernetes e funciona sem problemas.
