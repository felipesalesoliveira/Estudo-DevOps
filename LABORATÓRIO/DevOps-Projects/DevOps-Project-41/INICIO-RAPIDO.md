# 🚀 Início Rápido - Super Mario no Kubernetes

Guia rápido para começar o projeto em 5 minutos.

---

## ☁️ Escolha seu Provider

**Este projeto suporta AWS EKS e Google GKE!**

- **AWS EKS:** Veja passos abaixo
- **Google GKE:** Veja `GKE-TF/README.md` ⭐ **RECOMENDADO** (mais barato, execução local)

**📖 Não sabe qual escolher?** Veja `ESCOLHA-PROVIDER.md`

---

## ✅ Checklist Pré-requisitos

### Para AWS EKS:
- [ ] Conta AWS ativa
- [ ] Terraform instalado localmente
- [ ] AWS CLI instalado e configurado
- [ ] kubectl instalado
- [ ] Entendimento de que **vai gerar custos** (~$0.17/hora)
- [ ] Tempo disponível (~2 horas para setup completo)

### Para Google GKE (recomendado):
- [ ] Conta Google Cloud com free trial ($300 créditos)
- [ ] Google Cloud SDK instalado (`gcloud`)
- [ ] Terraform instalado
- [ ] kubectl instalado
- [ ] Tempo disponível (~1 hora para setup completo)

---

## 📋 Passos Essenciais (Resumo)

### 1️⃣ Criar EC2 Bastion (5 min)
- Console AWS → EC2 → Launch Instance
- Ubuntu 22.04, t2.micro, Key Pair
- Security Group: SSH, HTTP, HTTPS
- Conectar via SSH

### 2️⃣ Instalar Ferramentas (10 min)
```bash
sudo su
apt update -y
apt install docker.io -y
# ... (veja COMANDOS-RAPIDOS.md para comandos completos)
```

### 3️⃣ Criar IAM Role (5 min)
- IAM → Roles → Create role
- EC2 → AdministratorAccess
- Anexar à EC2

### 4️⃣ Criar Bucket S3 (2 min)
- S3 → Create bucket
- Nome único, mesma região
- Editar `backend.tf` com nome do bucket

### 5️⃣ Terraform Apply (15 min)
```bash
cd EKS-TF
terraform init
terraform apply --auto-approve
```

### 6️⃣ Deploy Kubernetes (5 min)
```bash
aws eks update-kubeconfig --name EKS_CLOUD --region us-east-1
kubectl apply -f ../deployment.yaml
kubectl apply -f ../service.yaml
```

### 7️⃣ Acessar Jogo (2 min)
```bash
kubectl get service mario-service
# Copiar EXTERNAL-IP e colar no navegador
```

### 8️⃣ Limpeza (10 min)
```bash
kubectl delete service mario-service
kubectl delete deployment mario-deployment
cd EKS-TF && terraform destroy --auto-approve
```

---

## 📚 Documentação Completa

- **LABORATORIO.md** - 🎓 Guia didático do zero (para iniciantes completos)
- **README.md** - Guia completo passo a passo detalhado
- **ESTRUTURA-PROJETO.md** - Explicação da estrutura de arquivos
- **COMANDOS-RAPIDOS.md** - Referência de comandos
- **GUIA-CUSTOS.md** - Informações sobre custos
- **INICIO-RAPIDO.md** - Este arquivo (resumo)

---

## ⚠️ Avisos Importantes

1. **Custos:** Este projeto gera ~$0.17/hora enquanto rodando
2. **EKS:** Cobra mesmo sem uso (enquanto cluster existir)
3. **Destruição:** SEMPRE destrua tudo após testar
4. **Free Tier:** Não está 100% dentro do free tier

---

## 🆘 Precisa de Ajuda?

1. Leia o **README.md** completo
2. Consulte **COMANDOS-RAPIDOS.md** para comandos
3. Veja seção **Troubleshooting** no README.md
4. Verifique **GUIA-CUSTOS.md** para entender custos

---

## 🎯 Objetivo do Projeto

Aprender:
- ✅ Terraform (Infrastructure as Code)
- ✅ EKS (Kubernetes na AWS)
- ✅ Kubernetes (Deployments, Services)
- ✅ AWS (EC2, IAM, S3, Load Balancers)

---

**Boa sorte! 🚀**
