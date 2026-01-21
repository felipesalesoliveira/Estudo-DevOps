# ☁️ Escolhendo entre AWS EKS e Google GKE

Este projeto suporta **dois provedores de nuvem**: AWS (EKS) e Google Cloud (GKE).

---

## 🆚 Comparação Rápida

| Aspecto | AWS EKS | Google GKE |
|---------|---------|------------|
| **Control Plane** | ~$0.10/hora | **Grátis** ✅ |
| **Free Tier** | Limitado (750h EC2 t2.micro) | $300 créditos/90 dias |
| **Custo por hora** | ~$0.17/hora | ~$0.035/hora |
| **Complexidade** | Média | Média |
| **Documentação** | Completa | Completa |
| **Execução** | Local ou EC2 | **Local** ✅ |

---

## 🎯 Qual escolher?

### Escolha **AWS EKS** se:
- ✅ Já tem conta AWS
- ✅ Quer aprender AWS especificamente
- ✅ Precisa de recursos AWS (S3, RDS, etc.)
- ✅ Não se importa com custo do control plane

### Escolha **Google GKE** se:
- ✅ Quer **economizar** (control plane grátis)
- ✅ Tem conta GCP com créditos
- ✅ Quer executar tudo **localmente** (sem EC2)
- ✅ Prefere Google Cloud

---

## 📁 Estrutura do Projeto

```
Mario/
├── EKS-TF/          # 📦 Terraform para AWS EKS
│   ├── provider.tf
│   ├── variables.tf
│   ├── terraform.tfvars
│   ├── backend.tf
│   ├── data.tf
│   ├── eks.tf
│   ├── ec2.tf
│   └── main.tf
│
├── GKE-TF/          # 📦 Terraform para Google GKE ⭐ NOVO
│   ├── provider.tf
│   ├── variables.tf
│   ├── terraform.tfvars
│   ├── backend.tf
│   ├── main.tf
│   └── README.md
│
├── deployment.yaml  # 🎮 Deployment do Super Mario (funciona em ambos)
├── service.yaml     # 🌐 Service LoadBalancer (funciona em ambos)
└── ...
```

---

## 🚀 Como Usar

### Opção 1: AWS EKS

```bash
# 1. Configurar backend.tf e terraform.tfvars
cd EKS-TF
nano backend.tf      # Colocar nome do bucket S3
nano terraform.tfvars

# 2. Executar Terraform
terraform init
terraform apply

# 3. Configurar kubectl
aws eks update-kubeconfig --name EKS_CLOUD --region us-east-1

# 4. Deploy
cd ..
kubectl apply -f deployment.yaml
kubectl apply -f service.yaml
```

**📖 Documentação completa:** Veja `README.md` (focado em AWS)

---

### Opção 2: Google GKE ⭐ RECOMENDADO

```bash
# 1. Configurar GCP
gcloud auth login
gcloud config set project SEU-PROJECT-ID
gcloud services enable container.googleapis.com

# 2. Configurar terraform.tfvars
cd GKE-TF
nano terraform.tfvars  # Colocar PROJECT-ID

# 3. Executar Terraform
terraform init
terraform apply

# 4. Configurar kubectl
gcloud container clusters get-credentials $(terraform output -raw cluster_name) \
  --region $(terraform output -raw cluster_location)

# 5. Deploy
cd ..
kubectl apply -f deployment.yaml
kubectl apply -f service.yaml
```

**📖 Documentação completa:** Veja `GKE-TF/README.md`

---

## 💰 Comparação de Custos

### AWS EKS (1 hora de uso):
- Control Plane: $0.10
- Node (t2.medium): $0.0464
- Load Balancer: $0.0225
- **Total: ~$0.17/hora**

### Google GKE (1 hora de uso):
- Control Plane: **Grátis** ✅
- Node (e2-micro preemptible): $0.01
- Load Balancer: $0.025
- **Total: ~$0.035/hora**

**💰 Economia com GKE: ~80% mais barato!**

---

## ✅ Recomendação

**Para este laboratório, recomendo Google GKE porque:**
1. ✅ Control plane **grátis**
2. ✅ Execução **local** (não precisa EC2)
3. ✅ **Mais barato** (~80% economia)
4. ✅ $300 créditos free trial (90 dias)

**Para produção, escolha baseado em:**
- Requisitos específicos da aplicação
- Outros serviços necessários
- Experiência da equipe
- Custos de longo prazo

---

## 🔄 Migrando entre Providers

Os arquivos `deployment.yaml` e `service.yaml` funcionam em **ambos** os providers!

**Diferenças apenas no Terraform:**
- AWS: `EKS-TF/`
- GCP: `GKE-TF/`

**Kubernetes é o mesmo!** 🎉

---

## 📚 Próximos Passos

1. **Escolha seu provider** (AWS ou GCP)
2. **Siga a documentação específica:**
   - AWS: `README.md` ou `LABORATORIO.md`
   - GCP: `GKE-TF/README.md`
3. **Use `COMANDOS-RAPIDOS.md`** como referência

---

**Boa sorte! 🚀**
