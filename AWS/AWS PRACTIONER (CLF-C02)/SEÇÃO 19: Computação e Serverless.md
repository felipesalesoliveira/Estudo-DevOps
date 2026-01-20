# Computação e Serverless na AWS

Este documento apresenta uma visão geral dos **serviços de computação da AWS**, com foco especial em **arquiteturas serverless**, suas diferenças, casos de uso e boas práticas.

---

## 🖥️ Computação na AWS (Visão Geral)

Computação refere-se à capacidade de **processar dados e executar aplicações**. Na AWS, isso pode ser feito de forma **tradicional**, **gerenciada** ou **serverless**.

---

## 🧱 Modelos de Computação

### 1️⃣ Computação Tradicional (IaaS)

Você gerencia servidores, sistema operacional e runtime.

**Serviços:**

* Amazon EC2
* Auto Scaling Groups

**Responsabilidades:**

* Patching do SO
* Escalabilidade
* Alta disponibilidade

**Quando usar:**

* Aplicações legadas
* Controle total do ambiente

---

### 2️⃣ Computação Gerenciada (PaaS / Containers)

A AWS gerencia parte da infraestrutura.

**Serviços:**

* Amazon ECS
* Amazon EKS
* AWS Elastic Beanstalk

**Responsabilidades:**

* Código e configuração
* Escalabilidade lógica

**Quando usar:**

* Microserviços
* Aplicações containerizadas

---

## ⚡ Serverless na AWS

Em **serverless**, você **não gerencia servidores**. A AWS cuida de:

* Provisionamento
* Escalabilidade
* Alta disponibilidade

Você paga **somente pelo uso**.

---

## 🚀 Principais Serviços Serverless

### 🔹 AWS Lambda

Executa código sob demanda, baseado em eventos.

**Características:**

* Escala automaticamente
* Suporte a várias linguagens
* Tempo máximo de execução

**Casos de uso:**

* APIs
* Processamento assíncrono
* Automação

---

### 🔹 Amazon API Gateway

Criação e gerenciamento de **APIs REST e HTTP**.

**Funções:**

* Autenticação
* Throttling
* Monitoramento

---

### 🔹 AWS Step Functions

Orquestra workflows serverless.

**Benefícios:**

* Estados visuais
* Retry e tratamento de erros
* Fluxos complexos

---

### 🔹 Amazon EventBridge

Barramento de eventos serverless.

**Casos de uso:**

* Arquitetura orientada a eventos
* Integração entre serviços

---

### 🔹 Amazon DynamoDB

Banco NoSQL totalmente serverless.

**Benefícios:**

* Escala automática
* Alta disponibilidade
* Baixa latência

---

### 🔹 Amazon S3

Armazenamento de objetos serverless.

**Usos:**

* Data lakes
* Backup
* Hospedagem de arquivos

---

## 🧩 Arquitetura Serverless Típica

```
Cliente
  ↓
API Gateway
  ↓
Lambda
  ↓
DynamoDB / S3
```

---

## 💰 Benefícios do Serverless

* Menor custo operacional
* Escalabilidade automática
* Alta disponibilidade nativa
* Menos overhead de infraestrutura

---

## ⚠️ Desafios do Serverless

* Cold start
* Observabilidade distribuída
* Limites de execução

---

## 🧠 Boas Práticas

* Funções pequenas e específicas
* Uso de eventos
* Monitoramento com CloudWatch
* Infraestrutura como Código

---

## 🆚 Computação Tradicional vs Serverless

| Tradicional           | Serverless                |
| --------------------- | ------------------------- |
| Gerencia servidores   | Sem servidores            |
| Custo fixo            | Paga por uso              |
| Escalabilidade manual | Escalabilidade automática |

---

## 👨‍💻 Para quem é essencial?

* DevOps Engineers
* Cloud Engineers
* Arquitetos de Soluções

---

## 📌 Resumo Final

* AWS oferece múltiplos modelos de computação
* Serverless reduz complexidade operacional
* Ideal para aplicações modernas e escaláveis
