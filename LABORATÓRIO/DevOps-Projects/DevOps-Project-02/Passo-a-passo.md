# Laboratório: Arquitetura de VPC Modular e Escalável na AWS

## 📑 Table of Contents

* Goal
* Pre-Requisites
* Pre-Deployment
* VPC Deployment
* Validation

---

## 🎯 Goal

Deploy de uma **arquitetura de rede virtual modular e escalável** utilizando **Amazon VPC**.

---

## ✅ Pre-Requisites

* Possuir uma **conta AWS** para criação de recursos de infraestrutura na nuvem.
* **Código-fonte (Source Code)** da aplicação.

---

## ⚙️ Pre-Deployment

Customizar as dependências da aplicação listadas abaixo em uma instância **AWS EC2** e criar uma **Golden AMI**.

### Dependências a serem instaladas na EC2

* **AWS CLI**
* **Apache Web Server**
* **Git**
* **CloudWatch Agent**

  * Enviar métricas customizadas de memória para o CloudWatch
* **AWS SSM Agent**

---

## 🌐 VPC Deployment

### Arquitetura de Rede

1. Criar uma **VPC (192.168.0.0/16)** para o deploy do **Bastion Host**, conforme a arquitetura definida.
2. Criar uma **VPC (172.32.0.0/16)** para o deploy de **servidores de aplicação altamente disponíveis e auto escaláveis**, conforme a arquitetura definida.

---

### Componentes de Rede

3. Criar um **NAT Gateway** na **Subnet Pública** e atualizar a **Route Table** da **Subnet Privada**, direcionando o tráfego padrão para o NAT Gateway para acesso de saída à internet.
4. Criar um **Transit Gateway** e associar **ambas as VPCs** para permitir **comunicação privada entre VPCs**.
5. Criar um **Internet Gateway (IGW)** para cada VPC e atualizar a **Route Table da Subnet Pública**, roteando o tráfego padrão para o IGW para acesso de entrada e saída da internet.

---

### Logs e Monitoramento

6. Criar um **CloudWatch Log Group** com **dois Log Streams** para armazenar os **VPC Flow Logs** de ambas as VPCs.
7. Habilitar **Flow Logs** para as duas VPCs e enviar os logs para o **CloudWatch Log Group**, armazenando os logs no **Log Stream correspondente a cada VPC**.

---

### Segurança e Acesso

8. Criar um **Security Group** para o **Bastion Host**, permitindo acesso **SSH (porta 22)** a partir da internet.
9. Realizar o deploy de uma **instância EC2 Bastion Host** na **Subnet Pública**, com **Elastic IP (EIP)** associado.

---

### Aplicação

10. Criar um **Bucket S3** para armazenar configurações específicas da aplicação.
11. Criar uma **Launch Configuration** com as seguintes definições:

* **Golden AMI**
* **Tipo de instância:** `t2.micro`
* **User Data**:

  * Clonar o código do **repositório Bitbucket**
  * Copiar os arquivos para o **Document Root** do servidor web
  * Iniciar o serviço **httpd**
* **IAM Role**:

  * Permissão para **AWS Session Manager**
  * Permissão de acesso **somente ao bucket S3 criado** (não conceder S3 Full Access)
* **Security Group**:

  * Porta **22** permitida apenas a partir do **Bastion Host**
  * Porta **80** permitida a partir da internet pública
* **Key Pair**

---

### Auto Scaling e Load Balancer

12. Criar um **Auto Scaling Group (ASG)** com:

* **Mínimo:** 2 instâncias
* **Máximo:** 4 instâncias
* Associado a **duas Subnets Privadas**, nas zonas **1a e 1b**

13. Criar um **Target Group** e associá-lo ao **ASG**.
14. Criar um **Network Load Balancer (NLB)** na **Subnet Pública** e associar o **Target Group** a ele.
15. Atualizar a **Hosted Zone do Route 53**, criando um **registro CNAME** apontando para o **NLB**.

---

## ✔️ Validation

* Acessar as **instâncias privadas via Bastion Host** como **DevOps Engineer**.
* Acessar a instância EC2 utilizando o **AWS Session Manager** diretamente pelo console da AWS.
* Acessar a aplicação web via **navegador**, utilizando o **nome de domínio público**, e validar o carregamento correto da aplicação.
