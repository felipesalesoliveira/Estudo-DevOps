# 💰 Guia de Custos - Super Mario no EKS

## ⚠️ IMPORTANTE: Este projeto GERA CUSTOS na AWS

Este projeto **NÃO** está 100% dentro do Free Tier da AWS. Alguns recursos geram custos mesmo durante o uso.

---

## 📊 Tabela de Custos por Recurso

| Recurso | Tipo | Custo Aproximado | Free Tier? | Observações |
|---------|------|------------------|------------|-------------|
| **EKS Control Plane** | Serviço Gerenciado | **~$0.10/hora** | ❌ Não | Cobrado enquanto o cluster existir, mesmo sem uso |
| **EC2 Node Group** | Instância EC2 | **~$0.0464/hora** (t2.medium) | ❌ Não | t2.micro seria free tier, mas pode não ter recursos suficientes |
| **Load Balancer (ELB)** | Elastic Load Balancer | **~$0.0225/hora** + tráfego | ❌ Não | Cobrado enquanto existir |
| **S3 Backend** | Armazenamento | **~$0.023/GB/mês** | ✅ Sim | Primeiros 5GB são gratuitos |
| **EC2 Bastion** | Instância EC2 | **~$0.0116/hora** (t2.micro) | ✅ Sim | 750 horas/mês no free tier |

---

## 💵 Estimativa de Custos

### Por Hora de Uso:
```
EKS Control Plane:        $0.1000/hora
EC2 Node (t2.medium):     $0.0464/hora
Load Balancer:            $0.0225/hora
EC2 Bastion (t2.micro):   $0.0000/hora (free tier)
S3 (estado Terraform):    $0.0000 (desprezível)
─────────────────────────────────────────
TOTAL:                   ~$0.17/hora
```

### Por Dia (24 horas):
```
TOTAL: ~$4.08/dia
```

### Por Mês (se deixar rodando):
```
TOTAL: ~$122.40/mês
```

**⚠️ ATENÇÃO:** Esses valores são aproximados e podem variar por região e uso real.

---

## 🆓 O que está no Free Tier?

### ✅ Recursos que NÃO geram custo (dentro do free tier):

1. **EC2 t2.micro/t3.micro:**
   - 750 horas/mês
   - ✅ Usado para: EC2 Bastion (máquina de deploy)

2. **S3:**
   - 5 GB de armazenamento padrão
   - ✅ Usado para: Backend do Terraform (arquivo de estado ~1KB)

3. **Transferência de Dados:**
   - 1 GB de saída de dados/mês
   - ✅ Usado para: Acessar o jogo via Load Balancer

### ❌ Recursos que GERAM custo (fora do free tier):

1. **EKS Control Plane:**
   - **Custo:** ~$0.10/hora
   - **Por quê:** Serviço gerenciado premium
   - **Quando cobra:** Enquanto o cluster existir (mesmo sem pods rodando)

2. **EC2 Node Group (t2.medium):**
   - **Custo:** ~$0.0464/hora
   - **Por quê:** Instância maior que t2.micro
   - **Alternativa:** t2.micro seria free tier, mas pode não ter recursos suficientes para rodar pods

3. **Load Balancer (ELB):**
   - **Custo:** ~$0.0225/hora + tráfego
   - **Por quê:** Serviço gerenciado para distribuir tráfego
   - **Quando cobra:** Enquanto o service tipo LoadBalancer existir

---

## 💡 Como Minimizar Custos

### 1. ✅ Use Instâncias Menores (quando possível)

**No arquivo `EKS-TF/main.tf`, linha com `instance_types`:**

```hcl
# Opção mais barata (mas pode não funcionar bem):
instance_types = ["t2.micro"]  # Free tier, mas pode não ter recursos suficientes

# Opção intermediária:
instance_types = ["t3.small"]  # ~$0.0208/hora

# Opção do projeto original:
instance_types = ["t2.medium"]  # ~$0.0464/hora
```

**⚠️ Teste primeiro com t2.micro!** Se os pods não conseguirem rodar, aumente para t3.small.

### 2. ✅ Destrua Tudo Imediatamente Após Testar

**Comandos para destruir rapidamente:**

```bash
# 1. Deletar recursos Kubernetes
kubectl delete service mario-service
kubectl delete deployment mario-deployment

# 2. Destruir infraestrutura Terraform
cd EKS-TF
terraform destroy --auto-approve

# 3. Terminar EC2 Bastion no console AWS
```

**⏱️ Tempo de destruição:** 5-10 minutos

**💰 Economia:** Evita custos contínuos!

### 3. ✅ Use a Mesma Região para Tudo

**Regiões mais baratas (exemplos):**
- `us-east-1` (N. Virginia) - **Mais barata**
- `us-west-2` (Oregon)
- `eu-west-1` (Ireland)

**Regiões mais caras:**
- `sa-east-1` (São Paulo) - Pode ser até 20% mais cara
- `ap-southeast-1` (Singapore)

**Configure no `provider.tf` e `backend.tf`:**

