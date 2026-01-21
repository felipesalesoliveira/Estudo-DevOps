###############################################################################
# Arquivo Principal - GKE Cluster
###############################################################################

locals {
  project_name = "super-mario-gke"
  environment  = "lab"
}

###############################################################################
# Cluster GKE (Google Kubernetes Engine)
###############################################################################

resource "google_container_cluster" "mario_cluster" {
  name     = var.cluster_name
  location = var.gcp_region

  # Remover o node pool padrão (vamos criar um customizado)
  remove_default_node_pool = true
  initial_node_count       = 1

  # Configuração de rede
  network    = google_compute_network.vpc.name
  subnetwork = google_compute_subnetwork.subnet.name

  # Configuração de IP
  ip_allocation_policy {
    cluster_ipv4_cidr_block  = "/14"
    services_ipv4_cidr_block = "/20"
  }

  # Configurações de segurança
  master_auth {
    client_certificate_config {
      issue_client_certificate = false
    }
  }

  # Configuração de logging e monitoramento
  logging_service    = "logging.googleapis.com/kubernetes"
  monitoring_service = "monitoring.googleapis.com/kubernetes"

  # Versão do Kubernetes
  min_master_version = var.kubernetes_version

  depends_on = [
    google_compute_network.vpc,
    google_compute_subnetwork.subnet,
  ]
}

###############################################################################
# Node Pool customizado
###############################################################################

resource "google_container_node_pool" "mario_node_pool" {
  name       = var.node_pool_name
  location   = var.gcp_region
  cluster    = google_container_cluster.mario_cluster.name
  node_count = var.node_count

  node_config {
    preemptible  = true  # Máquinas preemptíveis são mais baratas (podem ser interrompidas)
    machine_type = var.machine_type

    # Service Account para os nodes
    service_account = google_service_account.gke_node_sa.email
    oauth_scopes = [
      "https://www.googleapis.com/auth/cloud-platform"
    ]

    # Labels e metadata
    labels = {
      environment = local.environment
      project     = local.project_name
    }
  }

  # Auto-scaling (opcional)
  autoscaling {
    min_node_count = 1
    max_node_count = 3
  }

  # Gerenciamento automático
  management {
    auto_repair  = true
    auto_upgrade = true
  }

  depends_on = [
    google_container_cluster.mario_cluster,
    google_service_account.gke_node_sa,
  ]
}

###############################################################################
# Service Account para os nodes do GKE
###############################################################################

resource "google_service_account" "gke_node_sa" {
  account_id   = "gke-node-sa"
  display_name = "Service Account para nodes do GKE"
}

# Permissões necessárias para os nodes
resource "google_project_iam_member" "gke_node_sa_logging" {
  project = var.gcp_project_id
  role    = "roles/logging.logWriter"
  member  = "serviceAccount:${google_service_account.gke_node_sa.email}"
}

resource "google_project_iam_member" "gke_node_sa_monitoring" {
  project = var.gcp_project_id
  role    = "roles/monitoring.metricWriter"
  member  = "serviceAccount:${google_service_account.gke_node_sa.email}"
}

resource "google_project_iam_member" "gke_node_sa_monitoring_viewer" {
  project = var.gcp_project_id
  role    = "roles/monitoring.viewer"
  member  = "serviceAccount:${google_service_account.gke_node_sa.email}"
}

###############################################################################
# VPC e Subnet
###############################################################################

resource "google_compute_network" "vpc" {
  name                    = "mario-vpc"
  auto_create_subnetworks = false
}

resource "google_compute_subnetwork" "subnet" {
  name          = "mario-subnet"
  ip_cidr_range = "10.0.0.0/24"
  region        = var.gcp_region
  network       = google_compute_network.vpc.id
}

###############################################################################
# Firewall Rules (Security Groups)
###############################################################################

resource "google_compute_firewall" "allow_ssh" {
  name    = "allow-ssh"
  network = google_compute_network.vpc.name

  allow {
    protocol = "tcp"
    ports    = ["22"]
  }

  source_ranges = ["0.0.0.0/0"]
  target_tags   = ["ssh"]
}

resource "google_compute_firewall" "allow_http" {
  name    = "allow-http"
  network = google_compute_network.vpc.name

  allow {
    protocol = "tcp"
    ports    = ["80"]
  }

  source_ranges = ["0.0.0.0/0"]
  target_tags   = ["http"]
}

resource "google_compute_firewall" "allow_https" {
  name    = "allow-https"
  network = google_compute_network.vpc.name

  allow {
    protocol = "tcp"
    ports    = ["443"]
  }

  source_ranges = ["0.0.0.0/0"]
  target_tags   = ["https"]
}

###############################################################################
# Outputs (valores que serão exibidos após o apply)
###############################################################################

output "cluster_name" {
  description = "Nome do cluster GKE"
  value       = google_container_cluster.mario_cluster.name
}

output "cluster_endpoint" {
  description = "Endpoint do cluster GKE"
  value       = google_container_cluster.mario_cluster.endpoint
}

output "cluster_location" {
  description = "Localização do cluster"
  value       = google_container_cluster.mario_cluster.location
}

output "cluster_ca_certificate" {
  description = "Certificado CA do cluster"
  value       = google_container_cluster.mario_cluster.master_auth[0].cluster_ca_certificate
  sensitive   = true
}
