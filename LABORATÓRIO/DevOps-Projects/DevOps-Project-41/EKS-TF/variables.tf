###############################################################################
# Variáveis de configuração do ambiente
###############################################################################

# Região AWS onde tudo será criado
variable "aws_region" {
  description = "Região AWS onde o EKS e os demais recursos serão criados"
  type        = string
  default     = "us-east-1"
}

# Nome do cluster EKS
variable "cluster_name" {
  description = "Nome do cluster EKS"
  type        = string
  default     = "EKS_CLOUD"
}

# Nome do Node Group
variable "node_group_name" {
  description = "Nome do node group do EKS"
  type        = string
  default     = "Node-cloud"
}

# Tipo de instância usada pelos nodes do EKS
variable "instance_type" {
  description = "Tipo de instância EC2 para o node group do EKS"
  type        = string
  default     = "t2.medium"
}