```hcl
region = "us-east-1"  # Região mais barata
```

### 4. ✅ Configure AWS Budgets para Alertas

**No console AWS:**

1. Vá para **Billing & Cost Management** → **Budgets**
2. Clique em **Create budget**
3. Escolha **Cost budget**
4. Configure:
   - **Nome:** `EKS-Mario-Alert`
   - **Valor:** `$5` (ou o que preferir)
   - **Período:** Mensal
5. Configure alertas:
   - **80% do orçamento:** Email
   - **100% do orçamento:** Email

**✅ Agora você receberá alertas antes de gastar muito!**

### 5. ✅ Use NodePort em vez de LoadBalancer (Opcional)

**Para economizar no Load Balancer:**

**Modifique `service.yaml`:**

```yaml
apiVersion: v1
kind: Service
metadata:
  name: mario-service
spec:
  type: NodePort  # Em vez de LoadBalancer
  selector:
    app: mario
  ports:
  - protocol: TCP
    port: 80
    targetPort: 80
```

**Depois acesse via:**
- Port forwarding: `kubectl port-forward service/mario-service 8080:80`
- Ou via IP do node diretamente (menos prático)

**💰 Economia:** ~$0.0225/hora (sem Load Balancer)

---

## 📈 Monitoramento de Custos

### 1. AWS Cost Explorer

**Como acessar:**
1. Console AWS → **Billing & Cost Management**
2. Clique em **Cost Explorer**
3. Veja gráficos de custo por serviço, região, etc.

### 2. AWS Cost and Usage Reports

**Para análise detalhada:**
1. Console AWS → **Billing & Cost Management** → **Cost and Usage Reports**
2. Crie um relatório detalhado

### 3. Verificar Custos em Tempo Real

**Via AWS CLI:**

```bash
# Ver custos do mês atual (requer permissões)
aws ce get-cost-and-usage \
  --time-period Start=2024-01-01,End=2024-01-31 \
  --granularity MONTHLY \
  --metrics BlendedCost
```

---

## 🚨 Alertas de Custo Recomendados

### Configurar Alertas Básicos:

1. **Alerta de $5 gastos:**
   - Nome: `EKS-Mario-5-Dollars`
   - Valor: $5
   - Ação: Email

2. **Alerta de $10 gastos:**
   - Nome: `EKS-Mario-10-Dollars`
   - Valor: $10
   - Ação: Email + SNS

3. **Alerta de uso de EKS:**
   - Nome: `EKS-Cluster-Running`
   - Condição: Cluster EKS existe há mais de 1 hora
   - Ação: CloudWatch Alarm

---

## 💰 Estimativa Realista para Este Projeto

### Cenário 1: Teste Rápido (1 hora)
```
Criar infraestrutura:     10 min
Testar o jogo:            30 min
Destruir tudo:            10 min
───────────────────────────────
Tempo total:              ~50 min
Custo estimado:           ~$0.14
```

### Cenário 2: Aprendizado Completo (4 horas)
```
Criar infraestrutura:     10 min
Testar e aprender:        3 horas
Destruir tudo:            10 min
───────────────────────────────
Tempo total:              ~4 horas
Custo estimado:           ~$0.68
```

### Cenário 3: Deixar Rodando (NÃO RECOMENDADO)
```
1 dia:   ~$4.08
1 semana: ~$28.56
1 mês:   ~$122.40
```

**⚠️ NUNCA deixe rodando sem necessidade!**

---

## 🎯 Resumo: Como Ficar Dentro do Orçamento

### ✅ Checklist Antes de Começar:

- [ ] Configurei AWS Budgets com alerta de $5
- [ ] Escolhi região mais barata (us-east-1)
- [ ] Tenho tempo para destruir tudo após testar
- [ ] Entendi que EKS gera custo mesmo sem uso

### ✅ Checklist Durante o Uso:

- [ ] Monitorei custos no Cost Explorer
- [ ] Verifiquei se recebi alertas de orçamento
- [ ] Anotei horário de início para calcular custo

### ✅ Checklist Após Testar:

- [ ] Deletei service e deployment Kubernetes
- [ ] Executei `terraform destroy`
- [ ] Verifiquei que cluster EKS foi deletado
- [ ] Verifiquei que Load Balancer foi deletado
- [ ] Terminei EC2 Bastion
- [ ] Confirmei custo final no Cost Explorer

---

## 📞 Suporte AWS

**Se tiver dúvidas sobre custos:**

- **AWS Support:** Console AWS → Support → Support Center
- **AWS Cost Management:** https://aws.amazon.com/aws-cost-management/
- **Calculadora de Custos:** https://calculator.aws/

---

## ⚖️ Disclaimer

- Os valores de custo são **aproximados** e podem variar
- Custos reais dependem de:
  - Região escolhida
  - Uso real de recursos
  - Tráfego de rede
  - Taxas de transferência de dados
- **Sempre verifique custos reais no console AWS**
- **Este projeto é para aprendizado, não para produção**

---

**💰 Lembre-se: O melhor custo é $0 - sempre destrua tudo após testar!**
