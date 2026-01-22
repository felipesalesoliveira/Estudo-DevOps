###############################################################################
# Projeto e Região
###############################################################################

variable "gcp_project_id" {
  description = "ID do projeto no Google Cloud onde os recursos serão criados"
  type        = string
}

variable "gcp_region" {
  description = "Região do GCP onde o cluster e a rede serão criados"
  type        = string
}

###############################################################################
# GKE - Cluster
###############################################################################

variable "cluster_name" {
  description = "Nome do cluster GKE"
  type        = string
}

###############################################################################
# GKE - Node Pool
###############################################################################

variable "node_pool_name" {
  description = "Nome do node pool do GKE"
  type        = string
}

variable "node_count" {
  description = "Quantidade inicial de nodes no node pool"
  type        = number
}

variable "machine_type" {
  description = "Tipo de máquina usado pelos nodes do GKE"
  type        = string
}

###############################################################################
# Autoscaling do Node Pool
###############################################################################

variable "min_node_count" {
  description = "Quantidade mínima de nodes no autoscaling do node pool"
  type        = number
}

variable "max_node_count" {
  description = "Quantidade máxima de nodes no autoscaling do node pool"
  type        = number
}
