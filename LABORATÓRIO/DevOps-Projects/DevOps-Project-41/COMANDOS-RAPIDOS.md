# ⚡ Comandos Rápidos - Referência

Guia rápido de comandos para executar o projeto Super Mario no EKS.

---

## 🔧 Instalação de Ferramentas (na EC2)

```bash
# Atualizar sistema
sudo su
apt update -y

# Docker
apt install docker.io -y
usermod -aG docker $USER
newgrp docker
docker --version

# Terraform
apt install wget -y
wget -O- https://apt.releases.hashicorp.com/gpg | sudo gpg --dearmor -o /usr/share/keyrings/hashicorp-archive-keyring.gpg
echo "deb [signed-by=/usr/share/keyrings/hashicorp-archive-keyring.gpg] https://apt.releases.hashicorp.com $(lsb_release -cs) main" | sudo tee /etc/apt/sources.list.d/hashicorp.list
apt update && apt install terraform -y
terraform --version

# AWS CLI
curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip"
apt-get install unzip -y
unzip awscliv2.zip
sudo ./aws/install
aws --version

# kubectl
apt install curl -y
curl -LO "https://dl.k8s.io/release/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl"
sudo install -o root -g root -m 0755 kubectl /usr/local/bin/kubectl
kubectl version --client
```

---

## 📁 Preparação do Projeto

```bash
# Criar diretório e clonar repositório
mkdir super_mario
cd super_mario
git clone https://github.com/Aakibgithuber/Deployment-of-super-Mario-on-Kubernetes-using-terraform.git
cd Deployment-of-super-Mario-on-Kubernetes-using-terraform

# OU usar arquivos locais (se você criou localmente)
# Nesse caso, apenas copie os arquivos para a EC2 via SCP ou clone seu próprio repo
```

---

## 🔐 Configuração IAM

### Criar Role (via Console AWS):
1. IAM → Roles → Create role
2. AWS service → EC2
3. Permissions → AdministratorAccess
4. Nome: `EC2-EKS-Deploy-Role`

### Anexar Role à EC2:
1. EC2 → Instances → Selecionar instância
2. Actions → Security → Modify IAM role
3. Selecionar role criada

### Verificar na EC2:
```bash
aws sts get-caller-identity
```

---

## 🪣 Criar Bucket S3

### Via Console AWS:
1. S3 → Create bucket
2. Nome: `mario-terraform-backend-XXXXX` (único)
3. Região: mesma do projeto
4. Versioning: Enable
5. Encryption: Enable

### Configurar backend.tf e terraform.tfvars:
```bash
cd EKS-TF

# 1. Editar backend.tf (bucket S3)
nano backend.tf
# Editar: bucket = "SEU-BUCKET-AQUI"
# Editar: region = "SUA-REGIAO-AQUI"

# 2. (Opcional) Editar terraform.tfvars para personalizar
nano terraform.tfvars
# Pode mudar: aws_region, cluster_name, instance_type, etc.
```

---

## 🚀 Terraform - Criar Infraestrutura

```bash
# Ir para pasta EKS-TF
cd EKS-TF

# Inicializar
terraform init

# Validar
terraform validate

# Ver plano (opcional)
terraform plan

# Aplicar (cria tudo)
terraform apply --auto-approve

# ⏱️ Aguardar 10-15 minutos
```

---

## 🎮 Kubernetes - Deploy do Super Mario

```bash
# Configurar kubectl para o EKS
aws eks update-kubeconfig --name EKS_CLOUD --region us-east-1

# Verificar conexão
kubectl cluster-info
kubectl get nodes

# Voltar para pasta raiz do projeto
cd ..

# Aplicar deployment
kubectl apply -f deployment.yaml

# Verificar pods
kubectl get pods
kubectl get pods -w  # Watch mode (atualiza automaticamente)

# Aplicar service (Load Balancer)
kubectl apply -f service.yaml

# Ver status do service (aguardar EXTERNAL-IP)
kubectl get service mario-service
kubectl describe service mario-service

# Obter URL do Load Balancer
kubectl get service mario-service -o jsonpath='{.status.loadBalancer.ingress[0].hostname}'
echo
```

---

## 🌐 Acessar o Jogo

```bash
# Obter URL
kubectl get service mario-service -o jsonpath='{.status.loadBalancer.ingress[0].hostname}'
echo

# Copiar a URL e colar no navegador com http://
# Exemplo: http://a1b2c3d4e5f6g7h8-1234567890.us-east-1.elb.amazonaws.com
```

---

## 🧹 Limpeza e Destruição

```bash
# 1. Deletar recursos Kubernetes
kubectl delete service mario-service
kubectl delete deployment mario-deployment

# Aguardar alguns minutos para Load Balancer ser deletado

# 2. Destruir infraestrutura Terraform
cd EKS-TF
terraform destroy --auto-approve

# ⏱️ Aguardar 5-10 minutos

# 3. Verificar que tudo foi deletado
kubectl get all
terraform state list

# 4. Terminar EC2 Bastion (via Console AWS)
# EC2 → Instances → Selecionar → Instance state → Terminate
```

