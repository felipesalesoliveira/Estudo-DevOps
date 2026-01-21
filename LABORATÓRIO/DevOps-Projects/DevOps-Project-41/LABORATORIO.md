# 🎓 Laboratório: Super Mario no EKS - Guia Completo do Zero

**Este guia assume que você NÃO sabe NADA sobre Terraform, AWS ou Kubernetes.**

Vamos aprender tudo do zero, passo a passo, como se fosse uma aula prática.

---

## 📚 Índice do Laboratório

### Parte 1: Preparação do Ambiente
1. [O que vamos aprender?](#o-que-vamos-aprender)
2. [O que você precisa ter](#o-que-você-precisa-ter)
3. [Criar conta AWS](#criar-conta-aws)
4. [Instalar Terraform (do zero)](#instalar-terraform-do-zero)
5. [Instalar AWS CLI (do zero)](#instalar-aws-cli-do-zero)
6. [Configurar AWS CLI](#configurar-aws-cli)

### Parte 2: Entendendo os Conceitos Básicos
7. [O que é Terraform?](#o-que-é-terraform)
8. [O que é AWS?](#o-que-é-aws)
9. [O que é Kubernetes/EKS?](#o-que-é-kuberneteseks)
10. [O que vamos construir?](#o-que-vamos-construir)

### Parte 3: Preparação na AWS
11. [Criar EC2 (máquina virtual)](#criar-ec2-máquina-virtual)
12. [Conectar na EC2](#conectar-na-ec2)
13. [Instalar ferramentas na EC2](#instalar-ferramentas-na-ec2)
14. [Criar IAM Role (permissões)](#criar-iam-role-permissões)
15. [Criar Bucket S3 (armazenamento)](#criar-bucket-s3-armazenamento)

### Parte 4: Trabalhando com Terraform
16. [Entender a estrutura dos arquivos](#entender-a-estrutura-dos-arquivos)
17. [Configurar Terraform](#configurar-terraform)
18. [Primeiros comandos Terraform](#primeiros-comandos-terraform)
19. [Criar infraestrutura](#criar-infraestrutura)

### Parte 5: Kubernetes e Deploy
20. [Entender Kubernetes básico](#entender-kubernetes-básico)
21. [Configurar kubectl](#configurar-kubectl)
22. [Deploy do Super Mario](#deploy-do-super-mario)
23. [Acessar o jogo](#acessar-o-jogo)

### Parte 6: Limpeza e Próximos Passos
24. [Destruir tudo](#destruir-tudo)
25. [O que aprendemos?](#o-que-aprendemos)
26. [Próximos passos](#próximos-passos)

---

## 🎯 Parte 1: Preparação do Ambiente

### O que vamos aprender?

Ao final deste laboratório, você vai saber:

- ✅ **Terraform**: Criar infraestrutura escrevendo código
- ✅ **AWS**: Usar serviços de nuvem (EC2, EKS, S3, IAM)
- ✅ **Kubernetes**: Deploy de aplicações em containers
- ✅ **DevOps**: Automatizar criação de infraestrutura

**Tempo estimado:** 3-4 horas (com pausas para aprender)

---

### O que você precisa ter?

#### Antes de começar, você precisa:

1. **Computador com:**
   - Windows, Mac ou Linux
   - Acesso à internet
   - Terminal/Command Prompt funcionando

2. **Conta AWS:**
   - Pode ser conta nova (free tier disponível)
   - Cartão de crédito (para verificação, mas vamos minimizar custos)

3. **Tempo:**
   - 3-4 horas para fazer tudo
   - Pode dividir em várias sessões

4. **Conhecimento:**
   - **ZERO** de conhecimento técnico necessário!
   - Vamos aprender tudo aqui

---

### Criar conta AWS

**Se você já tem conta AWS, pule para a próxima seção.**

#### Passo 1: Acessar site da AWS

1. Abra seu navegador
2. Vá para: https://aws.amazon.com
3. Clique em **"Criar uma conta gratuita"** (ou "Sign Up")

#### Passo 2: Preencher dados

1. **Email:** Use um email válido (você vai receber confirmação)
2. **Senha:** Crie uma senha forte
3. **Nome da conta:** Escolha um nome (ex: "meu-laboratorio")

#### Passo 3: Informações de pagamento

⚠️ **IMPORTANTE:** A AWS pede cartão de crédito, mas:
- Você tem **12 meses de free tier**
- Vamos usar recursos que geram custo, mas **sempre destruiremos tudo**
- Configure alertas de custo (vamos ensinar)

1. Preencha dados do cartão
2. Confirme o pagamento (pode ser $0 se usar só free tier)

#### Passo 4: Verificação de telefone

1. Escolha seu país
2. Digite seu número de telefone
3. Receba código SMS
4. Digite o código

#### Passo 5: Escolher plano

1. Escolha **"Plano Básico"** (gratuito)
2. Clique em **"Continuar"**

#### Passo 6: Confirmação

1. Verifique seu email
2. Clique no link de confirmação
3. Faça login na AWS

**✅ Pronto! Você tem uma conta AWS!**

---

### Instalar Terraform (do zero)

**O que é Terraform?** (vamos explicar melhor depois, mas por enquanto: é uma ferramenta que cria infraestrutura escrevendo código)

#### No Windows:

**Opção 1: Usando Chocolatey (mais fácil)**

1. **Instalar Chocolatey primeiro:**
   - Abra PowerShell **como Administrador**
   - Cole este comando:
   ```powershell
   Set-ExecutionPolicy Bypass -Scope Process -Force; [System.Net.ServicePointManager]::SecurityProtocol = [System.Net.ServicePointManager]::SecurityProtocol -bor 3072; iex ((New-Object System.Net.WebClient).DownloadString('https://community.chocolatey.org/install.ps1'))
   ```
   - Pressione Enter
   - Aguarde instalação

2. **Instalar Terraform:**
   ```powershell
   choco install terraform -y
   ```

3. **Verificar instalação:**
   ```powershell
   terraform --version
   ```
   - Deve mostrar: `Terraform v1.x.x`

**Opção 2: Download manual**

1. Acesse: https://www.terraform.io/downloads
2. Baixe a versão para Windows (64-bit)
3. Extraia o arquivo ZIP
4. Coloque o arquivo `terraform.exe` em uma pasta (ex: `C:\terraform`)
5. Adicione essa pasta ao PATH do Windows:
   - Pressione `Win + R`
   - Digite: `sysdm.cpl` e pressione Enter
   - Aba "Avançado" → "Variáveis de Ambiente"
   - Em "Variáveis do sistema", encontre "Path" → "Editar"
   - "Novo" → Cole o caminho da pasta (ex: `C:\terraform`)
   - OK em tudo

6. **Verificar:**
   - Abra novo PowerShell
   - Digite: `terraform --version`

#### No Mac:

**Opção 1: Usando Homebrew (mais fácil)**

1. **Instalar Homebrew (se não tiver):**
   ```bash
   /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
   ```

2. **Instalar Terraform:**
   ```bash
   brew install terraform
   ```

3. **Verificar:**
   ```bash
   terraform --version
   ```

**Opção 2: Download manual**

1. Acesse: https://www.terraform.io/downloads
2. Baixe a versão para Mac (AMD64 ou ARM64, dependendo do seu Mac)
3. Extraia o arquivo
4. Mova para `/usr/local/bin/`:
   ```bash
   sudo mv terraform /usr/local/bin/
   ```

5. **Verificar:**
   ```bash
   terraform --version
   ```

#### No Linux (Ubuntu/Debian):

```bash
# Atualizar sistema
sudo apt update

# Instalar dependências
sudo apt install -y wget unzip

# Baixar Terraform
wget https://releases.hashicorp.com/terraform/1.6.0/terraform_1.6.0_linux_amd64.zip

# Extrair
unzip terraform_1.6.0_linux_amd64.zip

# Mover para /usr/local/bin
sudo mv terraform /usr/local/bin/

# Verificar
terraform --version

# Limpar arquivo baixado
rm terraform_1.6.0_linux_amd64.zip
```

**✅ Se `terraform --version` funcionou, você instalou corretamente!**

---

### Instalar AWS CLI (do zero)

**O que é AWS CLI?** É uma ferramenta de linha de comando para falar com a AWS sem usar o navegador.

#### No Windows:

1. **Baixar instalador:**
   - Acesse: https://awscli.amazonaws.com/AWSCLIV2.msi
   - Baixe o arquivo `.msi`

2. **Instalar:**
   - Execute o arquivo `.msi`
   - Siga o assistente de instalação
   - Clique em "Next" até terminar

3. **Verificar:**
   - Abra novo PowerShell
   - Digite: `aws --version`
   - Deve mostrar: `aws-cli/2.x.x`

#### No Mac:

**Opção 1: Usando Homebrew:**

```bash
brew install awscli
```

**Opção 2: Download manual:**

```bash
# Baixar
curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip"

# Extrair
unzip awscliv2.zip

# Instalar
sudo ./aws/install

# Verificar
aws --version
```

#### No Linux:

```bash
# Baixar
curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip"

# Instalar unzip (se não tiver)
sudo apt install unzip -y

# Extrair
unzip awscliv2.zip

# Instalar
sudo ./aws/install

# Verificar
aws --version

# Limpar
rm -rf aws awscliv2.zip
```

**✅ Se `aws --version` funcionou, você instalou corretamente!**

---

### Configurar AWS CLI

Agora vamos conectar o AWS CLI com sua conta AWS.

#### Passo 1: Obter credenciais AWS

1. **No navegador, acesse:** https://console.aws.amazon.com
2. **Faça login** na sua conta
3. **No canto superior direito**, clique no seu nome → **"Security credentials"**
4. **Role até "Access keys"**
5. **Clique em "Create access key"**
6. **Escolha "Command Line Interface (CLI)"**
7. **Marque a caixa de confirmação**
8. **Clique em "Next"**
9. **Clique em "Create access key"**
10. **⚠️ IMPORTANTE:** Copie e guarde:
    - **Access Key ID**
    - **Secret Access Key** (só aparece uma vez!)

**Guarde essas credenciais em local seguro!**

#### Passo 2: Configurar AWS CLI

No terminal/PowerShell, execute:

```bash
aws configure
```

Vai perguntar 4 coisas:

1. **AWS Access Key ID:** Cole o Access Key ID que você copiou
2. **AWS Secret Access Key:** Cole o Secret Access Key que você copiou
3. **Default region name:** Digite `us-east-1` (ou outra região que preferir)
4. **Default output format:** Digite `json` (ou apenas pressione Enter)

**Exemplo:**
```
AWS Access Key ID [None]: AKIAIOSFODNN7EXAMPLE
AWS Secret Access Key [None]: wJalrXUtnFEMI/K7MDENG/bPxRfiCYEXAMPLEKEY
Default region name [None]: us-east-1
Default output format [None]: json
```

#### Passo 3: Testar configuração

```bash
aws sts get-caller-identity
```

**✅ Deve mostrar algo como:**
```json
{
    "UserId": "AIDA...",
    "Account": "123456789012",
    "Arn": "arn:aws:iam::123456789012:user/seu-usuario"
}
```

**Se funcionou, você está conectado à AWS!**

---

## 🧠 Parte 2: Entendendo os Conceitos Básicos

### O que é Terraform?

**Terraform** é uma ferramenta de **Infrastructure as Code (IaC)**.

**Traduzindo:** Em vez de criar servidores clicando no navegador, você escreve código que descreve o que quer criar, e o Terraform cria tudo automaticamente.

**Analogia:** 
- **Antes:** Você vai na loja, escolhe móveis, pede para entregar, monta tudo manualmente
- **Com Terraform:** Você escreve uma "lista de compras" (código), Terraform vai na loja, compra tudo e monta automaticamente

**Vantagens:**
- ✅ Reproduzível (sempre cria igual)
- ✅ Versionável (pode salvar no Git)
- ✅ Rápido (cria tudo de uma vez)
- ✅ Documentado (o código explica o que faz)

**Exemplo de código Terraform:**
```hcl
resource "aws_instance" "servidor" {
  ami           = "ami-12345"
  instance_type = "t2.micro"
}
```

Isso cria uma instância EC2 (servidor virtual) na AWS.

---

### O que é AWS?

**AWS (Amazon Web Services)** é a plataforma de nuvem da Amazon.

**Traduzindo:** Em vez de comprar servidores físicos, você aluga servidores virtuais na nuvem.

**Serviços que vamos usar:**

1. **EC2:** Servidores virtuais (máquinas na nuvem)
2. **EKS:** Kubernetes gerenciado (orquestra containers)
3. **S3:** Armazenamento de arquivos (como Google Drive, mas para código)
4. **IAM:** Controle de acesso (quem pode fazer o quê)
5. **VPC:** Rede virtual (como sua rede de casa, mas na nuvem)

**Analogia:**
- **AWS** = Shopping center gigante
- **EC2** = Loja de computadores
- **EKS** = Loja de organização de containers
- **S3** = Loja de armazenamento
- **IAM** = Segurança do shopping

---

### O que é Kubernetes/EKS?

**Kubernetes** é um sistema para gerenciar **containers** (aplicações empacotadas).

**Traduzindo:** Kubernetes organiza e gerencia seus aplicativos que rodam em containers.

**EKS (Elastic Kubernetes Service)** é o Kubernetes gerenciado pela AWS.

**Analogia:**
- **Container** = Caixa com sua aplicação dentro
- **Kubernetes** = Sistema que organiza essas caixas, garante que sempre tenham o suficiente, distribui carga, etc.
- **EKS** = Kubernetes já configurado e gerenciado pela AWS (você não precisa instalar do zero)

**Por que usar?**
- ✅ Escala automaticamente (se precisa de mais, cria mais)
- ✅ Alta disponibilidade (se um cai, outros continuam)
- ✅ Fácil de atualizar (troca containers sem parar tudo)

---

### O que vamos construir?

Vamos criar esta arquitetura:

```
┌─────────────────────────────────────────────────┐
│              AWS Cloud                          │
│                                                 │
│  ┌─────────────┐    ┌──────────────────────┐  │
│  │   EC2       │    │    EKS Cluster       │  │
│  │  (Bastion) │───▶│  ┌────────────────┐  │  │
│  │            │    │  │ Control Plane  │  │  │
│  │ Terraform  │    │  └────────────────┘  │  │
│  │ kubectl    │    │  ┌────────────────┐  │  │
│  │ AWS CLI    │    │  │  Node Group     │  │  │
│  └────────────┘    │  │  ┌────────────┐ │  │  │
│                    │  │  │ Pod: Mario │ │  │  │
│                    │  │  └────────────┘ │  │  │
│                    │  └────────────────┘  │  │
│                    │  ┌────────────────┐  │  │
│                    │  │ Load Balancer  │  │  │
│                    │  └────────────────┘  │  │
│                    └──────────────────────┘  │
│                                                 │
│  ┌─────────────┐                               │
│  │  S3 Bucket  │                               │
│  │  (Backend)  │                               │
│  └─────────────┘                               │
└─────────────────────────────────────────────────┘
```

**Em palavras simples:**

1. **EC2 Bastion:** Máquina onde rodamos comandos (Terraform, kubectl)
2. **EKS Cluster:** Kubernetes gerenciado pela AWS
3. **Node Group:** Instâncias EC2 que rodam os containers
4. **Pod:** Container rodando o jogo Super Mario
5. **Load Balancer:** Distribui tráfego e expõe o jogo na internet
6. **S3:** Guarda o estado do Terraform

---

## 🖥️ Parte 3: Preparação na AWS

### Criar EC2 (máquina virtual)

Vamos criar uma máquina virtual na AWS para rodar nossos comandos.

#### Passo 1: Acessar console EC2

1. **No navegador, acesse:** https://console.aws.amazon.com
2. **Faça login**
3. **Na barra de busca**, digite: `EC2`
4. **Clique em "EC2"**

#### Passo 2: Escolher região

**No canto superior direito**, escolha a região:
- **Recomendado:** `us-east-1` (N. Virginia) - mais barata
- **Ou:** `sa-east-1` (São Paulo) - menor latência no Brasil

**⚠️ IMPORTANTE:** Anote qual região escolheu! Você vai precisar várias vezes.

#### Passo 3: Criar instância

1. **No menu lateral**, clique em **"Instances"**
2. **Clique em "Launch instance"** (botão laranja)

#### Passo 4: Configurar instância

**Nome e tags:**
- **Name:** `mario-deploy-bastion`

**Application and OS Images (AMI):**
- Escolha: **Ubuntu Server 22.04 LTS** (ou mais recente)
- **Por quê:** Ubuntu é estável e fácil de usar

**Instance type:**
- Escolha: **t2.micro** ou **t3.micro**
- **Por quê:** Está no free tier (750h/mês grátis)
- **O que é:** Tipo de máquina virtual (CPU, RAM)

**Key pair (login):**
- **Se você já tem uma key pair:** Selecione no dropdown
- **Se não tem:**
  - Clique em **"Create new key pair"**
  - **Name:** `mario-key`
  - **Key pair type:** RSA
  - **Private key file format:** `.pem` (OpenSSH)
  - **Clique em "Create key pair"**
  - **⚠️ IMPORTANTE:** O arquivo `.pem` será baixado automaticamente
  - **Guarde esse arquivo em local seguro!** Você não conseguirá acessar a EC2 sem ele

**Network settings:**
- **Allow SSH traffic from:** 
  - Escolha **"My IP"** (mais seguro)
  - Ou **"Anywhere"** (menos seguro, mas funciona de qualquer lugar)
- **Allow HTTP traffic from the internet:** ✅ **Marque**
- **Allow HTTPS traffic from the internet:** ✅ **Marque**

**Configure storage:**
- Deixe o padrão: **8 GB gp3**
- Está no free tier

#### Passo 5: Lançar instância

1. **Role até o final da página**
2. **Clique em "Launch instance"**
3. **Aguarde alguns segundos**
4. **Clique em "View all instances"**

#### Passo 6: Aguardar instância ficar pronta

1. **Na lista de instâncias**, você verá sua instância
2. **Status:** Pode estar "Pending" (criando)
3. **Aguarde até ficar "Running"** (rodando)
   - Pode levar 1-2 minutos
   - Atualize a página se necessário

**✅ Quando estiver "Running", está pronta!**

---

### Conectar na EC2

Agora vamos acessar a EC2 via SSH (como se fosse um terminal remoto).

#### No Windows:

**Opção 1: Usando PowerShell (Windows 10/11)**

1. **Abra PowerShell**
2. **Navegue até a pasta onde está o arquivo `.pem`**:
   ```powershell
   cd C:\Users\SeuUsuario\Downloads
   ```
   (ou onde você salvou o arquivo)

3. **Ajustar permissões da chave:**
   ```powershell
   icacls mario-key.pem /inheritance:r
   icacls mario-key.pem /grant:r "%username%:R"
   ```

4. **Obter endereço público da EC2:**
   - No console AWS → EC2 → Instances
   - Selecione sua instância
   - Copie o **"Public IPv4 address"** (ex: `54.123.45.67`)

5. **Conectar:**
   ```powershell
   ssh -i mario-key.pem ubuntu@SEU-IP-AQUI
   ```
   Substitua `SEU-IP-AQUI` pelo IP que você copiou.

6. **Quando perguntar "Are you sure...", digite:** `yes`

7. **Você deve ver:**
   ```
   Welcome to Ubuntu 22.04 LTS...
   ubuntu@ip-172-31-XX-XX:~$
   ```

**Opção 2: Usando PuTTY (alternativa)**

1. Baixe PuTTY: https://www.putty.org/
2. Baixe PuTTYgen: https://www.putty.org/
3. Converta `.pem` para `.ppk` usando PuTTYgen
4. Use PuTTY para conectar

#### No Mac/Linux:

1. **Abra Terminal**

2. **Navegue até a pasta onde está o arquivo `.pem`**:
   ```bash
   cd ~/Downloads
   ```
   (ou onde você salvou)

3. **Ajustar permissões da chave:**
   ```bash
   chmod 400 mario-key.pem
   ```

4. **Obter endereço público da EC2:**
   - No console AWS → EC2 → Instances
   - Selecione sua instância
   - Copie o **"Public IPv4 address"**

5. **Conectar:**
   ```bash
   ssh -i mario-key.pem ubuntu@SEU-IP-AQUI
   ```
   Substitua `SEU-IP-AQUI` pelo IP.

6. **Quando perguntar "Are you sure...", digite:** `yes`

7. **Você deve ver:**
   ```
   Welcome to Ubuntu 22.04 LTS...
   ubuntu@ip-172-31-XX-XX:~$
   ```

**✅ Se você viu a mensagem de boas-vindas do Ubuntu, está conectado!**

---

### Instalar ferramentas na EC2

Agora vamos instalar todas as ferramentas necessárias dentro da EC2.

**⚠️ IMPORTANTE:** Você deve estar conectado na EC2 via SSH (terminal aberto).

#### Passo 1: Atualizar sistema

```bash
# Tornar-se root (administrador)
sudo su

# Atualizar lista de pacotes
apt update -y
```

**Explicação:**
- `sudo su`: vira administrador (não precisa digitar `sudo` toda hora)
- `apt update -y`: atualiza lista de pacotes (`-y` confirma automaticamente)

#### Passo 2: Instalar Docker

```bash
# Instalar Docker
apt install docker.io -y

# Adicionar usuário ao grupo docker
usermod -aG docker ubuntu

# Aplicar mudanças de grupo
newgrp docker

# Verificar instalação
docker --version
```

**✅ Deve mostrar:** `Docker version 24.x.x` ou similar

#### Passo 3: Instalar Terraform

```bash
# Instalar wget
apt install wget -y

# Adicionar chave GPG do HashiCorp
wget -O- https://apt.releases.hashicorp.com/gpg | sudo gpg --dearmor -o /usr/share/keyrings/hashicorp-archive-keyring.gpg

# Adicionar repositório HashiCorp
echo "deb [signed-by=/usr/share/keyrings/hashicorp-archive-keyring.gpg] https://apt.releases.hashicorp.com $(lsb_release -cs) main" | sudo tee /etc/apt/sources.list.d/hashicorp.list

# Atualizar e instalar Terraform
apt update && apt install terraform -y

# Verificar
terraform --version
```

**✅ Deve mostrar:** `Terraform v1.x.x`

#### Passo 4: Instalar AWS CLI

```bash
# Baixar AWS CLI
curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip"

# Instalar unzip
apt-get install unzip -y

# Extrair
unzip awscliv2.zip

# Instalar
sudo ./aws/install

# Verificar
aws --version
```

**✅ Deve mostrar:** `aws-cli/2.x.x`

#### Passo 5: Instalar kubectl

```bash
# Instalar curl (se não tiver)
apt install curl -y

# Baixar kubectl
curl -LO "https://dl.k8s.io/release/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl"

# Instalar
sudo install -o root -g root -m 0755 kubectl /usr/local/bin/kubectl

# Verificar
kubectl version --client
```

**✅ Deve mostrar versão do kubectl**

#### Passo 6: Verificar tudo

```bash
echo "=== Verificando instalações ==="
docker --version
terraform --version
aws --version
kubectl version --client
```

**✅ Se todos mostraram versões, está tudo instalado!**

---

### Criar IAM Role (permissões)

Agora vamos criar uma "role" (função) que dá permissões à EC2 para criar recursos AWS.

**O que é IAM Role?** É como dar uma "carteira de identidade" à EC2 dizendo "essa máquina pode criar EKS, S3, etc."

#### Passo 1: Acessar IAM

1. **No console AWS**, busque: `IAM`
2. **Clique em "IAM"**

#### Passo 2: Criar Role

1. **No menu lateral**, clique em **"Roles"**
2. **Clique em "Create role"**

#### Passo 3: Escolher tipo de role

1. **Em "Trusted entity type"**, escolha: **"AWS service"**
2. **Em "Use case"**, escolha: **"EC2"**
3. **Clique em "Next"**

#### Passo 4: Escolher permissões

1. **Na busca**, digite: `AdministratorAccess`
2. **Marque a caixa** ao lado de **"AdministratorAccess"**
3. **Clique em "Next"**

**⚠️ ATENÇÃO:** Em produção, use permissões mínimas. Aqui usamos AdministratorAccess para aprendizado.

#### Passo 5: Nomear role

1. **Role name:** `EC2-EKS-Deploy-Role`
2. **Description:** `Role para EC2 criar e gerenciar recursos EKS`
3. **Clique em "Create role"**

**✅ Role criada!**

#### Passo 6: Anexar role à EC2

1. **Volte para EC2** (busque `EC2` no console)
2. **Selecione sua instância** (`mario-deploy-bastion`)
3. **Clique em "Actions"** → **"Security"** → **"Modify IAM role"**
4. **Selecione:** `EC2-EKS-Deploy-Role`
5. **Clique em "Update IAM role"**

**✅ Role anexada!**

#### Passo 7: Verificar na EC2

**Volte para o terminal SSH da EC2** e execute:

```bash
aws sts get-caller-identity
```

**✅ Deve mostrar informações da role:**
```json
{
    "UserId": "AROA...",
    "Account": "123456789012",
    "Arn": "arn:aws:sts::...:assumed-role/EC2-EKS-Deploy-Role/..."
}
```

**Se funcionou, a EC2 tem permissões!**

---

### Criar Bucket S3 (armazenamento)

Vamos criar um "bucket" S3 para guardar o estado do Terraform.

**O que é S3?** É como um "Google Drive" da AWS, mas para arquivos de código/infraestrutura.

**O que é "estado do Terraform"?** É um arquivo que guarda informações sobre o que foi criado (para Terraform saber o que já existe).

#### Passo 1: Acessar S3

1. **No console AWS**, busque: `S3`
2. **Clique em "S3"**

#### Passo 2: Criar bucket

1. **Clique em "Create bucket"**

#### Passo 3: Configurar bucket

**General configuration:**
- **Bucket name:** `mario-terraform-backend-XXXXX`
  - Substitua `XXXXX` por números aleatórios (ex: `mario-terraform-backend-12345`)
  - **⚠️ IMPORTANTE:** O nome precisa ser único globalmente (em toda AWS)
  - Se der erro "nome já existe", tente outro número

**AWS Region:**
- Escolha a **mesma região** que você está usando (ex: `us-east-1`)

**Object Ownership:**
- Deixe padrão: **"ACLs disabled"**

**Block Public Access settings:**
- ✅ **Deixe tudo marcado** (não queremos público)

**Bucket Versioning:**
- ✅ **Enable** (permite recuperar versões antigas)

**Default encryption:**
- ✅ **Enable**
- **Encryption type:** **"Amazon S3 managed keys (SSE-S3)"**

#### Passo 4: Criar

1. **Role até o final**
2. **Clique em "Create bucket"**

**✅ Bucket criado!**

**⚠️ IMPORTANTE:** Anote o nome do bucket! Você vai precisar no próximo passo.

---

## 📝 Parte 4: Trabalhando com Terraform

### Entender a estrutura dos arquivos

Agora vamos entender como os arquivos Terraform estão organizados.

**Volte para o terminal SSH da EC2** e vamos baixar os arquivos do projeto:

```bash
# Criar diretório
mkdir super_mario
cd super_mario

# Clonar repositório (ou copiar arquivos se você já tem)
git clone https://github.com/Aakibgithuber/Deployment-of-super-Mario-on-Kubernetes-using-terraform.git

# Entrar no diretório
cd Deployment-of-super-Mario-on-Kubernetes-using-terraform

# Ver estrutura
ls -la
```

**Você deve ver:**
```
EKS-TF/
deployment.yaml
service.yaml
README.md
```

**Vamos ver o que tem dentro de `EKS-TF/`:**

```bash
cd EKS-TF
ls -la
```

**Estrutura esperada:**
```
backend.tf      # Configuração do backend S3
data.tf         # Data sources (busca informações da AWS)
eks.tf          # Recursos do EKS (cluster, IAM do cluster)
ec2.tf          # Recursos do Node Group (IAM dos nodes, node group)
main.tf         # Arquivo principal (locals, comentários)
provider.tf     # Configuração do provider AWS
variables.tf    # Definição de variáveis
terraform.tfvars # Valores das variáveis (você edita aqui)
```

**Vamos entender cada arquivo:**

#### `provider.tf`
- **O que faz:** Configura qual "provedor" usar (AWS) e a região
- **Não precisa editar:** Já está configurado

#### `backend.tf`
- **O que faz:** Diz ao Terraform onde guardar o estado (S3)
- **⚠️ PRECISA EDITAR:** Você vai colocar o nome do seu bucket aqui

#### `variables.tf`
- **O que faz:** Define quais variáveis existem (como "declaração de variáveis")
- **Não precisa editar:** Já está definido

#### `terraform.tfvars`
- **O que faz:** Define os **valores** das variáveis (como "atribuição de valores")
- **Pode editar:** Para mudar região, nome do cluster, tipo de instância, etc.

#### `data.tf`
- **O que faz:** Busca informações da AWS (VPC padrão, subnets)
- **Não precisa editar:** Já está configurado

#### `eks.tf`
- **O que faz:** Cria o cluster EKS e IAM roles necessárias
- **Não precisa editar:** Já está configurado

#### `ec2.tf`
- **O que faz:** Cria o Node Group (instâncias EC2 que rodam os pods)
- **Não precisa editar:** Já está configurado

#### `main.tf`
- **O que faz:** Arquivo principal (locals, comentários explicativos)
- **Não precisa editar:** Já está configurado

---

### Configurar Terraform

Agora vamos configurar o Terraform para usar seu bucket S3.

#### Passo 1: Editar backend.tf

```bash
# Ver conteúdo atual
cat backend.tf
```

**Você deve ver:**
```hcl
terraform {
  backend "s3" {
    bucket = "SEU-BUCKET-AQUI"
    key    = "EKS/terraform.tfstate"
    region = "us-east-1"
  }
}
```

**Vamos editar:**

```bash
# Editar o arquivo
nano backend.tf
```

**No editor nano:**
1. Use as setas para navegar
2. Substitua `SEU-BUCKET-AQUI` pelo **nome do seu bucket** (ex: `mario-terraform-backend-12345`)
3. Se necessário, ajuste a `region` para a região onde criou o bucket
4. Pressione `Ctrl + X` para sair
5. Digite `Y` para salvar
6. Pressione `Enter` para confirmar

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

#### Passo 2: Verificar terraform.tfvars (opcional)

```bash
# Ver valores atuais
cat terraform.tfvars
```

**Você pode editar se quiser mudar:**
- Região
- Nome do cluster
- Tipo de instância

**Para editar:**
```bash
nano terraform.tfvars
```

**Valores padrão:**
```hcl
aws_region      = "us-east-1"
cluster_name    = "EKS_CLOUD"
node_group_name = "Node-cloud"
instance_type   = "t2.medium"
```

**✅ Configuração pronta!**

---

### Primeiros comandos Terraform

Agora vamos aprender os comandos básicos do Terraform.

#### Comando 1: `terraform init`

**O que faz:** Inicializa o Terraform, baixa providers, configura backend.

```bash
terraform init
```

**O que acontece:**
1. Terraform lê os arquivos `.tf`
2. Baixa o provider AWS
3. Configura o backend S3
4. Prepara o ambiente

**✅ Saída esperada:**
```
Initializing the backend...
Initializing provider plugins...
Terraform has been successfully initialized!
```

**⏱️ Tempo:** 30 segundos - 1 minuto

**⚠️ Se der erro:** Verifique se o nome do bucket no `backend.tf` está correto.

#### Comando 2: `terraform validate`

**O que faz:** Valida a sintaxe dos arquivos Terraform.

```bash
terraform validate
```

**✅ Saída esperada:**
```
Success! The configuration is valid.
```

**⚠️ Se der erro:** Revise os arquivos `.tf` para erros de sintaxe.

#### Comando 3: `terraform plan`

**O que faz:** Mostra um "preview" do que será criado (sem criar de fato).

```bash
terraform plan
```

**O que acontece:**
1. Terraform lê os arquivos `.tf`
2. Compara com o estado atual (vazio, primeira vez)
3. Mostra plano de execução

**✅ Saída esperada:**
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
      ...
    }

  ...
```

**⏱️ Tempo:** 1-2 minutos

**⚠️ IMPORTANTE:** Revise o plano! Veja especialmente:
- Nome do cluster
- Tipo de instância
- Região

**💡 Dica:** Você pode salvar o plano em arquivo:
```bash
terraform plan -out=tfplan
```

---

### Criar infraestrutura

Agora vamos criar de fato toda a infraestrutura!

**⚠️ ATENÇÃO:** Este passo vai gerar custos (~$0.17/hora enquanto rodando).

#### Passo 1: Aplicar Terraform

```bash
terraform apply --auto-approve
```

**O que faz:** Cria todos os recursos definidos nos arquivos `.tf`.

**O que acontece:**
1. Terraform cria IAM Roles
2. Cria cluster EKS (leva ~10 minutos)
3. Cria Node Group (leva ~5 minutos)

**⏱️ Tempo total:** 10-15 minutos

**💰 Custo:** ~$0.17/hora enquanto rodando

**✅ Saída esperada (no final):**
```
Apply complete! Resources: X added, 0 changed, 0 destroyed.

Outputs:
...
```

**⏳ Durante a execução, você verá:**
```
aws_iam_role.eks_cluster_role: Creating...
aws_iam_role.eks_cluster_role: Creation complete after 2s
aws_eks_cluster.example: Creating...
aws_eks_cluster.example: Still creating... [10s elapsed]
...
```

**⚠️ IMPORTANTE:** 
- **NÃO feche o terminal** durante a execução
- **NÃO interrompa** o processo (Ctrl+C)
- **Aguarde** até ver "Apply complete!"

#### Passo 2: Verificar recursos criados

**No console AWS, verifique:**

1. **EKS:**
   - Busque `EKS` → Clusters
   - Deve ver `EKS_CLOUD` com status "Active"

2. **EC2:**
   - Busque `EC2` → Instances
   - Deve ver instâncias do Node Group rodando

3. **IAM:**
   - Busque `IAM` → Roles
   - Deve ver roles criadas pelo Terraform

**✅ Se tudo foi criado, está funcionando!**

---

## 🎮 Parte 5: Kubernetes e Deploy

### Entender Kubernetes básico

Antes de fazer o deploy, vamos entender conceitos básicos do Kubernetes.

#### O que é um Pod?

**Pod** = Um ou mais containers rodando juntos.

**Analogia:** Pod = Caixa com sua aplicação dentro.

#### O que é um Deployment?

**Deployment** = Define quantos pods queremos rodar e como atualizar.

**Analogia:** Deployment = Instruções: "Quero 2 caixas rodando, se uma cair, cria outra".

#### O que é um Service?

**Service** = Expõe os pods para acesso externo.

**Analogia:** Service = Porteiro que direciona tráfego para as caixas certas.

**Tipos de Service:**
- **ClusterIP:** Acesso apenas dentro do cluster
- **NodePort:** Acesso via porta do node
- **LoadBalancer:** Cria Load Balancer na AWS (expõe na internet)

---

### Configurar kubectl

Agora vamos configurar o kubectl para se conectar ao cluster EKS.

**⚠️ IMPORTANTE:** Você deve estar na EC2 via SSH.

#### Passo 1: Atualizar kubeconfig

```bash
# Atualizar configuração do kubectl
aws eks update-kubeconfig --name EKS_CLOUD --region us-east-1
```

**O que faz:** Configura o kubectl para se conectar ao cluster EKS.

**Substitua:**
- `EKS_CLOUD` pelo nome do seu cluster (se mudou no `terraform.tfvars`)
- `us-east-1` pela sua região

**✅ Saída esperada:**
```
Added new context arn:aws:eks:us-east-1:...:cluster/EKS_CLOUD to /home/ubuntu/.kube/config
```

#### Passo 2: Verificar conexão

```bash
# Ver informações do cluster
kubectl cluster-info
```

**✅ Deve mostrar:**
```
Kubernetes control plane is running at https://...
```

#### Passo 3: Ver nodes

```bash
# Ver nodes (instâncias EC2 do cluster)
kubectl get nodes
```

**✅ Deve mostrar:**
```
NAME                          STATUS   ROLES    AGE   VERSION
ip-172-31-XX-XX.ec2.internal  Ready    <none>   5m    v1.xx.x-eks-xxxxx
```

**Se aparecer "Ready", está funcionando!**

---

### Deploy do Super Mario

Agora vamos fazer o deploy do jogo Super Mario!

#### Passo 1: Ver arquivos de deploy

**Volte para a pasta raiz do projeto:**

```bash
cd ~/super_mario/Deployment-of-super-Mario-on-Kubernetes-using-terraform

# Ver arquivos
ls -la
```

**Você deve ver:**
```
deployment.yaml
service.yaml
```

#### Passo 2: Ver conteúdo do deployment.yaml

```bash
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

**Explicação:**
- `replicas: 2`: Queremos 2 pods rodando
- `image: sevenajay/mario:latest`: Imagem Docker do Super Mario (já existe no Docker Hub)
- `containerPort: 80`: Porta que o container expõe

#### Passo 3: Aplicar deployment

```bash
kubectl apply -f deployment.yaml
```

**O que faz:** Cria o deployment no cluster.

**✅ Saída esperada:**
```
deployment.apps/mario-deployment created
```

#### Passo 4: Verificar pods

```bash
# Ver pods (pode levar alguns segundos para ficarem "Running")
kubectl get pods

# Ver detalhes
kubectl get pods -o wide

# Watch mode (atualiza automaticamente)
kubectl get pods -w
```
(Pressione `Ctrl+C` para sair do watch mode)

**✅ Saída esperada:**
```
NAME                                READY   STATUS    RESTARTS   AGE
mario-deployment-xxxxx-xxxxx         1/1     Running   0          30s
mario-deployment-xxxxx-xxxxx         1/1     Running   0          30s
```

**⏱️ Aguarde até todos ficarem "Running" (pode levar 1-2 minutos)**

**Se algum pod ficar em "Pending" ou "Error":**
```bash
# Ver detalhes do pod
kubectl describe pod <nome-do-pod>

# Ver logs
kubectl logs <nome-do-pod>
```

#### Passo 5: Ver conteúdo do service.yaml

```bash
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
- `type: LoadBalancer`: Cria um Load Balancer na AWS
- `selector: app: mario`: Conecta aos pods com label `app: mario`
- `port: 80`: Porta externa
- `targetPort: 80`: Porta do container

#### Passo 6: Aplicar service

```bash
kubectl apply -f service.yaml
```

**✅ Saída esperada:**
```
service/mario-service created
```

#### Passo 7: Aguardar Load Balancer

**O Load Balancer leva alguns minutos para ser criado:**

```bash
# Ver status do service (repita até ver EXTERNAL-IP preenchido)
kubectl get service mario-service

# Ou ver detalhes completos
kubectl describe service mario-service
```

**⏱️ Aguarde 2-5 minutos até ver:**

```
NAME            TYPE           CLUSTER-IP      EXTERNAL-IP                                                              PORT(S)        AGE
mario-service   LoadBalancer   10.100.XX.XX    a1b2c3d4e5f6g7h8-1234567890.us-east-1.elb.amazonaws.com   80:XXXXX/TCP   3m
```

**✅ Quando `EXTERNAL-IP` aparecer, está pronto!**

---

### Acessar o jogo

Agora vamos acessar o jogo no navegador!

#### Passo 1: Obter URL do Load Balancer

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

**Procure por "LoadBalancer Ingress"**

**Exemplo de URL:**
```
a1b2c3d4e5f6g7h8-1234567890.us-east-1.elb.amazonaws.com
```

#### Passo 2: Acessar no navegador

1. **Copie a URL** do Load Balancer
2. **Abra seu navegador**
3. **Cole a URL** com `http://` na frente:
   ```
   http://a1b2c3d4e5f6g7h8-1234567890.us-east-1.elb.amazonaws.com
   ```
   (Use `http://`, não `https://`)

4. **Aguarde alguns segundos** (primeira requisição pode demorar)

5. **🎮 Você deve ver o jogo Super Mario rodando!**

**✅ Pronto! O jogo está funcionando!**

#### Passo 3: Testar o jogo

- Use as setas do teclado para mover o Mario
- Pressione espaço para pular
- Divirta-se!

---

## 🧹 Parte 6: Limpeza e Próximos Passos

### Destruir tudo

**⚠️ IMPORTANTE:** Após testar, **DESTRUA TUDO** para evitar custos desnecessários!

#### Passo 1: Deletar Service e Deployment

**Na EC2 via SSH:**

```bash
# Deletar o service (isso também deleta o Load Balancer)
kubectl delete service mario-service

# Deletar o deployment
kubectl delete deployment mario-deployment

# Verificar se foi deletado
kubectl get all
```

**⏱️ Aguarde alguns minutos até o Load Balancer ser deletado**

#### Passo 2: Destruir infraestrutura Terraform

```bash
# Voltar para pasta EKS-TF
cd ~/super_mario/Deployment-of-super-Mario-on-Kubernetes-using-terraform/EKS-TF

# Ver o que será destruído (opcional)
terraform plan -destroy

# Destruir tudo
terraform destroy --auto-approve
```

**O que faz:** Deleta todos os recursos criados pelo Terraform.

**⏱️ Tempo:** 5-10 minutos

**✅ Saída esperada:**
```
Destroy complete! Resources: X destroyed.
```

#### Passo 3: Verificar limpeza

**No console AWS, verifique:**

1. **EKS:** Não deve ter clusters
2. **EC2 → Instances:** Não deve ter instâncias do Node Group
3. **EC2 → Load Balancers:** Não deve ter Load Balancers
4. **IAM → Roles:** Roles criadas pelo Terraform devem ter sido deletadas

#### Passo 4: Deletar Bucket S3 (Opcional)

**⚠️ ATENÇÃO:** O Terraform **NÃO** deleta o bucket S3 automaticamente.

**Se quiser deletar:**

1. **Vá para S3** no console AWS
2. **Selecione o bucket**
3. **Clique em "Empty"** (esvaziar primeiro)
4. **Depois clique em "Delete"**

#### Passo 5: Terminar EC2 Bastion

**Último passo:**

1. **No console EC2**, selecione a instância
2. **Clique em "Instance state" → "Terminate instance"**
3. **Confirme**

**✅ Tudo destruído! Sem custos adicionais!**

---

### O que aprendemos?

Parabéns! Você completou o laboratório! 🎉

#### Conceitos aprendidos:

1. ✅ **Terraform:**
   - Infrastructure as Code (IaC)
   - Comandos básicos (`init`, `plan`, `apply`, `destroy`)
   - Estrutura de arquivos (`.tf`, `.tfvars`)
   - Variáveis e valores

2. ✅ **AWS:**
   - EC2 (instâncias virtuais)
   - EKS (Kubernetes gerenciado)
   - S3 (armazenamento)
   - IAM (permissões)
   - Load Balancers

3. ✅ **Kubernetes:**
   - Pods (containers)
   - Deployments (gerenciamento de pods)
   - Services (exposição de serviços)
   - kubectl (ferramenta de linha de comando)

4. ✅ **DevOps:**
   - Automatização de infraestrutura
   - Deploy de aplicações
   - Gerenciamento de estado

---

### Próximos passos

Agora que você completou o laboratório, pode:

#### 1. Experimentar modificações:

- **Aumentar número de pods:**
  - Edite `deployment.yaml`: `replicas: 3`
  - Aplique: `kubectl apply -f deployment.yaml`

- **Mudar tipo de instância:**
  - Edite `terraform.tfvars`: `instance_type = "t3.small"`
  - Aplique: `terraform apply`

- **Mudar região:**
  - Edite `terraform.tfvars`: `aws_region = "sa-east-1"`
  - Aplique: `terraform apply`

#### 2. Aprender mais:

- **Terraform:**
  - Documentação oficial: https://www.terraform.io/docs
  - Tutoriais: https://learn.hashicorp.com/terraform

- **AWS:**
  - Documentação: https://docs.aws.amazon.com
  - AWS Well-Architected: https://aws.amazon.com/architecture/well-architected/

- **Kubernetes:**
  - Documentação: https://kubernetes.io/docs
  - Tutoriais: https://kubernetes.io/docs/tutorials/

#### 3. Próximos projetos:

- Deploy de aplicação própria
- CI/CD com GitHub Actions
- Monitoramento com CloudWatch
- Segurança com Security Groups mais restritivos

---

## 🆘 Troubleshooting

### Problema: `terraform init` falha

**Erro:** `Error: Failed to get existing workspaces`

**Solução:**
- Verifique se o bucket S3 existe
- Verifique se o nome do bucket no `backend.tf` está correto
- Verifique se a região está correta
- Verifique permissões IAM da EC2

### Problema: `terraform apply` falha com erro de IAM

**Erro:** `Error creating EKS Cluster: AccessDenied`

**Solução:**
- Verifique se a IAM Role está anexada à EC2
- Verifique se a Role tem `AdministratorAccess`
- Execute `aws sts get-caller-identity` para verificar identidade

### Problema: Pods não ficam "Running"

**Solução:**
```bash
# Ver logs dos pods
kubectl logs <nome-do-pod>

# Ver eventos
kubectl get events

# Ver detalhes
kubectl describe pod <nome-do-pod>
```

**Possíveis causas:**
- Node Group não tem recursos suficientes
- Imagem Docker não consegue ser baixada
- Problemas de rede

### Problema: Load Balancer não aparece

**Solução:**
- Aguarde 5-10 minutos (criação de LB demora)
- Verifique se há subnets públicas na VPC
- Verifique logs: `kubectl describe service mario-service`

### Problema: Não consigo acessar o jogo

**Solução:**
- Verifique se copiou a URL correta (com `http://`)
- Aguarde alguns minutos após criar o service
- Verifique se o Load Balancer está "Active" no console EC2
- Tente acessar via IP do Load Balancer (se disponível)

---

## 📞 Suporte

**Se tiver dúvidas:**

1. Revise esta documentação
2. Consulte `README.md` para detalhes técnicos
3. Consulte `COMANDOS-RAPIDOS.md` para referência de comandos
4. Consulte `GUIA-CUSTOS.md` para entender custos

---

**Parabéns por completar o laboratório! 🎉🚀**

**Agora você tem conhecimento prático de Terraform, AWS e Kubernetes!**
