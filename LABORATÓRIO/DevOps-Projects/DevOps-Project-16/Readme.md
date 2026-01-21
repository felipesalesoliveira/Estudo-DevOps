# Projeto DevOps em Tempo Real

## Deploy no Kubernetes usando Jenkins | CI/CD End-to-End

## Visão Geral

Este laboratório descreve um projeto DevOps completo, cobrindo **CI/CD**, **Jenkins**, **SonarQube**, **Docker**, **Kubernetes (EKS)** e **GitOps com ArgoCD**, desde a criação da infraestrutura até o deploy automatizado da aplicação.

---

## Arquitetura Geral

**Fluxo resumido:**

1. Desenvolvedor faz commit no GitHub
2. Jenkins executa pipeline CI
3. Build, testes e análise de código com SonarQube
4. Build e push da imagem Docker
5. Pipeline CD aciona GitOps
6. ArgoCD sincroniza e faz deploy no EKS
7. Aplicação disponível via LoadBalancer

---

## 1. Jenkins Master (EC2)

* AMI: Ubuntu (Free Tier)
* Tipo: t2.micro
* Storage: 15 GiB

### Instalação

* Java 17
* Jenkins
* Liberação da porta **8080** no Security Group

---

## 2. Jenkins Agent (EC2)

* AMI: Ubuntu (Free Tier)
* Tipo: t2.micro
* Storage: 15 GiB

### Instalação

* Java 17
* Docker
* Configuração de acesso SSH a partir do Jenkins Master

---

## 3. Configuração do Jenkins

### Nodes

* Built-in Node: Executors = 0
* Jenkins-Agent:

  * Executors = 2
  * Launch via SSH

### Ferramentas

* Maven 3
* JDK 17 (Adoptium)

### Credenciais

* GitHub (PAT)
* Docker Hub (Access Token)
* SonarQube Token

---

## 4. Pipeline CI

* Tipo: Pipeline from SCM
* Repositório: GitHub (fork do projeto)
* Branch: main

### Etapas do CI

* Checkout do código
* Build com Maven
* Testes
* Análise de qualidade com SonarQube
* Build da imagem Docker
* Push para Docker Hub

---

## 5. SonarQube

### Infraestrutura

* EC2: t3.medium
* Banco de dados: PostgreSQL
* Java: Temurin 17
* Porta: **9000**

### Integração

* Token global de análise
* Webhook configurado para Jenkins

---

## 6. EKS (Kubernetes)

### Bootstrap Server

* EC2 Ubuntu
* AWS CLI
* kubectl
* eksctl

### Cluster

* Região: ap-south-1
* Nodes: 3
* Tipo: t2.small

---

## 7. ArgoCD

### Instalação

* Namespace: argocd
* Exposto via LoadBalancer

### GitOps

* Repositório GitOps conectado
* Sync automático
* Prune e Self Heal habilitados

---

## 8. Pipeline CD

* Job: GitOps-register-app-cd
* Parametrizado (IMAGE_TAG)
* Trigger remoto via API Token

### Deploy

* ArgoCD detecta mudança
* Atualiza recursos no EKS
* Aplicação publicada automaticamente

---

## Validação

* Alterar código no GitHub
* Jenkins executa CI
* Imagem Docker atualizada
* ArgoCD aplica mudanças no cluster
* Aplicação acessível via LoadBalancer

---

## Resultado Final

✅ Pipeline CI/CD completo

✅ Deploy automatizado em Kubernetes

✅ Qualidade de código validada

✅ GitOps com ArgoCD

---

## Observações

Este projeto representa um **fluxo real de produção**, amplamente utilizado em ambientes corporativos modernos.

---

🚀 **Projeto DevOps End-to-End concluído com sucesso!**
