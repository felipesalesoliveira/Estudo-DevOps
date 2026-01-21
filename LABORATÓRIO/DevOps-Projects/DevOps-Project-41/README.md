# 🎮 Deploy do Super Mario no Kubernetes usando Terraform - Guia Completo

Este guia documenta passo a passo como replicar o projeto de deploy do Super Mario no EKS (Elastic Kubernetes Service) da AWS usando Terraform, baseado no artigo do Aakib Khan.

## 🎓 Para Iniciantes Completos

**Se você nunca usou Terraform, AWS ou Kubernetes antes**, comece pelo **[LABORATORIO.md](./LABORATORIO.md)** - um guia didático completo do zero, assumindo conhecimento zero. Ele ensina:
- Como instalar Terraform do zero
- Como criar conta AWS
- Conceitos básicos explicados de forma simples
- Passo a passo detalhado com explicações de cada comando

**Se você já tem conhecimento básico**, pode seguir este README diretamente.

## 📋 Índice

1. [Visão Geral da Arquitetura](#visão-geral-da-arquitetura)
2. [Pré-requisitos](#pré-requisitos)
3. [Passo 1: Configuração Inicial da AWS](#passo-1-configuração-inicial-da-aws)
4. [Passo 2: Criação da EC2 (Máquina de Deploy)](#passo-2-criação-da-ec2-máquina-de-deploy)
5. [Passo 3: Instalação de Ferramentas na EC2](#passo-3-instalação-de-ferramentas-na-ec2)
6. [Passo 4: Configuração IAM](#passo-4-configuração-iam)
7. [Passo 5: Preparação do Terraform](#passo-5-preparação-do-terraform)
8. [Passo 6: Deploy da Infraestrutura EKS](#passo-6-deploy-da-infraestrutura-eks)
9. [Passo 7: Deploy do Super Mario no Kubernetes](#passo-7-deploy-do-super-mario-no-kubernetes)
10. [Passo 8: Acessar o Jogo](#passo-8-acessar-o-jogo)
11. [Passo 9: Limpeza e Destruição](#passo-9-limpeza-e-destruição)
12. [Custos e Free Tier](#custos-e-free-tier)
13. [Troubleshooting](#troubleshooting)

---

## 🏗️ Visão Geral da Arquitetura

### O que vamos construir:

```
┌─────────────────────────────────────────────────────────────┐
│                         AWS Cloud                             │
│                                                               │
│  ┌──────────────┐      ┌─────────────────────────────────┐  │
│  │   EC2        │      │         EKS Cluster              │  │
│  │  (Bastion)   │──────│  ┌───────────────────────────┐  │  │
│  │              │      │  │  Control Plane (EKS)      │  │  │
│  │ - Terraform  │      │  └───────────────────────────┘  │  │
│  │ - kubectl    │      │  ┌───────────────────────────┐  │  │
│  │ - AWS CLI    │      │  │  Node Group (EC2)          │  │  │
│  │ - Docker     │      │  │  ┌─────────────────────┐  │  │  │
│  └──────────────┘      │  │  │  Pod: Super Mario    │  │  │  │
│                        │  │  │  (Container)         │  │  │  │
│                        │  │  └─────────────────────┘  │  │  │
│                        │  └───────────────────────────┘  │  │
│                        │  ┌───────────────────────────┐  │  │
│                        │  │  Load Balancer (ELB)      │  │  │
│                        │  │  (Expõe o jogo)          │  │  │
│                        │  └───────────────────────────┘  │  │
│                        └─────────────────────────────────┘  │
│                                                               │
│  ┌──────────────┐                                            │
│  │  S3 Bucket   │                                            │
│  │  (Backend)   │                                            │
│  └──────────────┘                                            │
└─────────────────────────────────────────────────────────────┘
```

### Fluxo do Projeto:

1. **EC2 Bastion**: Máquina onde rodamos Terraform e kubectl para criar e gerenciar tudo
2. **Terraform**: Cria a infraestrutura (VPC, EKS, Node Groups, IAM Roles)
3. **EKS Cluster**: Kubernetes gerenciado pela AWS
4. **Node Group**: Instâncias EC2 que rodam os pods (containers)
5. **Deployment**: Define quantos pods do Super Mario queremos rodar
6. **Service**: Expõe o jogo via Load Balancer para acesso externo
7. **S3 Backend**: Armazena o estado do Terraform

---

## 📦 Pré-requisitos

### O que você precisa ter:

- ✅ **Conta AWS** (nova ou com créditos promocionais recomendado)
- ✅ **Conhecimento básico** de:
  - Linux/terminal
  - AWS (EC2, IAM, EKS)
  - Kubernetes básico
  - Terraform básico

### O que vamos instalar:

- Docker
- Terraform
- AWS CLI
- kubectl

---

## 🚀 Passo 1: Configuração Inicial da AWS

### 1.1 Login na AWS

**O que fazer:** Acesse o console da AWS como root user ou usuário com permissões administrativas.

**Por quê:** Precisamos de permissões amplas para criar EKS, EC2, IAM roles, S3, etc.

**Como fazer:**
1. Acesse https://console.aws.amazon.com
2. Faça login com suas credenciais

### 1.2 Escolher Região

**O que fazer:** Escolha uma região AWS (ex: `us-east-1`, `sa-east-1` para Brasil).

**Por quê:** Todos os recursos serão criados na mesma região. Regiões diferentes têm custos diferentes.

**Como fazer:**
- No canto superior direito do console AWS, selecione a região desejada
- **Recomendação:** `us-east-1` (mais barato) ou `sa-east-1` (menor latência no Brasil)

**⚠️ IMPORTANTE:** Anote a região escolhida! Você vai precisar dela várias vezes.

---

## 💻 Passo 2: Criação da EC2 (Máquina de Deploy)

### 2.1 Criar Instância EC2

**O que fazer:** Criar uma instância EC2 que será nossa "máquina de trabalho" onde rodamos Terraform e kubectl.

**Por quê:** No artigo original, tudo é feito dentro de uma EC2. Isso permite:
- Ter um ambiente isolado
- Não precisar instalar tudo no seu computador local
- Usar IAM Role para autenticação automática

**Como fazer:**

1. **No console AWS, vá para EC2:**
   - Busque "EC2" na barra de pesquisa
   - Clique em "EC2"

2. **Clique em "Launch Instance"**

3. **Configure a instância:**

   **Nome:**
   - Dê um nome: `mario-deploy-bastion`

   **AMI (Amazon Machine Image):**
   - Escolha: **Ubuntu Server 22.04 LTS** (ou mais recente)
   - **Por quê:** Ubuntu é estável e tem boa compatibilidade com as ferramentas que vamos instalar

   **Instance Type:**
   - Escolha: **t2.micro** ou **t3.micro** (Free Tier)
   - **Por quê:** É suficiente para rodar Terraform e kubectl. Não precisa ser potente.

   **Key Pair:**
   - Se você já tem uma key pair, selecione
   - Se não tem, clique em "Create new key pair":
     - Nome: `mario-key`
     - Tipo: RSA
     - Formato: `.pem` (OpenSSH)
     - Clique em "Create key pair"
     - **⚠️ IMPORTANTE:** Baixe o arquivo `.pem` e guarde em local seguro! Você não conseguirá acessar a EC2 sem ele.

   **Network Settings:**
   - **Allow SSH traffic from:** My IP (ou Anywhere se preferir, menos seguro)
   - **Allow HTTP traffic from the internet:** ✅ Marque
   - **Allow HTTPS traffic from the internet:** ✅ Marque
   - **Por quê:** SSH para acessar a máquina, HTTP/HTTPS caso precise acessar algo

   **Storage:**
   - Deixe o padrão (8 GB gp3) - está no Free Tier

4. **Clique em "Launch Instance"**

5. **Aguarde a instância ficar "Running"** (pode levar 1-2 minutos)

### 2.2 Conectar na EC2

**O que fazer:** Acessar a EC2 via SSH para começar a trabalhar nela.

**Como fazer:**

1. **No console EC2, selecione sua instância**

2. **Clique em "Connect" (botão no topo)**

3. **Na aba "SSH Client", copie o comando de exemplo**

4. **No seu terminal local (Mac/Linux), execute:**

```bash
# Exemplo do comando (substitua pelos seus valores):
ssh -i /caminho/para/sua/key.pem ubuntu@ec2-XX-XX-XX-XX.compute-1.amazonaws.com
```

**Explicação do comando:**
- `ssh`: comando para conectar via SSH
- `-i /caminho/para/sua/key.pem`: indica qual arquivo de chave usar (o `.pem` que você baixou)
- `ubuntu@ec2-...`: usuário `ubuntu` na máquina EC2 (endereço público da instância)

**⚠️ Se der erro de permissão:**
```bash
# No Mac/Linux, ajuste as permissões da chave:
chmod 400 /caminho/para/sua/key.pem
```

5. **Quando perguntar "Are you sure you want to continue connecting?", digite `yes`**

6. **Você deve ver algo como:**
```
Welcome to Ubuntu 22.04 LTS...
ubuntu@ip-172-31-XX-XX:~$
```

**✅ Pronto!** Você está dentro da EC2.

---

## 🛠️ Passo 3: Instalação de Ferramentas na EC2

Agora vamos instalar todas as ferramentas necessárias dentro da EC2.

### 3.1 Atualizar o Sistema

**O que fazer:** Atualizar os pacotes do Ubuntu para garantir que temos as versões mais recentes.

**Por quê:** Evita problemas de compatibilidade e bugs conhecidos.

**Comandos:**

```bash
# Tornar-se root (administrador) temporariamente
sudo su

# Atualizar lista de pacotes disponíveis
apt update -y
```

**Explicação:**
- `sudo su`: vira root (usuário administrador) para não precisar digitar `sudo` toda hora
- `apt update -y`: atualiza a lista de pacotes disponíveis (`-y` confirma automaticamente)

### 3.2 Instalar Docker

**O que fazer:** Instalar o Docker (não vamos usar diretamente, mas algumas ferramentas dependem dele).

**Por quê:** Docker é necessário para algumas operações do Kubernetes e é uma dependência comum.

**Comandos:**

```bash
# Instalar Docker
apt install docker.io -y

# Adicionar o usuário atual ao grupo docker (permite usar docker sem sudo)
usermod -aG docker $USER
# Nota: Se você está como root, substitua $USER por 'ubuntu' ou o nome do seu usuário

# Aplicar as mudanças de grupo (sem precisar fazer logout/login)
newgrp docker

# Verificar se Docker está funcionando
docker --version
```

**Explicação:**
- `apt install docker.io -y`: instala o Docker
- `usermod -aG docker $USER`: adiciona seu usuário ao grupo `docker` para usar sem `sudo`
- `newgrp docker`: aplica a mudança de grupo na sessão atual
- `docker --version`: verifica se foi instalado corretamente

**✅ Saída esperada:** `Docker version 24.x.x` ou similar

### 3.3 Instalar Terraform

**O que fazer:** Instalar o Terraform, ferramenta de Infrastructure as Code (IaC).

**Por quê:** Terraform é o que vamos usar para criar toda a infraestrutura AWS (EKS, VPC, IAM, etc).

**Comandos:**

```bash
# Instalar wget (ferramenta para baixar arquivos)
apt install wget -y

# Adicionar a chave GPG do HashiCorp (empresa que mantém Terraform)
wget -O- https://apt.releases.hashicorp.com/gpg | sudo gpg --dearmor -o /usr/share/keyrings/hashicorp-archive-keyring.gpg

# Adicionar o repositório do HashiCorp ao sistema
echo "deb [signed-by=/usr/share/keyrings/hashicorp-archive-keyring.gpg] https://apt.releases.hashicorp.com $(lsb_release -cs) main" | sudo tee /etc/apt/sources.list.d/hashicorp.list

# Atualizar lista de pacotes e instalar Terraform
apt update && apt install terraform -y

# Verificar instalação
terraform --version
```

**Explicação:**
- `wget -O- ...`: baixa a chave GPG do HashiCorp e passa para `gpg --dearmor` para processar
- `echo "deb ..." | tee ...`: adiciona o repositório oficial do HashiCorp ao sistema
- `apt update && apt install terraform -y`: atualiza pacotes e instala Terraform
- `terraform --version`: verifica se foi instalado

**✅ Saída esperada:** `Terraform v1.x.x` ou similar

### 3.4 Instalar AWS CLI

**O que fazer:** Instalar AWS CLI (Command Line Interface) para interagir com AWS via terminal.

**Por quê:** Precisamos do AWS CLI para:
- Configurar credenciais (ou usar IAM Role)
- Atualizar kubeconfig do EKS
- Verificar recursos criados

**Comandos:**

```bash
# Baixar o instalador do AWS CLI v2
curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip"

# Instalar unzip (necessário para descompactar)
apt-get install unzip -y

# Descompactar o arquivo baixado
unzip awscliv2.zip

# Instalar AWS CLI
sudo ./aws/install

# Verificar instalação
aws --version
```

**Explicação:**
- `curl ... -o "awscliv2.zip"`: baixa o instalador do AWS CLI
- `unzip awscliv2.zip`: descompacta o arquivo
- `sudo ./aws/install`: executa o instalador
- `aws --version`: verifica se foi instalado

**✅ Saída esperada:** `aws-cli/2.x.x` ou similar

### 3.5 Instalar kubectl

**O que fazer:** Instalar kubectl, ferramenta de linha de comando do Kubernetes.

**Por quê:** kubectl é o que usamos para:
- Aplicar deployments e services
- Ver status dos pods
- Obter informações do cluster

**Comandos:**

```bash
# Instalar curl (caso não tenha)
apt install curl -y

# Baixar kubectl (versão mais recente estável)
curl -LO "https://dl.k8s.io/release/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl"

# Instalar kubectl no sistema
sudo install -o root -g root -m 0755 kubectl /usr/local/bin/kubectl

# Verificar instalação
kubectl version --client
```

**Explicação:**
- `curl -LO ...`: baixa a versão mais recente estável do kubectl
- `sudo install ...`: instala o kubectl como executável no sistema
- `kubectl version --client`: verifica se foi instalado (só mostra versão do cliente, não precisa de cluster ainda)

**✅ Saída esperada:** `Client Version: version.Info{Major:"1", Minor:"xx", ...}`

### 3.6 Verificar Todas as Instalações

**Comando para verificar tudo de uma vez:**

```bash
echo "=== Verificando instalações ==="
docker --version
terraform --version
aws --version
kubectl version --client
```

**✅ Se todos os comandos retornarem versões, você está pronto para o próximo passo!**

---

## 🔐 Passo 4: Configuração IAM

### 4.1 Por que precisamos de IAM Role?

**Conceito importante:**

Quando você cria uma EC2, ela precisa de permissões para:
- Criar recursos AWS (EKS, S3, etc)
- Gerenciar esses recursos

Existem duas formas de dar essas permissões:

1. **IAM User com Access Keys** (menos seguro):
   - Criar um usuário IAM
   - Gerar Access Key e Secret Key
   - Configurar na EC2 com `aws configure`
   - ⚠️ Problema: Se alguém roubar essas chaves, pode usar sua conta

2. **IAM Role anexada à EC2** (mais seguro - vamos usar):
   - Criar uma Role IAM com as permissões necessárias
   - Anexar essa Role à instância EC2
   - A EC2 usa automaticamente essas permissões
   - ✅ Vantagem: Não precisa guardar chaves, mais seguro

### 4.2 Criar IAM Role para EC2

**O que fazer:** Criar uma Role IAM que dá permissões administrativas à EC2.

**⚠️ ATENÇÃO:** No artigo original, ele usa "Administrator Access" (permissões totais). Isso é para aprendizado. Em produção, use permissões mínimas necessárias.

**Como fazer:**

1. **No console AWS, vá para IAM:**
   - Busque "IAM" na barra de pesquisa
   - Clique em "IAM"

2. **No menu lateral, clique em "Roles"**

3. **Clique em "Create role"**

4. **Selecione "AWS service"**

5. **Em "Use case", selecione "EC2"**

6. **Clique em "Next"**

7. **Em "Permissions", procure e selecione:**
   - ✅ **AdministratorAccess**
   - **Por quê:** Dá todas as permissões necessárias para criar EKS, S3, etc.

8. **Clique em "Next"**

9. **Dê um nome à role:**
   - Nome: `EC2-EKS-Deploy-Role`
   - Descrição: `Role para EC2 criar e gerenciar recursos EKS`

10. **Clique em "Create role"**

**✅ Role criada!**

### 4.3 Anexar IAM Role à EC2

**O que fazer:** Anexar a Role que acabamos de criar à instância EC2.

**Como fazer:**

1. **Volte para o console EC2**

2. **Selecione sua instância EC2**

3. **Clique em "Actions" → "Security" → "Modify IAM role"**

4. **Selecione a role:** `EC2-EKS-Deploy-Role`

5. **Clique em "Update IAM role"**

**✅ Pronto!** Agora sua EC2 tem permissões para criar recursos AWS.

### 4.4 Verificar Permissões na EC2

**Volte para o terminal SSH da EC2 e teste:**

```bash
# Verificar se a EC2 consegue usar a role (deve mostrar informações da sua conta)
aws sts get-caller-identity
```

**Explicação:**
- `aws sts get-caller-identity`: mostra qual identidade AWS está sendo usada (deve mostrar a Role que criamos)

**✅ Saída esperada:**
```json
{
    "UserId": "AROA...",
    "Account": "123456789012",
    "Arn": "arn:aws:sts::123456789012:assumed-role/EC2-EKS-Deploy-Role/i-..."
}
```

---

## 📁 Passo 5: Preparação do Terraform

### 5.1 Criar Bucket S3 para Backend

**O que fazer:** Criar um bucket S3 para armazenar o estado do Terraform.

**Por quê:** 
- Terraform precisa guardar o estado (state) de quais recursos foram criados
- Por padrão, guarda localmente (arquivo `terraform.tfstate`)
- Usar S3 como backend permite:
  - Compartilhar estado entre equipe
  - Versionamento do estado
  - Backup automático

**Como fazer:**

1. **No console AWS, vá para S3**

2. **Clique em "Create bucket"**

3. **Configure o bucket:**
   - **Bucket name:** `mario-terraform-backend-XXXXX` (substitua XXXXX por números aleatórios, precisa ser único globalmente)
   - **AWS Region:** Escolha a mesma região que você está usando (ex: `us-east-1`)
   - **Object Ownership:** ACLs disabled (padrão)
   - **Block Public Access:** ✅ Deixe marcado (não queremos que seja público)
   - **Bucket Versioning:** ✅ Enable (recomendado, permite recuperar versões antigas)
   - **Default encryption:** ✅ Enable (recomendado)

4. **Clique em "Create bucket"**

**✅ Bucket criado!**

**⚠️ IMPORTANTE:** Anote o nome do bucket! Você vai precisar dele no próximo passo.

### 5.2 Clonar o Repositório

**O que fazer:** Baixar os arquivos Terraform do GitHub.

**Volte para o terminal SSH da EC2:**

```bash
# Criar diretório para o projeto
mkdir super_mario
cd super_mario

# Clonar o repositório do GitHub
git clone https://github.com/Aakibgithuber/Deployment-of-super-Mario-on-Kubernetes-using-terraform.git

# Entrar no diretório clonado
cd Deployment-of-super-Mario-on-Kubernetes-using-terraform

# Ver estrutura de arquivos
ls -la
```

**Explicação:**
- `mkdir super_mario`: cria diretório
- `git clone ...`: baixa o repositório do GitHub
- `ls -la`: lista arquivos (deve mostrar `EKS-TF/`, `deployment.yaml`, `service.yaml`, `README.md`)

**✅ Arquivos baixados!**

### 5.3 Configurar Backend do Terraform

**O que fazer:** Editar o arquivo `backend.tf` para usar o bucket S3 que criamos.

**Por quê:** O Terraform precisa saber onde guardar o estado. Vamos apontar para nosso bucket S3.

**Comandos:**

```bash
# Entrar na pasta EKS-TF
cd EKS-TF

# Ver conteúdo atual do backend.tf
cat backend.tf
```

**Você deve ver algo como:**
```hcl
terraform {
  backend "s3" {
    bucket = "mario12bucket"
    key    = "EKS/terraform.tfstate"
    region = "us-east-1"
  }
}
```

**Agora vamos editar:**

```bash
# Editar o arquivo (usando nano, editor simples)
nano backend.tf
```

**No editor nano:**
1. Substitua `mario12bucket` pelo nome do **seu bucket** (o que você criou no passo 5.1)
2. Se necessário, ajuste a `region` para a região que você está usando
3. Pressione `Ctrl + X` para sair
4. Digite `Y` para salvar
5. Pressione `Enter` para confirmar

**Exemplo do que deve ficar:**
```hcl
terraform {
  backend "s3" {
    bucket = "mario-terraform-backend-12345"  # SEU BUCKET AQUI
    key    = "EKS/terraform.tfstate"
    region = "us-east-1"  # SUA REGIÃO AQUI
  }
}
```

**✅ Backend configurado!**

### 5.4 Verificar Arquivos Terraform

**Vamos ver o que temos:**

```bash
# Listar arquivos na pasta EKS-TF
ls -la

# Ver conteúdo do provider.tf
cat provider.tf

# Ver conteúdo do main.tf (primeiras linhas)
head -20 main.tf
```

**Estrutura esperada:**
- `backend.tf`: Configuração do backend S3
- `provider.tf`: Configuração do provider AWS
- `variables.tf`: Definição de variáveis (região, nome do cluster, tipo de instância)
- `terraform.tfvars`: Valores das variáveis (você edita aqui para personalizar)
- `data.tf`: Data sources (busca informações da AWS - VPC, subnets)
- `eks.tf`: Recursos do EKS (cluster, IAM roles do cluster)
- `ec2.tf`: Recursos do Node Group (IAM roles dos nodes, node group)
- `main.tf`: Arquivo principal (locals, comentários explicativos)

**✅ Arquivos prontos!**

### 5.5 Configurar Variáveis (Opcional)

**O que fazer:** Personalizar configurações sem editar os arquivos `.tf`.

**Por quê:** O projeto usa variáveis para facilitar customização. Você pode mudar região, nome do cluster, tipo de instância, etc. editando apenas `terraform.tfvars`.

**Como fazer:**

```bash
# Ver valores atuais
cat terraform.tfvars
```

**Você deve ver:**
```hcl
aws_region      = "us-east-1"
cluster_name    = "EKS_CLOUD"
node_group_name = "Node-cloud"
instance_type   = "t2.medium"
```

**Para editar:**

```bash
nano terraform.tfvars
```

**Exemplos de personalização:**

- **Mudar região:**
  ```hcl
  aws_region = "sa-east-1"  # São Paulo
  ```

- **Mudar nome do cluster:**
  ```hcl
  cluster_name = "meu-cluster-mario"
  ```

- **Tentar usar free tier (pode não ter recursos suficientes):**
  ```hcl
  instance_type = "t2.micro"  # ou t3.micro
  ```

**✅ Variáveis configuradas!**

---

## 🚀 Passo 6: Deploy da Infraestrutura EKS

Agora vamos usar o Terraform para criar toda a infraestrutura!

### 6.1 Terraform Init

**O que fazer:** Inicializar o Terraform e baixar os providers necessários.

**Por quê:** Terraform precisa baixar plugins (providers) para conseguir criar recursos AWS.

**Comando:**

```bash
# Certifique-se de estar na pasta EKS-TF
cd ~/super_mario/Deployment-of-super-Mario-on-Kubernetes-using-terraform/EKS-TF

# Inicializar Terraform
terraform init
```

**Explicação:**
- `terraform init`: 
  - Lê os arquivos `.tf`
  - Baixa o provider AWS
  - Configura o backend S3
  - Prepara o ambiente

**✅ Saída esperada:**
```
Initializing the backend...
Initializing provider plugins...
Terraform has been successfully initialized!
```

**⚠️ Se der erro:** Verifique se o nome do bucket S3 está correto no `backend.tf` e se a região está certa.

### 6.2 Terraform Validate

**O que fazer:** Validar a sintaxe dos arquivos Terraform.

**Por quê:** Verifica se não há erros de sintaxe antes de tentar criar recursos.

**Comando:**

```bash
terraform validate
```

**✅ Saída esperada:** `Success! The configuration is valid.`

**⚠️ Se der erro:** Revise os arquivos `.tf` para erros de sintaxe.

### 6.3 Terraform Plan

**O que fazer:** Ver um "preview" do que o Terraform vai criar.

**Por quê:** 
- Mostra exatamente quais recursos serão criados
- Permite revisar antes de aplicar
- Estima custos (parcialmente)

**Comando:**

```bash
terraform plan
```

**Explicação:**
- `terraform plan`: 
  - Lê os arquivos `.tf`
  - Compara com o estado atual (vazio, primeira vez)
  - Mostra plano de execução

**✅ Saída esperada:** Uma lista de recursos que serão criados:
```
Plan: X to add, 0 to change, 0 to destroy.

Terraform will perform the following actions:

  # aws_eks_cluster.example will be created
  + resource "aws_eks_cluster" "example" {
      + name = "EKS_CLOUD"
      ...
    }

  # aws_eks_node_group.example will be created
  + resource "aws_eks_node_group" "example" {
      + cluster_name = "EKS_CLOUD"
      ...
    }

  ...
```

**⚠️ IMPORTANTE:** Revise o plano! Veja especialmente:
- Nome do cluster: `EKS_CLOUD`
- Tipo de instância do node group: `t2.medium` (pode gerar custo)
- Região: deve estar correta

### 6.4 Terraform Apply

**O que fazer:** Criar de fato toda a infraestrutura.

**Por quê:** É aqui que o Terraform realmente cria os recursos na AWS.

**⚠️ ATENÇÃO:** Este passo pode levar **10-15 minutos** e vai gerar custos!

**Comando:**

```bash
terraform apply --auto-approve
```

**Explicação:**
- `terraform apply`: cria/modifica recursos
- `--auto-approve`: não pede confirmação (senão ele pergunta "Do you want to perform these actions?")

**O que vai acontecer:**

1. **Criação de IAM Roles:**
   - Role para o cluster EKS
   - Role para os nodes (instâncias EC2)

2. **Criação do Cluster EKS:**
   - Control plane do Kubernetes
   - Isso leva ~10 minutos

3. **Criação do Node Group:**
   - Instâncias EC2 que rodam os pods
   - Isso leva ~5 minutos

**✅ Saída esperada (no final):**
```
Apply complete! Resources: X added, 0 changed, 0 destroyed.

Outputs:
...
```

**⏱️ Tempo estimado:** 10-15 minutos

**💰 Custo:** 
- EKS Control Plane: ~$0.10/hora (começa a contar agora!)
- EC2 Nodes: depende do tipo (t2.medium não é free tier)

### 6.5 Verificar Recursos Criados

**Vamos verificar se tudo foi criado:**

```bash
# Ver estado do Terraform
terraform show

# Listar recursos criados
terraform state list
```

**No console AWS, verifique:**

1. **EKS:**
   - Vá para "Elastic Kubernetes Service"
   - Deve ver cluster `EKS_CLOUD` com status "Active"

2. **EC2:**
   - Vá para "EC2" → "Instances"
   - Deve ver instâncias do Node Group rodando

3. **IAM:**
   - Vá para "IAM" → "Roles"
   - Deve ver roles criadas pelo Terraform

**✅ Infraestrutura criada!**

---

## 🎮 Passo 7: Deploy do Super Mario no Kubernetes

Agora vamos fazer o deploy do jogo Super Mario no cluster EKS!

### 7.1 Configurar kubectl para o EKS

**O que fazer:** Configurar o kubectl para se conectar ao cluster EKS que acabamos de criar.

**Por quê:** kubectl precisa saber como se conectar ao cluster. O comando abaixo atualiza o arquivo `~/.kube/config`.

**Comando:**

```bash
# Atualizar kubeconfig (substitua a região se necessário)
aws eks update-kubeconfig --name EKS_CLOUD --region us-east-1
```

**Explicação:**
- `aws eks update-kubeconfig`: comando AWS CLI que configura kubectl
- `--name EKS_CLOUD`: nome do cluster (definido no `main.tf`)
- `--region us-east-1`: região onde o cluster foi criado

**✅ Saída esperada:**
```
Added new context arn:aws:eks:us-east-1:...:cluster/EKS_CLOUD to /home/ubuntu/.kube/config
```

### 7.2 Verificar Conexão com o Cluster

**Vamos testar se conseguimos falar com o cluster:**

```bash
# Ver informações do cluster
kubectl cluster-info

# Ver nodes (instâncias EC2 do cluster)
kubectl get nodes
```

**✅ Saída esperada:**
```
NAME                          STATUS   ROLES    AGE   VERSION
ip-172-31-XX-XX.ec2.internal  Ready    <none>   5m    v1.xx.x-eks-xxxxx
```

**Se aparecer "Ready", está funcionando!**

### 7.3 Aplicar Deployment

**O que fazer:** Criar o Deployment do Super Mario (define quantos pods queremos rodar).

**Por quê:** Deployment é o recurso Kubernetes que gerencia os pods (containers) do nosso jogo.

**Primeiro, vamos ver o arquivo:**

```bash
# Voltar para a pasta raiz do projeto
cd ~/super_mario/Deployment-of-super-Mario-on-Kubernetes-using-terraform

# Ver conteúdo do deployment.yaml
cat deployment.yaml
```

**Conteúdo esperado:**
```yaml
apiVersion: apps/v1
kind: Deployment
metadata:
  name: mario-deployment
spec:
  replicas: 2  # Quantidade de pods
  selector:
    matchLabels:
      app: mario
  template:
    metadata:
      labels:
        app: mario
    spec:
      containers:
      - name: mario-container
        image: sevenajay/mario:latest
        ports:
        - containerPort: 80
```

**Explicação do arquivo:**
- `replicas: 2`: queremos 2 pods rodando (2 instâncias do jogo)
- `image: sevenajay/mario:latest`: imagem Docker do Super Mario (já existe no Docker Hub)
- `containerPort: 80`: porta que o container expõe

**Agora vamos aplicar:**

```bash
# Aplicar o deployment
kubectl apply -f deployment.yaml
```

**Explicação:**
- `kubectl apply -f deployment.yaml`: lê o arquivo YAML e cria/atualiza os recursos no cluster

**✅ Saída esperada:**
```
deployment.apps/mario-deployment created
```

### 7.4 Verificar Status do Deployment

**Vamos ver se os pods estão rodando:**

```bash
# Ver deployments
kubectl get deployments

# Ver pods (pode levar alguns segundos para ficarem "Running")
kubectl get pods

# Ver detalhes dos pods
kubectl get pods -o wide
```

**✅ Saída esperada:**
```
NAME                                READY   STATUS    RESTARTS   AGE
mario-deployment-xxxxx-xxxxx         1/1     Running   0          30s
mario-deployment-xxxxx-xxxxx         1/1     Running   0          30s
```

**⏱️ Aguarde até todos os pods ficarem "Running" (pode levar 1-2 minutos)**

### 7.5 Aplicar Service (Load Balancer)

**O que fazer:** Criar um Service do tipo LoadBalancer para expor o jogo na internet.

**Por quê:** 
- Os pods estão rodando, mas não são acessíveis externamente
- Service do tipo LoadBalancer cria um Load Balancer na AWS
- Isso permite acessar o jogo via URL pública

**Vamos ver o arquivo:**

```bash
# Ver conteúdo do service.yaml
cat service.yaml
```

**Conteúdo esperado:**
```yaml
apiVersion: v1
kind: Service
metadata:
  name: mario-service
spec:
  type: LoadBalancer
  selector:
    app: mario
  ports:
  - protocol: TCP
    port: 80
    targetPort: 80
```

**Explicação:**
- `type: LoadBalancer`: cria um Load Balancer na AWS (gera custo adicional)
- `selector: app: mario`: conecta este service aos pods com label `app: mario`
- `port: 80`: porta externa
- `targetPort: 80`: porta do container

**Agora vamos aplicar:**

```bash
# Aplicar o service
kubectl apply -f service.yaml
```

**✅ Saída esperada:**
```
service/mario-service created
```

### 7.6 Aguardar Load Balancer Ficar Pronto

**O Load Balancer leva alguns minutos para ser criado. Vamos monitorar:**

```bash
# Ver status do service (repita até ver EXTERNAL-IP preenchido)
kubectl get service mario-service

# Ou ver detalhes completos
kubectl describe service mario-service
```

**⏱️ Aguarde 2-5 minutos até ver algo como:**

```
NAME            TYPE           CLUSTER-IP      EXTERNAL-IP                                                              PORT(S)        AGE
mario-service   LoadBalancer   10.100.XX.XX    a1b2c3d4e5f6g7h8-1234567890.us-east-1.elb.amazonaws.com   80:XXXXX/TCP   3m
```

**✅ Quando `EXTERNAL-IP` aparecer, está pronto!**

---

## 🌐 Passo 8: Acessar o Jogo

### 8.1 Obter URL do Load Balancer

**Comando:**

```bash
# Obter apenas a URL externa
kubectl get service mario-service -o jsonpath='{.status.loadBalancer.ingress[0].hostname}'
echo  # Pula uma linha
```

**Ou:**

```bash
# Ver detalhes completos
kubectl describe service mario-service
```

**Procure por "LoadBalancer Ingress" ou "EXTERNAL-IP"**

**Exemplo de URL:**
```
a1b2c3d4e5f6g7h8-1234567890.us-east-1.elb.amazonaws.com
```

### 8.2 Acessar no Navegador

**O que fazer:** Abrir o jogo no navegador.

**Como fazer:**

1. **Copie a URL do Load Balancer** (do passo anterior)

2. **Cole no navegador:**
   ```
   http://a1b2c3d4e5f6g7h8-1234567890.us-east-1.elb.amazonaws.com
   ```
   (Use `http://`, não `https://`)

3. **Aguarde alguns segundos** (primeira requisição pode demorar)

4. **🎮 Você deve ver o jogo Super Mario rodando!**

**✅ Pronto! O jogo está funcionando!**

### 8.3 Verificar Recursos no Console AWS

**Para entender melhor o que foi criado:**

1. **EC2 → Load Balancers:**
   - Deve ver um Load Balancer criado pelo EKS

2. **EC2 → Target Groups:**
   - Deve ver um Target Group apontando para os pods

3. **EKS → Clusters → EKS_CLOUD → Workloads:**
   - Deve ver o deployment `mario-deployment`
   - Deve ver o service `mario-service`

---

## 🧹 Passo 9: Limpeza e Destruição

**⚠️ IMPORTANTE:** Após testar, **DESTRUA TUDO** para evitar custos desnecessários!

### 9.1 Deletar Deployment e Service

**O que fazer:** Remover o jogo do cluster antes de destruir a infraestrutura.

**Por quê:** É uma boa prática limpar os recursos do Kubernetes antes de destruir o cluster.

**Comandos:**

```bash
# Deletar o service (isso também deleta o Load Balancer)
kubectl delete service mario-service

# Deletar o deployment
kubectl delete deployment mario-deployment

# Verificar se foi deletado
kubectl get all
```

**✅ Aguarde alguns minutos até o Load Balancer ser deletado**

### 9.2 Destruir Infraestrutura com Terraform

**O que fazer:** Usar Terraform para deletar todos os recursos criados.

**⚠️ ATENÇÃO:** Isso vai deletar:
- Cluster EKS
- Node Groups (instâncias EC2)
- IAM Roles criadas pelo Terraform
- Load Balancers (se ainda existirem)

**Comandos:**

```bash
# Voltar para a pasta EKS-TF
cd ~/super_mario/Deployment-of-super-Mario-on-Kubernetes-using-terraform/EKS-TF

# Ver o que será destruído (opcional, mas recomendado)
terraform plan -destroy

# Destruir tudo
terraform destroy --auto-approve
```

**Explicação:**
- `terraform plan -destroy`: mostra o que será destruído (preview)
- `terraform destroy --auto-approve`: deleta todos os recursos sem pedir confirmação

**⏱️ Tempo estimado:** 5-10 minutos

**✅ Saída esperada:**
```
Destroy complete! Resources: X destroyed.
```

### 9.3 Verificar Limpeza no Console AWS

**Verifique manualmente que tudo foi deletado:**

1. **EKS:** Não deve ter clusters
2. **EC2 → Instances:** Não deve ter instâncias do Node Group
3. **EC2 → Load Balancers:** Não deve ter Load Balancers
4. **IAM → Roles:** Roles criadas pelo Terraform devem ter sido deletadas

### 9.4 Deletar Bucket S3 (Opcional)

**⚠️ ATENÇÃO:** O Terraform **NÃO** deleta o bucket S3 automaticamente (para proteger o estado).

**Se quiser deletar o bucket também:**

1. **Vá para S3 no console AWS**
2. **Selecione o bucket** (`mario-terraform-backend-XXXXX`)
3. **Clique em "Empty"** (esvaziar primeiro)
4. **Depois clique em "Delete"**

**Ou via CLI:**

```bash
# Listar objetos no bucket
aws s3 ls s3://mario-terraform-backend-XXXXX/

# Deletar todos os objetos
aws s3 rm s3://mario-terraform-backend-XXXXX/ --recursive

# Deletar o bucket
aws s3 rb s3://mario-terraform-backend-XXXXX/
```

### 9.5 Terminar Instância EC2 (Bastion)

**Último passo:** Terminar a instância EC2 que usamos para deploy.

**Como fazer:**

1. **No console EC2, selecione a instância** (`mario-deploy-bastion`)
2. **Clique em "Instance state" → "Terminate instance"**
3. **Confirme**

**✅ Tudo destruído! Sem custos adicionais!**

---

## 💰 Custos e Free Tier

### Recursos que GERAM CUSTO:

| Recurso | Custo Aproximado | Free Tier? |
|---------|------------------|------------|
| **EKS Control Plane** | ~$0.10/hora | ❌ Não |
| **EC2 Node Group (t2.medium)** | ~$0.0464/hora | ❌ Não (t2.micro seria free tier, mas pode não ser suficiente) |
| **Load Balancer (ELB)** | ~$0.0225/hora + tráfego | ❌ Não |
| **S3 Backend** | ~$0.023/GB/mês | ✅ Sim (primeiros 5GB) |
| **EC2 Bastion (t2.micro)** | ~$0.0116/hora | ✅ Sim (750h/mês free tier) |

### Estimativa de Custo Total:

**Para 1 hora de uso:**
- EKS: $0.10
- Node Group (t2.medium): $0.0464
- Load Balancer: $0.0225
- **Total: ~$0.17/hora**

**Para 1 dia (24h):**
- **Total: ~$4.08/dia**

**⚠️ IMPORTANTE:** 
- EKS cobra **mesmo quando não está sendo usado** (enquanto o cluster existir)
- **SEMPRE destrua tudo após testar!**

### Como Minimizar Custos:

1. ✅ Use instâncias menores (t2.micro/t3.micro) se possível
2. ✅ Destrua tudo imediatamente após testar
3. ✅ Use a mesma região (evita transferência de dados)
4. ✅ Configure AWS Budgets para alertas

### Configurar Alertas de Custo:

**No console AWS:**

1. Vá para **Billing & Cost Management**
2. Clique em **Budgets**
3. Clique em **Create budget**
4. Escolha **Cost budget**
5. Configure:
   - Nome: `EKS-Mario-Alert`
   - Valor: `$5` (ou o que preferir)
   - Período: Mensal
6. Configure alertas (ex: 80% do orçamento)

**✅ Agora você receberá alertas se passar do limite!**

---

## 🔧 Troubleshooting

### Problema: `terraform init` falha

**Erro:** `Error: Failed to get existing workspaces`

**Solução:**
- Verifique se o bucket S3 existe e o nome está correto no `backend.tf`
- Verifique se a região está correta
- Verifique permissões IAM da EC2

### Problema: `terraform apply` falha com erro de IAM

**Erro:** `Error creating EKS Cluster: AccessDenied`

**Solução:**
- Verifique se a IAM Role está anexada à EC2
- Verifique se a Role tem permissões `AdministratorAccess`
- Execute `aws sts get-caller-identity` para verificar identidade

### Problema: Pods não ficam "Running"

**Erro:** Pods ficam em "Pending" ou "CrashLoopBackOff"

**Solução:**
```bash
# Ver logs dos pods
kubectl logs <nome-do-pod>

# Ver eventos do cluster
kubectl get events

# Ver detalhes do pod
kubectl describe pod <nome-do-pod>
```

**Possíveis causas:**
- Node Group não tem recursos suficientes
- Imagem Docker não consegue ser baixada
- Problemas de rede

### Problema: Load Balancer não aparece

**Erro:** `EXTERNAL-IP` fica `<pending>`

**Solução:**
- Aguarde 5-10 minutos (criação de LB demora)
- Verifique se há subnets públicas na VPC
- Verifique logs: `kubectl describe service mario-service`

### Problema: Não consigo acessar o jogo no navegador

**Solução:**
- Verifique se copiou a URL correta (com `http://`)
- Aguarde alguns minutos após criar o service
- Verifique se o Load Balancer está "Active" no console EC2
- Tente acessar via IP do Load Balancer (se disponível)

### Problema: `terraform destroy` não deleta tudo

**Solução:**
- Alguns recursos podem ter dependências
- Delete manualmente no console AWS:
  - Load Balancers
  - Target Groups
  - Security Groups órfãs
- Execute `terraform destroy` novamente

---

## 📚 Conceitos Aprendidos

Ao final deste projeto, você aprendeu:

1. ✅ **Terraform**: Infrastructure as Code (IaC)
2. ✅ **EKS**: Kubernetes gerenciado na AWS
3. ✅ **Kubernetes**: Deployments, Services, Pods
4. ✅ **AWS**: EC2, IAM Roles, S3, Load Balancers
5. ✅ **Docker**: Containers e imagens
6. ✅ **kubectl**: Gerenciamento de clusters Kubernetes
7. ✅ **AWS CLI**: Automação via linha de comando

---

## 🎓 Próximos Passos

Agora que você completou o projeto, pode:

1. **Modificar o deployment:**
   - Aumentar número de replicas
   - Mudar a imagem Docker
   - Adicionar variáveis de ambiente

2. **Melhorar segurança:**
   - Usar IAM Roles com permissões mínimas
   - Adicionar Security Groups mais restritivos
   - Usar HTTPS no Load Balancer

3. **Adicionar CI/CD:**
   - GitHub Actions para deploy automático
   - Testes automatizados

4. **Monitoramento:**
   - CloudWatch para logs
   - Prometheus + Grafana para métricas

---

## 📝 Notas Finais

- Este projeto é para **aprendizado**. Em produção, use práticas mais seguras.
- **Sempre destrua recursos** após testar para evitar custos.
- **Monitore custos** regularmente na AWS.
- **Backup do estado Terraform** está no S3 (pode recuperar se necessário).

---

## 🙏 Créditos

- **Artigo original:** [Aakib Khan - Medium](https://aakibkhan1.medium.com/project-6-deployment-of-super-mario-on-kubernetes-using-terraform-74c7ce79b1f6)
- **Repositório GitHub:** [Aakibgithuber/Deployment-of-super-Mario-on-Kubernetes-using-terraform](https://github.com/Aakibgithuber/Deployment-of-super-Mario-on-Kubernetes-using-terraform)
- **Imagem Docker:** `sevenajay/mario:latest`

---

**Boa sorte e divirta-se aprendendo! 🚀🎮**
