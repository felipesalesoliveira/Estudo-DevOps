# Resumo das Correções - Lab2-NextII

Este documento descreve **o que estava errado**, **o que foi corrigido** e **por quê**, para ajudar no entendimento dos conceitos.

---

## 1. Fluent Bit (cluster apps) - `app-fluentbit.yaml`

### ❌ O que estava errado

```yaml
[OUTPUT]
    Name  loki
    Host  172.18.0.2    # IP fixo
    Port  30001

[OUTPUT]
    Name  es
    Host  172.18.0.2    # IP fixo
    Port  30002
```

### 🔍 Por que estava errado

- **172.18.0.2** é um IP típico da rede Docker padrão (`bridge`)
- Com clusters em **redes Docker separadas** (`net-obs` e `net-app`), cada cluster fica isolado
- O cluster **apps** está em `net-app`; o cluster **observability** está em `net-obs`
- O Fluent Bit (rodando dentro do cluster apps) **não consegue alcançar** 172.18.0.2 porque:
  - Esse IP pode nem existir na rede do apps
  - Ou pertence a outro container em outra rede
- Resultado: **logs não chegavam** ao Loki nem ao Elasticsearch

### ✅ Correção aplicada

```yaml
[OUTPUT]
    Name  loki
    Host  host.docker.internal
    Port  30001

[OUTPUT]
    Name  es
    Host  host.docker.internal
    Port  30002
```

### 💡 Por que funciona agora

- `host.docker.internal` é um hostname especial que aponta para a **máquina host** (seu Mac/Windows)
- Loki e Elasticsearch estão expostos via **NodePort** (30001 e 30002) no cluster observability
- O Kind mapeia essas portas para o **host** (extraPortMappings no kind-observability.yaml)
- Fluxo: Fluent Bit (apps) → host.docker.internal:30001 → host → Kind encaminha → Loki
- Assim, a comunicação **atravessa** as redes Docker usando o host como ponte

---

## 2. Service do Prometheus Exporter - `app-prometheusexporter.yaml`

### ❌ O que estava errado

```yaml
# Deployment
spec:
  template:
    metadata:
      labels:
        app: node-exporter   # ← label do pod

# Service
spec:
  selector:
    app: exporter           # ← selector procurando outro label!
```

### 🔍 Por que estava errado

- O **Service** usa o `selector` para encontrar os pods que vai expor
- O selector `app: exporter` procura pods com label `app=exporter`
- Os pods do Deployment têm label `app: node-exporter`
- **Nenhum pod corresponde** ao selector → Service fica sem endpoints
- Resultado: **Prometheus não conseguia scrapear** (porta 31000 sem nada respondendo)

### ✅ Correção aplicada

```yaml
spec:
  selector:
    app: node-exporter   # ← agora bate com o label do Deployment
```

### 💡 Regra importante

> O `selector` do Service **deve corresponder exatamente** aos `labels` dos pods que você quer expor.

---

## 3. Script de redes - `docker-networks.sh` (novo arquivo)

### O que foi criado

- Script para criar as redes Docker e conectar os clusters
- Inclusão da rede **net-shared** para ambos os clusters (opcional, para comunicação direta)
- Instruções no README atualizadas

### Por que importa

- Garante que os clusters sejam conectados às redes corretas após o `kind create cluster`
- A comunicação via `host.docker.internal` depende dos **NodePorts** estarem mapeados no host
- O script padroniza o processo e evita esquecer algum passo

---

## 4. README - ajustes de caminhos

### O que foi corrigido

- Referências `kind/kind-observability.yaml` → `kind-observability.yaml` (arquivos estão na raiz)
- Referências `networks/docker-networks.sh` → `docker-networks.sh`
- Adicionada explicação sobre comunicação cross-cluster via `host.docker.internal`

---

## Resumo visual: comunicação entre clusters

```
                    REDE DOCKER net-obs          REDE DOCKER net-app
                           │                              │
                           │                              │
    ┌──────────────────────┼──────────────────────────────┼──────────────────────┐
    │                      │         HOST                 │                      │
    │   observability       │   (sua máquina)              │   apps               │
    │   - Loki :30001       │   Portas expostas:           │   - Fluent Bit       │
    │   - ES   :30002       │   - 30001, 30002, 30004     │   - node-exporter    │
    │   - Prometheus        │   - 31000                    │     :31000           │
    │                      │                              │                      │
    │                      │   host.docker.internal       │                      │
    │                      │   ◄──────────────────────────┼─── Fluent Bit        │
    │                      │   ◄──────────────────────────┼─── Prometheus       │
    │                      │      (resolve para o host)   │      (scrape)        │
    └──────────────────────┴──────────────────────────────┴──────────────────────┘
```

---

## Checklist de conceitos para não errar de novo

- [ ] **Selector do Service** = labels dos pods que ele deve expor
- [ ] **Clusters em redes Docker diferentes** = não se enxergam por IP direto
- [ ] **host.docker.internal** = ponte para acessar serviços expostos no host (NodePort)
- [ ] **NodePort** = expõe o serviço em uma porta em todos os nodes (no Kind, vai pro host)
- [ ] **extraPortMappings no Kind** = mapeia portas do container do node para o host
