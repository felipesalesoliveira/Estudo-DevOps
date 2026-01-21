# 🎮 Super Mario no GKE - Configuração Terraform

Este diretório contém a configuração Terraform para criar um cluster GKE (Google Kubernetes Engine) e fazer deploy do Super Mario.

## 📋 Pré-requisitos

### 1. Conta Google Cloud Platform (GCP)

- Crie uma conta em: https://cloud.google.com
- Ative o **free trial** ($300 de créditos por 90 dias)

### 2. Instalar Google Cloud SDK

**No Mac:**
```bash
brew install google-cloud-sdk
```

**No Linux:**
```bash
curl https://sdk.cloud.google.com | bash
exec -l $SHELL
```

**No Windows:**
- Baixe e instale: https://cloud.google.com/sdk/docs/install

### 3. Configurar autenticação GCP

```bash
# Login no GCP
gcloud auth login

# Criar projeto (ou usar existente)
gcloud projects create SEU-PROJECT-ID --name="Super Mario Lab"

# Definir projeto atual
gcloud config set project SEU-PROJECT-ID

# Habilitar APIs necessárias
gcloud services enable container.googleapis.com
gcloud services enable compute.googleapis.com
```

### 4. Instalar Terraform

Veja instruções em: `../LABORATORIO.md` (seção de instalação do Terraform)

### 5. Configurar Application Default Credentials

```bash
gcloud auth application-default login
```

Isso permite que o Terraform use suas credenciais do GCP automaticamente.

---

## ⚙️ Configuração

### 1. Editar `terraform.tfvars`

```bash
nano terraform.tfvars
```

**Substitua:**
- `SEU-PROJECT-ID-AQUI` pelo ID do seu projeto GCP

**Exemplo:**
```hcl
gcp_project_id = "meu-projeto-123456"
gcp_region     = "us-central1"
gcp_zone       = "us-central1-a"
```

### 2. (Opcional) Configurar Backend GCS

**Opção A: Usar GCS (recomendado para produção)**

1. Criar bucket GCS:
```bash
gsutil mb -p SEU-PROJECT-ID gs://SEU-BUCKET-GCS-AQUI
```

2. Editar `backend.tf`:
```hcl
terraform {
  backend "gcs" {
    bucket = "SEU-BUCKET-GCS-AQUI"
    prefix = "gke/terraform.tfstate"
  }
}
```

**Opção B: Usar backend local (mais simples para lab)**

Comente o bloco `backend "gcs"` no `backend.tf`:
```hcl
# terraform {
#   backend "gcs" {
#     ...
#   }
# }
```

O Terraform usará backend local automaticamente.

---

## 🚀 Execução

### 1. Inicializar Terraform

```bash
cd GKE-TF
terraform init
```

### 2. Validar configuração

```bash
terraform validate
```

### 3. Ver plano de execução

```bash
terraform plan
```

### 4. Aplicar (criar infraestrutura)

```bash
terraform apply
```

**⏱️ Tempo:** 5-10 minutos

### 5. Configurar kubectl

```bash
# Obter credenciais do cluster
gcloud container clusters get-credentials $(terraform output -raw cluster_name) \
  --region $(terraform output -raw cluster_location) \
  --project $(gcloud config get-value project)

# Verificar conexão
kubectl get nodes
```

### 6. Deploy do Super Mario

```bash
# Voltar para pasta raiz
cd ..

# Aplicar deployment
kubectl apply -f deployment.yaml

# Aplicar service (LoadBalancer)
kubectl apply -f service.yaml

# Aguardar LoadBalancer ficar pronto
kubectl get service mario-service -w
```

### 7. Obter IP do LoadBalancer

```bash
kubectl get service mario-service
```

Copie o `EXTERNAL-IP` e acesse no navegador: `http://EXTERNAL-IP`

---

## 🧹 Limpeza

### 1. Deletar recursos Kubernetes

```bash
kubectl delete service mario-service
kubectl delete deployment mario-deployment
```

### 2. Destruir infraestrutura Terraform

```bash
cd GKE-TF
terraform destroy
```

---

## 💰 Custos GCP

### Free Tier GCP:

- **$300 de créditos** por 90 dias (conta nova)
- **e2-micro**: 1 instância sempre grátis (mas muito limitada para Kubernetes)

### Estimativa de custo:

- **GKE Control Plane:** Grátis ✅
- **e2-micro (preemptible):** ~$0.01/hora
- **Load Balancer:** ~$0.025/hora + tráfego

**Total:** ~$0.035/hora (muito mais barato que AWS EKS!)

**⚠️ IMPORTANTE:** 
- Use máquinas **preemptible** (já configurado) para economizar
- Destrua tudo após testar
- Monitore custos no console GCP

---

## 🔧 Troubleshooting

### Erro: "Project not found"

```bash
# Verificar projeto atual
gcloud config get-value project

# Definir projeto correto
gcloud config set project SEU-PROJECT-ID
```

### Erro: "API not enabled"

```bash
gcloud services enable container.googleapis.com
gcloud services enable compute.googleapis.com
```

### Erro: "Permission denied"

```bash
# Verificar permissões
gcloud projects get-iam-policy SEU-PROJECT-ID

# Você precisa de: roles/container.admin, roles/compute.admin
```

---

## 📚 Próximos Passos

- Veja `../LABORATORIO.md` para guia completo do zero
- Veja `../README.md` para documentação detalhada
- Veja `../GUIA-CUSTOS.md` para entender custos
