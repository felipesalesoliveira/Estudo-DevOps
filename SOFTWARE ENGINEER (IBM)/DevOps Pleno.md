# Guia de Estudos DevOps – Nível Pleno

Este documento descreve os **requisitos técnicos e práticos esperados de um DevOps Pleno**.  
O foco aqui é **autonomia, tomada de decisão, automação e resolução de problemas reais**.

Cada tópico contém:
- **O que é**
- **O que estudar**
- **O que saber fazer na prática**

---

## 1. Linux (Intermediário / Avançado)

### 1.1 Administração de sistemas
**O que é:**  
Gerenciamento e troubleshooting de servidores Linux em produção.

**Estude:**
- Estrutura de boot
- `systemd` e `systemctl`
- Gerenciamento de serviços
- `/var/log`, `journalctl`

**Na prática você deve saber:**
- Identificar serviços que não sobem
- Reiniciar e configurar serviços
- Analisar logs para debug

---

### 1.2 Performance e troubleshooting
**O que é:**  
Análise de consumo de recursos e problemas no sistema.

**Estude:**
- CPU, memória, disco
- `top`, `htop`, `free`, `df`, `du`
- `lsof`, `strace` (noção)

**Na prática:**
- Identificar gargalos
- Resolver problemas de disco cheio
- Encontrar processos problemáticos

---

### 1.3 Shell Script
**O que é:**  
Automação de tarefas usando Bash.

**Estude:**
- Variáveis
- Loops (`for`, `while`)
- Condicionais (`if`)
- Pipes e redirecionamento

**Na prática:**
- Criar scripts de automação
- Automatizar tarefas repetitivas
- Criar scripts de deploy simples

---

## 2. Redes (Intermediário)

### 2.1 Fundamentos aplicados
**O que é:**  
Entendimento profundo da comunicação entre sistemas.

**Estude:**
- TCP/IP
- UDP
- NAT
- DNS troubleshooting

**Na prática:**
- Diagnosticar falhas de rede
- Resolver problemas de DNS
- Testar conectividade (`curl`, `ping`, `traceroute`)

---

### 2.2 Load Balancer e Proxy
**O que é:**  
Distribuição e controle avançado de tráfego.

**Estude:**
- Load balancers L4 e L7
- Reverse proxy
- Health checks

**Na prática:**
- Configurar balanceamento
- Resolver problemas de rota
- Trabalhar com Nginx / ALB / ELB

---

## 3. Docker (Intermediário / Avançado)

### 3.1 Construção de imagens
**O que é:**  
Criação eficiente e segura de imagens Docker.

**Estude:**
- Multi-stage build
- Otimização de imagens
- Cache de build

**Na prática:**
- Reduzir tamanho de imagens
- Criar imagens seguras
- Versionar imagens corretamente

---

### 3.2 Operação e troubleshooting
**O que é:**  
Gerenciamento de containers em produção.

**Estude:**
- Docker Compose
- Networking Docker
- Volumes

**Na prática:**
- Debug de containers
- Análise de logs
- Subir stacks completas

---

## 4. Kubernetes (Obrigatório para Pleno)

### 4.1 Recursos principais
**O que é:**  
Gerenciamento de aplicações em cluster.

**Estude:**
- Pod
- Deployment
- StatefulSet
- Service

**Na prática:**
- Subir aplicações completas
- Escalar workloads
- Atualizar aplicações sem downtime

---

### 4.2 Configuração e exposição
**O que é:**  
Configuração dinâmica de aplicações.

**Estude:**
- ConfigMap
- Secret
- Ingress
- Service types

**Na prática:**
- Expor aplicações externas
- Gerenciar variáveis sensíveis
- Configurar Ingress Controller

---

### 4.3 Debug e operação
**O que é:**  
Resolução de problemas em clusters.

**Estude:**
- `kubectl logs`
- `kubectl describe`
- `kubectl exec`

**Na prática:**
- Resolver pods em crash
- Analisar eventos do cluster
- Corrigir falhas de deploy

---

## 5. Cloud (AWS como referência)

### 5.1 Arquitetura em nuvem
**O que é:**  
Desenho de soluções escaláveis e resilientes.

**Estude:**
- EC2
- Auto Scaling
- Load Balancer
- VPC

**Na prática:**
- Criar infra altamente disponível
- Trabalhar com múltiplas AZs
- Pensar em custo e performance

---

### 5.2 IAM e segurança
**O que é:**  
Controle de acesso e permissões.

**Estude:**
- IAM Roles
- Policies
- Least privilege

**Na prática:**
- Criar roles seguras
- Resolver problemas de permissão
- Evitar credenciais hardcoded

---

## 6. Infra como Código (Terraform)

### 6.1 Terraform intermediário
**O que é:**  
Automação de infraestrutura em escala.

**Estude:**
- Modules
- Remote State
- Backends
- Workspaces

**Na prática:**
- Organizar código por ambiente
- Criar módulos reutilizáveis
- Trabalhar em time sem conflitos

---

### 6.2 Boas práticas
**O que é:**  
Manutenção e segurança do código IaC.

**Estude:**
- Versionamento
- Naming conventions
- State locking

**Na prática:**
- Evitar drift
- Planejar mudanças de infra
- Executar apply com segurança

---

## 7. CI/CD (Intermediário / Avançado)

### 7.1 Pipelines completos
**O que é:**  
Automação de build, testes e deploy.

**Estude:**
- GitHub Actions / GitLab CI / Jenkins
- Variáveis
- Secrets

**Na prática:**
- Criar pipelines completas
- Automatizar deploy
- Criar rollback

---

### 7.2 Estratégias de deploy
**O que é:**  
Minimizar riscos em produção.

**Estude:**
- Blue/Green
- Canary
- Rolling update

**Na prática:**
- Aplicar deploy sem downtime
- Reverter versões rapidamente

---

## 8. Observabilidade

### 8.1 Monitoramento
**O que é:**  
Acompanhamento da saúde do sistema.

**Estude:**
- Prometheus
- Grafana
- CloudWatch

**Na prática:**
- Criar dashboards
- Configurar alertas
- Monitorar métricas críticas

---

### 8.2 Logs
**O que é:**  
Centralização e análise de logs.

**Estude:**
- Logs estruturados
- Centralização de logs

**Na prática:**
- Investigar incidentes
- Correlacionar falhas

---

## 9. Segurança

### 9.1 Segurança em ambientes DevOps
**O que é:**  
Proteção da infraestrutura e pipelines.

**Estude:**
- Secrets management
- Scan de imagens
- Princípios de segurança em cloud

**Na prática:**
- Proteger pipelines
- Evitar vazamento de credenciais
- Aplicar boas práticas de segurança

---

## 10. Soft Skills (Essencial para Pleno)

### 10.1 Autonomia e comunicação
**O que é:**  
Capacidade de atuar sem supervisão constante.

**Estude:**
- Comunicação técnica
- Gestão de incidentes
- Priorização

**Na prática:**
- Resolver incidentes
- Comunicar problemas claramente
- Sugerir melhorias técnicas

---

## Perfil Esperado de um DevOps Pleno

- Atua com autonomia
- Resolve problemas complexos
- Automatiza processos
- Dá suporte a times de desenvolvimento
- Mentora DevOps Júnior

---

## Próximo Passo
- Transformar este guia em projetos práticos
- Criar ambientes reais (lab)
- Consolidar experiência rumo ao nível Sênior
