###############################################################################
# IAM + Node Group (EC2) do EKS
###############################################################################

# Role IAM para os nodes do EKS (instâncias EC2 do node group)
resource "aws_iam_role" "eks_node_role" {
  name = "eks-node-group-cloud"

  assume_role_policy = jsonencode({
    Statement = [{
      Action = "sts:AssumeRole"
      Effect = "Allow"
      Principal = {
        Service = "ec2.amazonaws.com"
      }
    }]
    Version = "2012-10-17"
  })
}

# Políticas necessárias para os nodes do EKS funcionarem
resource "aws_iam_role_policy_attachment" "eks_worker_node_policy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSWorkerNodePolicy"
  role       = aws_iam_role.eks_node_role.name
}

resource "aws_iam_role_policy_attachment" "eks_cni_policy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKS_CNI_Policy"
  role       = aws_iam_role.eks_node_role.name
}

resource "aws_iam_role_policy_attachment" "eks_container_registry_readonly" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryReadOnly"
  role       = aws_iam_role.eks_node_role.name
}

# Node Group (grupo de instâncias EC2 que rodam os pods do cluster)
resource "aws_eks_node_group" "example" {
  cluster_name    = aws_eks_cluster.example.name
  node_group_name = var.node_group_name
  node_role_arn   = aws_iam_role.eks_node_role.arn
  subnet_ids      = data.aws_subnets.public.ids

  scaling_config {
    desired_size = 1  # Quantidade de instâncias desejadas
    max_size     = 2  # Máximo de instâncias (para auto-scaling)
    min_size     = 1  # Mínimo de instâncias
  }

  # Tipo de instância
  # ⚠️ ATENÇÃO: t2.medium NÃO está no free tier
  # Para free tier, use t2.micro ou t3.micro (mas pode não ter recursos suficientes)
  instance_types = [var.instance_type]

  # Garante que as permissões IAM existam antes do node group
  depends_on = [
    aws_iam_role_policy_attachment.eks_worker_node_policy,
    aws_iam_role_policy_attachment.eks_cni_policy,
    aws_iam_role_policy_attachment.eks_container_registry_readonly,
  ]
}

