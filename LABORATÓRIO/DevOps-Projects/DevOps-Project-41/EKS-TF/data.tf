###############################################################################
# Data sources (dados de referência da AWS)
###############################################################################

# VPC padrão da conta
data "aws_vpc" "default" {
  default = true
}

# Subnets públicas da VPC padrão
data "aws_subnets" "public" {
  filter {
    name   = "vpc-id"
    values = [data.aws_vpc.default.id]
  }
}

