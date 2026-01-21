###############################################################################
# Variáveis de configuração do ambiente GCP
###############################################################################

# ID do projeto GCP
variable "gcp_project_id" {
  description = "ID do projeto GCP onde os recursos serão criados"
  type        = string
}

# Região GCP onde o cluster será criado
variable "gcp_region" {
  description = "Região GCP onde o GKE e os demais recursos serão criados"
  type        = string
  default     = "us-central1"
}

# Zona GCP (dentro da região)
variable "gcp_zone" {
  description = "Zona GCP (dentro da região)"
  type        = string
  default     = "us-central1-a"
}

# Nome do cluster GKE
variable "cluster_name" {
  description = "Nome do cluster GKE"
  type        = string
  default     = "mario-gke-cluster"
}

# Nome do node pool
variable "node_pool_name" {
  description = "Nome do node pool do GKE"
  type        = string
  default     = "mario-node-pool"
}

# Tipo de máquina para os nodes
variable "machine_type" {
  description = "Tipo de máquina GCP para os nodes do GKE"
  type        = string
  default     = "e2-micro"  # Free tier: e2-micro é grátis (limitado)
}

# Número inicial de nodes
variable "node_count" {
  description = "Número inicial de nodes no node pool"
  type        = number
  default     = 1
}

# Versão do Kubernetes
variable "kubernetes_version" {
  description = "Versão do Kubernetes para o cluster"
  type        = string
  default     = "latest"
}