---

## 🔍 Comandos Úteis de Verificação

### Verificar Infraestrutura:
```bash
# Estado do Terraform
terraform show
terraform state list

# Recursos AWS via CLI
aws eks list-clusters --region us-east-1
aws ec2 describe-instances --region us-east-1
aws elbv2 describe-load-balancers --region us-east-1
```

### Verificar Kubernetes:
```bash
# Informações do cluster
kubectl cluster-info
kubectl get nodes
kubectl get nodes -o wide

# Deployments e Services
kubectl get deployments
kubectl get services
kubectl get pods
kubectl get all

# Detalhes
kubectl describe deployment mario-deployment
kubectl describe service mario-service
kubectl describe pod <nome-do-pod>

# Logs
kubectl logs <nome-do-pod>
kubectl logs -f <nome-do-pod>  # Follow (atualiza automaticamente)

# Eventos
kubectl get events
kubectl get events --sort-by='.lastTimestamp'
```

### Troubleshooting:
```bash
# Ver logs de pods com problemas
kubectl logs <nome-do-pod> --previous  # Logs do container anterior (se reiniciou)

# Executar comando dentro do pod
kubectl exec -it <nome-do-pod> -- /bin/bash

# Port forwarding (acessar serviço localmente)
kubectl port-forward service/mario-service 8080:80
# Depois acesse: http://localhost:8080

# Ver configuração completa
kubectl get deployment mario-deployment -o yaml
kubectl get service mario-service -o yaml
```

---

## 📊 Monitoramento de Custos

```bash
# Ver identidade AWS atual
aws sts get-caller-identity

# Ver custos (requer permissões de billing)
aws ce get-cost-and-usage \
  --time-period Start=2024-01-01,End=2024-01-31 \
  --granularity MONTHLY \
  --metrics BlendedCost
```

---

## 🆘 Troubleshooting Rápido

### Problema: Pods não ficam Running
```bash
kubectl describe pod <nome-do-pod>
kubectl logs <nome-do-pod>
kubectl get events
```

### Problema: Load Balancer não aparece
```bash
kubectl describe service mario-service
# Aguardar 5-10 minutos
```

### Problema: Terraform init falha
```bash
# Verificar backend.tf
cat backend.tf

# Verificar se bucket existe
aws s3 ls s3://SEU-BUCKET-AQUI
```

### Problema: Não consigo acessar o jogo
```bash
# Verificar se service está pronto
kubectl get service mario-service

# Verificar se pods estão rodando
kubectl get pods

# Testar port forwarding
kubectl port-forward service/mario-service 8080:80
# Acesse: http://localhost:8080
```

---

## 📝 Variáveis Úteis

```bash
# Definir região (evita digitar toda hora)
export AWS_DEFAULT_REGION=us-east-1

# Definir nome do cluster
export CLUSTER_NAME=EKS_CLOUD

# Usar em comandos:
aws eks update-kubeconfig --name $CLUSTER_NAME --region $AWS_DEFAULT_REGION
```

---

## 🔄 Workflow Completo (Copy-Paste)

```bash
# ============================================
# SETUP INICIAL (uma vez)
# ============================================

# Instalar ferramentas (já feito acima)
# Criar IAM Role e anexar à EC2 (via console)
# Criar bucket S3 (via console)

# ============================================
# CONFIGURAR PROJETO
# ============================================

cd ~
mkdir super_mario && cd super_mario
git clone https://github.com/Aakibgithuber/Deployment-of-super-Mario-on-Kubernetes-using-terraform.git
cd Deployment-of-super-Mario-on-Kubernetes-using-terraform/EKS-TF

# Editar backend.tf com seu bucket e região
nano backend.tf

# ============================================
# CRIAR INFRAESTRUTURA
# ============================================

terraform init
terraform validate
terraform apply --auto-approve

# Aguardar 10-15 minutos

# ============================================
# CONFIGURAR KUBECTL
# ============================================

aws eks update-kubeconfig --name EKS_CLOUD --region us-east-1
kubectl get nodes

# ============================================
# DEPLOY DO JOGO
# ============================================

cd ..
kubectl apply -f deployment.yaml
kubectl get pods -w  # Aguardar pods ficarem Running

kubectl apply -f service.yaml
kubectl get service mario-service -w  # Aguardar EXTERNAL-IP

# Obter URL
kubectl get service mario-service -o jsonpath='{.status.loadBalancer.ingress[0].hostname}'
echo

# ============================================
# LIMPEZA (IMPORTANTE!)
# ============================================

kubectl delete service mario-service
kubectl delete deployment mario-deployment

cd EKS-TF
terraform destroy --auto-approve

# Terminar EC2 Bastion via console AWS
```

---

**💡 Dica:** Salve este arquivo como referência rápida durante a execução do projeto!
