# 📁 Estrutura do Projeto - Super Mario no EKS

Documentação da estrutura de arquivos do projeto.

---

## 📂 Estrutura de Diretórios

```
Mario/
├── README.md                    # 📖 Guia completo passo a passo
├── LABORATORIO.md               # 🎓 Guia didático do zero (para iniciantes)
├── INICIO-RAPIDO.md             # ⚡ Resumo rápido
├── COMANDOS-RAPIDOS.md          # 📋 Referência de comandos
├── GUIA-CUSTOS.md               # 💰 Informações sobre custos
├── ESTRUTURA-PROJETO.md         # 📁 Este arquivo
├── deployment.yaml               # 🎮 Deployment do Super Mario
├── service.yaml                  # 🌐 Service (Load Balancer)
└── EKS-TF/                      # 📦 Código Terraform
    ├── backend.tf               # 🪣 Backend S3
    ├── provider.tf              # ⚙️ Provider AWS
    ├── variables.tf             # 📝 Definição de variáveis
    ├── terraform.tfvars         # ✏️ Valores das variáveis (EDITAR AQUI)
    ├── data.tf                  # 🔍 Data sources (VPC, subnets)
    ├── eks.tf                   # ☸️ Recursos EKS (cluster, IAM)
    ├── ec2.tf                   # 💻 Recursos Node Group (nodes, IAM)
    └── main.tf                  # 📄 Arquivo principal
```

---

## 📄 Descrição dos Arquivos

### Documentação

#### `README.md`
- **O que é:** Guia completo passo a passo do projeto
- **Para quem:** Quem já tem conhecimento básico de Terraform/AWS/Kubernetes
- **Conteúdo:** Instruções detalhadas, explicações técnicas, troubleshooting

#### `LABORATORIO.md`
- **O que é:** Guia didático completo do zero
- **Para quem:** Iniciantes completos (assume conhecimento zero)
- **Conteúdo:** 
  - Como instalar Terraform do zero
  - Como criar conta AWS
  - Conceitos básicos explicados
  - Passo a passo com explicações de cada comando

#### `INICIO-RAPIDO.md`
- **O que é:** Resumo executivo rápido
- **Para quem:** Quem quer uma visão geral rápida
- **Conteúdo:** Checklist, passos essenciais, links para documentação completa

#### `COMANDOS-RAPIDOS.md`
- **O que é:** Referência rápida de comandos
- **Para quem:** Quem já sabe o que fazer e só precisa dos comandos
- **Conteúdo:** Todos os comandos prontos para copy-paste

#### `GUIA-CUSTOS.md`
- **O que é:** Informações detalhadas sobre custos
- **Para quem:** Quem quer entender e minimizar custos
- **Conteúdo:** Tabela de custos, estimativas, como minimizar, alertas

---

### Arquivos Kubernetes

#### `deployment.yaml`
- **O que é:** Manifesto Kubernetes que define o Deployment do Super Mario
- **O que faz:** 
  - Define quantos pods queremos rodar (`replicas: 2`)
  - Define qual imagem Docker usar (`sevenajay/mario:latest`)
  - Define porta do container (`containerPort: 80`)
- **Quando usar:** `kubectl apply -f deployment.yaml`

#### `service.yaml`
- **O que é:** Manifesto Kubernetes que define o Service (Load Balancer)
- **O que faz:**
  - Expõe os pods do deployment na internet
  - Cria um Load Balancer na AWS
  - Conecta tráfego externo aos pods
- **Quando usar:** `kubectl apply -f service.yaml`

---

### Arquivos Terraform (`EKS-TF/`)

#### `provider.tf`
- **O que é:** Configuração do provider AWS
- **O que faz:**
  - Define qual provider usar (`hashicorp/aws`)
  - Define versão mínima (`~> 5.0`)
  - Configura região padrão (`us-east-1`)
- **Quando editar:** Se quiser mudar região padrão (mas melhor usar `terraform.tfvars`)

#### `backend.tf`
- **O que é:** Configuração do backend S3
- **O que faz:**
  - Define onde Terraform guarda o estado (`terraform.tfstate`)
  - Usa S3 como backend remoto
- **⚠️ PRECISA EDITAR:** Substitua `SEU-BUCKET-AQUI` pelo nome do seu bucket S3
- **⚠️ IMPORTANTE:** Backend não aceita variáveis, precisa editar manualmente

#### `variables.tf`
- **O que é:** Definição de variáveis (declaração)
- **O que faz:**
  - Define quais variáveis existem
  - Define tipos e valores padrão
  - Documenta cada variável
- **Variáveis definidas:**
  - `aws_region`: Região AWS
  - `cluster_name`: Nome do cluster EKS
  - `node_group_name`: Nome do node group
  - `instance_type`: Tipo de instância EC2
- **Quando editar:** Raramente (só se quiser adicionar novas variáveis)

#### `terraform.tfvars`
- **O que é:** Valores das variáveis (atribuição)
- **O que faz:**
  - Define os valores reais das variáveis
  - Usado pelo Terraform ao executar `plan` e `apply`
