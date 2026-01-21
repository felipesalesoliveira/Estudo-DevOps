###############################################################################
# Arquivo principal (entrypoint) do Terraform neste diretório
# -----------------------------------------------------------------------------
# O Terraform não precisa que exista um \"arquivo principal\" específico
# (qualquer .tf é lido), mas deixamos este main.tf com um pequeno bloco
# para deixar claro que este é o root module.
#
# Toda a configuração real está separada em:
#   - variables.tf -> definição de variáveis
#   - provider.tf  -> provider AWS
#   - backend.tf   -> backend S3 (estado remoto)
#   - data.tf      -> data sources (VPC, subnets, etc.)
#   - eks.tf       -> IAM do cluster + recurso aws_eks_cluster
#   - ec2.tf       -> IAM dos nodes + recurso aws_eks_node_group
###############################################################################

locals {
  project = "super-mario-eks"
}

