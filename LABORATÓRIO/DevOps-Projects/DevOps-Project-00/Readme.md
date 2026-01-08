# Skills

As habilidades abaixo são necessárias para completar este laboratório:

- Terraform (Providers, Resources, Variables, Outputs, State)
- Infraestrutura como Código (IaC)
- Conceitos de Cloud (VPC, Subnets, Security Groups)
- Kubernetes (conceitos básicos de Cluster)
- AWS (IAM, EC2, EKS – conceitos)

---

# Pré-requisitos

Antes de iniciar este laboratório, certifique-se de ter:

- Conta na AWS ativa
- AWS CLI configurada (`aws configure`)
- Terraform instalado (>= 1.x)
- Conhecimentos básicos de Linux
- Editor de código (VS Code recomendado)

---

# Objetivo do Laboratório

Criar um **Cluster Kubernetes usando Terraform**, aplicando boas práticas de organização, versionamento e validação da infraestrutura.

---

# Estrutura do Projeto

Crie a seguinte estrutura de diretórios:

```
terraform-k8s-cluster/
├── main.tf
├── variables.tf
├── outputs.tf
├── provider.tf
├── terraform.tfvars
└── README.md
```

---

# Deployment

## Etapa 1 – Configuração do Provider

- Criar o arquivo `provider.tf`
- Configurar o provider da AWS
- Definir a região padrão
- Configurar o backend local para o state

---

## Etapa 2 – Variáveis

- Criar o arquivo `variables.tf`
- Declarar variáveis para:
  - Região AWS
  - Nome do cluster
  - Versão do Kubernetes
  - Tipo de instância
  - Quantidade de nós
- Criar o arquivo `terraform.tfvars` e atribuir valores às variáveis

---

## Etapa 3 – Rede (Networking)

- Criar uma VPC
- Criar Subnets públicas e privadas
- Criar Internet Gateway
- Criar Route Tables e associações
- Criar Security Groups necessários para o cluster

---

## Etapa 4 – IAM

- Criar roles e policies necessárias para o Kubernetes
- Associar permissões para:
  - Control Plane
  - Worker Nodes
- Garantir o princípio do menor privilégio

---

## Etapa 5 – Cluster Kubernetes

- Criar o cluster Kubernetes utilizando Terraform
- Definir:
  - Nome do cluster
  - Versão do Kubernetes
  - Subnets do cluster
- Garantir que o cluster seja criado com sucesso

---

## Etapa 6 – Node Group

- Criar Node Group gerenciado
- Definir:
  - Tipo de instância
  - Quantidade mínima, máxima e desejada de nós
- Associar o Node Group ao cluster

---

## Etapa 7 – Outputs

- Criar o arquivo `outputs.tf`
- Expor:
  - Nome do cluster
  - Endpoint do cluster
  - Região
- Validar os outputs após o `terraform apply`

---

## Etapa 8 – Inicialização e Deploy

Execute os comandos abaixo:

```bash
terraform init
terraform validate
terraform plan
terraform apply
```

- Validar se não há erros
- Confirmar o plano antes de aplicar

---

## Etapa 9 – Acesso ao Cluster

- Atualizar o kubeconfig usando AWS CLI
- Validar conexão com o cluster:
  - Listar nodes
  - Listar namespaces

---

## Etapa 10 – Validação

- Verificar status do cluster
- Verificar status dos nodes
- Garantir que todos estejam em estado `Ready`

---

# Destruição da Infraestrutura

Após concluir os testes:

```bash
terraform destroy
```

- Confirmar a destruição dos recursos
- Verificar no console da AWS se todos os recursos foram removidos

---

# Boas Práticas

- Utilizar versionamento no Terraform
- Separar ambientes (dev, stage, prod) usando workspaces
- Não versionar arquivos sensíveis
- Utilizar `.gitignore`

---

# Finalização

Tudo certo? Ainda não se sente confiante?  
👉 Refaça o laboratório do zero sem consultar o material.

**Happy Learning & Happy Terraforming! 🚀**