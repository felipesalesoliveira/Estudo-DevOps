# AWS Well-Architected Framework (WAF)

O **AWS Well-Architected Framework** é um conjunto de **boas práticas** criado pela AWS para ajudar arquitetos, DevOps e engenheiros a **projetar, operar e otimizar workloads na nuvem** de forma segura, resiliente, eficiente e econômica.

---

## 🎯 Objetivo do Framework

* Avaliar arquiteturas existentes
* Identificar riscos e pontos de melhoria
* Guiar decisões técnicas
* Apoiar auditorias e revisões de arquitetura

---

## 🏛️ Os 6 Pilares do Well-Architected Framework

### 🔐 1. Security (Segurança)

Proteção de dados, sistemas e ativos.

**Boas práticas:**

* Princípio do menor privilégio (IAM)
* Criptografia em trânsito e em repouso
* Monitoramento contínuo e resposta a incidentes
* Automação de controles de segurança

**Serviços comuns:**

* IAM, KMS, CloudTrail, GuardDuty, AWS WAF, Shield

---

### ⚙️ 2. Operational Excellence (Excelência Operacional)

Execução e melhoria contínua das operações.

**Boas práticas:**

* Infraestrutura como Código (IaC)
* Observabilidade (logs, métricas, traces)
* Runbooks e playbooks
* Automação de mudanças e rollback

**Serviços comuns:**

* CloudWatch, Systems Manager, AWS Config, CloudFormation

---

### 🧱 3. Reliability (Confiabilidade)

Garantir que o sistema funcione corretamente mesmo em falhas.

**Boas práticas:**

* Arquitetura Multi-AZ
* Auto Scaling
* Backups e Disaster Recovery
* Testes de falhas (chaos engineering)

**Serviços comuns:**

* ELB, Auto Scaling, Route 53, RDS Multi-AZ

---

### 🚀 4. Performance Efficiency (Eficiência de Performance)

Uso eficiente de recursos de computação.

**Boas práticas:**

* Escolha correta de tipos de serviço
* Escalabilidade automática
* Serviços gerenciados e serverless
* Testes de carga e benchmark

**Serviços comuns:**

* EC2, Lambda, ECS, EKS, DynamoDB

---

### 💰 5. Cost Optimization (Otimização de Custos)

Evitar gastos desnecessários mantendo qualidade.

**Boas práticas:**

* Right sizing
* Uso de Savings Plans e Spot Instances
* Monitoramento e alertas de custos
* Remoção de recursos ociosos

**Serviços comuns:**

* Cost Explorer, Budgets, Compute Optimizer

---

### 🌱 6. Sustainability (Sustentabilidade)

Redução do impacto ambiental dos workloads.

**Boas práticas:**

* Arquiteturas eficientes
* Redução de recursos ociosos
* Uso de serviços serverless
* Escolha de regiões mais eficientes

---

## 🧠 Princípios de Design Importantes

* Pare de adivinhar capacidade
* Automatize tudo que for possível
* Trate falhas como algo normal
* Use serviços gerenciados
* Meça antes de otimizar

---

## 🧪 AWS Well-Architected Tool

Ferramenta gratuita da AWS para:

* Avaliar workloads com base nos pilares
* Responder questionários técnicos
* Gerar relatórios e planos de melhoria

Muito utilizada em:

* Revisões de arquitetura
* Migrações para a AWS
* Auditorias técnicas
* Práticas de FinOps

---

## 👨‍💻 Quem deve conhecer o WAF?

* DevOps Engineers
* SREs
* Cloud Engineers
* Arquitetos de Soluções
* Tech Leads

---

## 📌 Resumo Final

* Framework oficial da AWS
* Baseado em 6 pilares
* Focado em melhoria contínua
* Essencial para arquiteturas modernas em cloud