- **⚠️ EDITAR AQUI:** Para personalizar sem mexer nos arquivos `.tf`
- **Exemplo:**
  ```hcl
  aws_region      = "us-east-1"
  cluster_name    = "EKS_CLOUD"
  node_group_name = "Node-cloud"
  instance_type   = "t2.medium"
  ```

#### `data.tf`
- **O que é:** Data sources (busca informações da AWS)
- **O que faz:**
  - Busca VPC padrão da AWS
  - Busca subnets públicas da VPC
  - Usa essas informações nos recursos
- **Quando editar:** Se quiser usar VPC/subnets específicas (avançado)

#### `eks.tf`
- **O que é:** Recursos do EKS (cluster e IAM do cluster)
- **O que faz:**
  - Cria IAM role para o cluster EKS
  - Anexa políticas necessárias
  - Cria o cluster EKS
- **Recursos criados:**
  - `aws_iam_role.eks_cluster_role`
  - `aws_iam_role_policy_attachment.eks_cluster_policy`
  - `aws_eks_cluster.example`
- **Quando editar:** Se quiser mudar configurações do cluster (avançado)

#### `ec2.tf`
- **O que é:** Recursos do Node Group (nodes e IAM dos nodes)
- **O que faz:**
  - Cria IAM role para os nodes
  - Anexa políticas necessárias
  - Cria o node group (instâncias EC2 que rodam os pods)
- **Recursos criados:**
  - `aws_iam_role.eks_node_role`
  - `aws_iam_role_policy_attachment.*` (3 attachments)
  - `aws_eks_node_group.example`
- **Quando editar:** Se quiser mudar tipo de instância (melhor usar `terraform.tfvars`)

#### `main.tf`
- **O que é:** Arquivo principal do módulo
- **O que faz:**
  - Define locals (valores locais)
  - Comentários explicativos sobre a estrutura
  - Organização do código
- **Quando editar:** Raramente (só para adicionar locals ou comentários)

---

## 🔄 Fluxo de Trabalho

### 1. Configuração Inicial

1. **Editar `backend.tf`:**
   - Substituir `SEU-BUCKET-AQUI` pelo nome do bucket S3
   - Ajustar região se necessário

2. **Editar `terraform.tfvars` (opcional):**
   - Personalizar região, nome do cluster, tipo de instância

### 2. Execução Terraform

```bash
cd EKS-TF
terraform init      # Inicializa e configura backend
terraform validate  # Valida sintaxe
terraform plan      # Mostra o que será criado
terraform apply     # Cria a infraestrutura
```

### 3. Deploy Kubernetes

```bash
cd ..
aws eks update-kubeconfig --name EKS_CLOUD --region us-east-1
kubectl apply -f deployment.yaml
kubectl apply -f service.yaml
```

### 4. Limpeza

```bash
kubectl delete service mario-service
kubectl delete deployment mario-deployment
cd EKS-TF
terraform destroy
```

---

## 💡 Dicas de Organização

### Para Personalizar Configurações

**✅ FAÇA:** Edite `terraform.tfvars`
```hcl
instance_type = "t3.small"  # Mudar tipo de instância
```

**❌ NÃO FAÇA:** Edite `ec2.tf` diretamente
```hcl
instance_types = ["t3.small"]  # Evite fazer isso
```

**Por quê:** `terraform.tfvars` é mais fácil de manter e não mexe no código principal.

### Para Mudar Região

**✅ FAÇA:** Edite `terraform.tfvars`
```hcl
aws_region = "sa-east-1"
```

**⚠️ LEMBRE-SE:** Também precisa editar `backend.tf` (região do bucket S3)

### Para Adicionar Novas Variáveis

1. **Adicione em `variables.tf`:**
   ```hcl
   variable "nova_variavel" {
     description = "Descrição"
     type        = string
     default     = "valor-padrao"
   }
   ```

2. **Use nos arquivos `.tf`:**
   ```hcl
   resource "..." "..." {
     name = var.nova_variavel
   }
   ```

3. **Defina valor em `terraform.tfvars`:**
   ```hcl
   nova_variavel = "meu-valor"
   ```

---

## 🎯 Resumo: O que Editar?

| Arquivo | Quando Editar | O que Mudar |
|---------|---------------|--------------|
| `backend.tf` | **Sempre** (primeira vez) | Nome do bucket S3, região |
| `terraform.tfvars` | **Sempre** (personalizar) | Região, nome do cluster, tipo de instância |
| `variables.tf` | Raramente | Adicionar novas variáveis |
| `eks.tf` | Avançado | Configurações do cluster |
| `ec2.tf` | Avançado | Configurações do node group |
| `data.tf` | Avançado | VPC/subnets específicas |
| `provider.tf` | Raramente | Versão do provider |
| `main.tf` | Raramente | Locals, comentários |

---

## 📚 Próximos Passos

Agora que você entende a estrutura:

1. **Leia `LABORATORIO.md`** se é iniciante
2. **Leia `README.md`** para guia completo
3. **Use `COMANDOS-RAPIDOS.md`** durante execução
4. **Consulte `GUIA-CUSTOS.md`** para entender custos

---

**Boa sorte! 🚀**
