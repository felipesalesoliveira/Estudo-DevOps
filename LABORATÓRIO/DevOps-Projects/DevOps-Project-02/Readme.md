# Implantar Arquitetura de VPC Escalável na AWS Cloud
**AWS-Cloud**

---

## SUMÁRIO
- Objetivo
- Pré-requisitos
- Pré-implantação
- Implantação da VPC
- Validação

---

## Objetivo
Implantar uma **arquitetura de rede virtual modular e escalável** utilizando o **Amazon VPC**.

---

## Pré-requisitos
- É necessário possuir uma **conta AWS** para criar recursos de infraestrutura na nuvem AWS.
- **Código-fonte**

---

## Pré-implantação
Personalize as dependências da aplicação mencionadas abaixo em uma instância **AWS EC2** e crie a **Golden AMI**.

### Dependências
- **AWS CLI**
- **Apache Web Server**
- **Git**
- **CloudWatch Agent**
  - Enviar métricas personalizadas de memória para o CloudWatch
- **AWS SSM Agent**

---

## Implantação da VPC

- Criar a rede VPC **(192.168.0.0/16)** para a implantação do **Bastion Host**, conforme a arquitetura apresentada.
- Criar a rede VPC **(172.32.0.0/16)** para a implantação de servidores de aplicação **altamente disponíveis e com Auto Scaling**, conforme a arquitetura apresentada.
- Criar um **NAT Gateway** na **Subnet Pública** e atualizar a **Route Table associada à Subnet Privada**, direcionando o tráfego padrão para o NAT Gateway para permitir acesso de saída à internet.
- Criar um **Transit Gateway** e associar ambas as VPCs para permitir comunicação privada entre elas.
- Criar um **Internet Gateway (IGW)** para cada VPC e atualizar a **Route Table associada à Subnet Pública**, direcionando o tráfego padrão para permitir acesso de entrada e saída à internet.
- Criar um **CloudWatch Log Group** com **dois Log Streams** para armazenar os **VPC Flow Logs** de ambas as VPCs.
- Habilitar **VPC Flow Logs** para ambas as VPCs e enviar os logs para o **CloudWatch**, armazenando-os em seus respectivos **Log Streams**.
- Criar um **Security Group** para o **Bastion Host**, permitindo acesso à **porta 22 (SSH)** a partir da internet pública.
- Implantar uma instância **EC2 Bastion Host** na **Subnet Pública**, com um **Elastic IP (EIP)** associado.
- Criar um **S3 Bucket** para armazenar configurações específicas da aplicação.

---

## Launch Configuration

Criar uma **Launch Configuration** com as seguintes configurações:

- **Golden AMI**
- **Tipo de Instância:** `t2.micro`
- **User Data:**
  - Clonar o código da aplicação a partir de um repositório **Bitbucket**
  - Copiar o código para o diretório raiz do web server
  - Iniciar o serviço **httpd**
- **IAM Role:**
  - Conceder acesso ao **AWS Session Manager**
  - Conceder acesso ao **S3 Bucket** criado anteriormente
  - ⚠️ **Não conceder acesso total ao S3 (S3 Full Access)**
- **Security Group:**
  - Permitir **porta 22** a partir do Bastion Host
  - Permitir **porta 80** a partir da internet pública
- **Key Pair**

---

## Auto Scaling e Load Balancing

- Criar um **Auto Scaling Group (ASG)** com:
  - **Mínimo:** 2
  - **Máximo:** 4
  - Associado a **duas Subnets Privadas** nas **Availability Zones 1a e 1b**
- Criar um **Target Group** e associá-lo ao **ASG**.
- Criar um **Network Load Balancer (NLB)** na **Subnet Pública**.
- Adicionar o **Target Group** ao **NLB**.
- Atualizar a **Hosted Zone do Route 53** com um registro **CNAME**, direcionando o tráfego para o **NLB**.

---

## Validação

- Como **Engenheiro DevOps**, acessar as instâncias privadas por meio do **Bastion Host**.
- Utilizar o **AWS Session Manager** para acessar o shell das instâncias EC2 diretamente pelo console da AWS.
- Acessar a aplicação web a partir de um navegador na internet pública utilizando o **nome de domínio** e verificar se a página foi carregada corretamente.

---

## 🛠️ Autor & Comunidade
Este projeto foi desenvolvido por **Harshhaa** 💡  
