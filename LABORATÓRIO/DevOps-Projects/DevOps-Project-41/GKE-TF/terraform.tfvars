# Valores padrão para as variáveis do projeto GCP
# Você pode ajustar estes valores sem mexer nos arquivos .tf

gcp_project_id   = "SEU-PROJECT-ID-AQUI"  # ⚠️ SUBSTITUA pelo ID do seu projeto GCP
gcp_region       = "us-central1"           # Região GCP
gcp_zone         = "us-central1-a"        # Zona GCP
cluster_name     = "mario-gke-cluster"    # Nome do cluster
node_pool_name   = "mario-node-pool"      # Nome do node pool
machine_type     = "e2-micro"             # Tipo de máquina (e2-micro é free tier)
node_count       = 1                      # Quantidade de nodes
kubernetes_version = "latest"             # Versão do Kubernetes
