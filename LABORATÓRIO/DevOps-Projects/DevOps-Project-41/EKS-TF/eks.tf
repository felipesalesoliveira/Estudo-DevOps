###############################################################################
# IAM + Cluster EKS
###############################################################################

# Policy document que permite ao serviço EKS assumir a role do cluster
data "aws_iam_policy_document" "assume_role" {
  statement {
    effect = "Allow"

    principals {
      type        = "Service"
      identifiers = ["eks.amazonaws.com"]
    }

    actions = ["sts:AssumeRole"]
  }
}

# Role IAM para o cluster EKS
resource "aws_iam_role" "eks_cluster_role" {
  name = "eks-cluster-cloud"

  assume_role_policy = data.aws_iam_policy_document.assume_role.json
}

# Política gerenciada que o cluster EKS precisa
resource "aws_iam_role_policy_attachment" "eks_cluster_policy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSClusterPolicy"
  role       = aws_iam_role.eks_cluster_role.name
}

# Recurso principal do cluster EKS
resource "aws_eks_cluster" "example" {
  name     = var.cluster_name
  role_arn = aws_iam_role.eks_cluster_role.arn

  vpc_config {
    subnet_ids = data.aws_subnets.public.ids
  }

  # Garante que as permissões IAM existam antes do cluster
  depends_on = [
    aws_iam_role_policy_attachment.eks_cluster_policy,
  ]
}

