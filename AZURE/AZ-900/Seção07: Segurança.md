# Defense in Depth no Azure – Resumo Rápido

## 📌 O que é?

**Defense in Depth** é um modelo de **segurança em camadas**, onde várias proteções são aplicadas em conjunto para reduzir riscos. Se uma camada falhar, as outras continuam protegendo.

> **Ideia-chave:** nunca confiar em uma única defesa.

---

## 🧱 Camadas do Defense in Depth (Azure)

### 1️⃣ Identidade e Acesso

**Quem pode acessar**

* Azure AD (Entra ID)
* MFA
* RBAC
* Conditional Access

---

### 2️⃣ Perímetro

**Proteção contra ataques externos**

* Azure DDoS Protection
* Azure Firewall
* Application Gateway (WAF)
* Azure Front Door

---

### 3️⃣ Rede

**Isolamento e controle de tráfego**

* VNET
* NSG
* Azure Firewall
* Private Endpoint
* VPN / ExpressRoute

---

### 4️⃣ Computação

**Proteção das cargas (VMs / Containers)**

* Atualizações e patches
* Microsoft Defender for Cloud
* Antimalware / Endpoint Protection

---

### 5️⃣ Aplicação

**Segurança no código**

* Autenticação e autorização
* Validação de entrada
* Secrets seguros
* Princípio do menor privilégio

---

### 6️⃣ Dados

**Proteção da informação**

* Criptografia em repouso
* Criptografia em trânsito
* Azure Key Vault
* Backup e controle de acesso

---

### 7️⃣ Monitoramento

**Detecção e resposta**

* Azure Monitor
* Log Analytics
* Microsoft Sentinel
* Alertas e auditoria

---

## 🎯 Frase para prova

> **Defense in Depth = segurança em múltiplas camadas.**

---

## ⚠️ Pegadinha comum

❌ Usar apenas firewall
✅ Combinar identidade, rede, aplicação, dados e monitoramento

---

## 🧠 Exemplo rápido

Usuário → MFA → WAF → VNET privada → VM protegida → Banco com Private Endpoint → Logs no Sentinel
