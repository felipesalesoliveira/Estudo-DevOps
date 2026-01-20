# Serviços AWS – Visão Geral (.md)

Este documento resume serviços AWS comuns em **identidade e segurança**, **aplicações modernas**, **automação**, **IoT**, **continuidade de negócios** e **End User Computing**, com foco prático para Cloud / DevOps.

---

## 🔐 Amazon Cognito

Serviço de **autenticação e autorização** para aplicações.

**Principais usos:**

* Login de usuários (email, social login, SAML)
* Gerenciamento de usuários
* Integração com apps web e mobile

**Casos comuns:** SaaS, apps mobile, APIs

---

## 🔑 AWS Security Token Service (STS)

Fornece **credenciais temporárias** para acesso à AWS.

**Principais usos:**

* AssumeRole
* Acesso cross-account
* Integração com identidades externas (SSO)

**Benefício:** menos risco, sem credenciais permanentes

---

## 📱 AWS Device Farm

Plataforma de **testes automatizados** para apps mobile e web.

**Principais usos:**

* Testes em dispositivos reais
* Testes de UI e performance
* CI/CD mobile

---

## 🔗 AWS AppSync

Serviço gerenciado de **APIs GraphQL**.

**Principais usos:**

* APIs em tempo real
* Sincronização offline
* Integração com DynamoDB, Lambda

**Ideal para:** aplicações modernas e mobile

---

## 🚀 AWS Amplify

Framework para **desenvolvimento full-stack**.

**Principais usos:**

* Frontend (React, Vue, Angular)
* Backend serverless
* Auth (Cognito), APIs, Hosting

**Benefício:** acelera desenvolvimento cloud-native

---

## 🌐 AWS IoT Core

Plataforma para **conectar e gerenciar dispositivos IoT**.

**Principais usos:**

* Comunicação MQTT/HTTP
* Gerenciamento de dispositivos
* Processamento de dados em tempo real

**Casos comuns:** indústria, sensores, smart devices

---

## 🔁 AWS Step Functions

Orquestrador de **workflows serverless**.

**Principais usos:**

* Coordenação de Lambdas
* Processos de negócio
* Retry, timeout, paralelismo

**Benefício:** visibilidade e resiliência

---

## 🔄 AWS AppFlow

Serviço gerenciado para **integração de dados SaaS**.

**Principais usos:**

* Transferência de dados entre SaaS e AWS
* Integração com Salesforce, Slack, Zendesk
* Automação sem código

---

## 💾 AWS Backup

Serviço centralizado de **backup automatizado**.

**Principais usos:**

* Backup de EC2, EBS, RDS, DynamoDB, EFS
* Políticas centralizadas
* Compliance e retenção

---

## 🚨 Disaster Recovery Strategy (DR)

Estratégias para **continuidade de negócios**.

**Modelos comuns:**

* Backup & Restore
* Pilot Light
* Warm Standby
* Multi-Site Active/Active

**Objetivos:**

* RTO (Recovery Time Objective)
* RPO (Recovery Point Objective)

---

## 🖥️ Amazon WorkSpaces

Desktop como serviço (**DaaS**).

**Principais usos:**

* Ambientes corporativos
* Trabalho remoto
* Segurança de dados

---

## 🎮 Amazon AppStream 2.0

Streaming de **aplicações** via navegador.

**Principais usos:**

* Apps legados
* Software sob demanda
* Treinamentos e laboratórios

**Diferença:** AppStream entrega apps, WorkSpaces entrega desktop completo

---

## 📌 Resumo Rápido

* **Cognito / STS** → Identidade e acesso
* **AppSync / Amplify** → Apps modernos
* **IoT Core** → Dispositivos conectados
* **Step Functions** → Orquestração
* **AppFlow** → Integração SaaS
* **Backup / DR** → Continuidade de negócios
* **WorkSpaces / AppStream** → End User Computing
