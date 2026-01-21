# Valores padrão para as variáveis do projeto
# Você pode ajustar estes valores sem mexer nos arquivos .tf

aws_region      = "us-east-1"
cluster_name    = "EKS_CLOUD"
node_group_name = "Node-cloud"
instance_type   = "t2.medium"  # mude para t2.micro/t3.micro se quiser tentar usar free tier
