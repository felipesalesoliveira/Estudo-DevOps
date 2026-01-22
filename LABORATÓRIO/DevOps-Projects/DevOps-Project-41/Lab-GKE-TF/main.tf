###############################################################################
# VPC
###############################################################################

resource "google_compute_network" "vpc" {
  # name
  # https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/compute_network#name
  name = "gke-vpc"

  # auto_create_subnetworks
  # https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/compute_network#auto_create_subnetworks
  auto_create_subnetworks = false
}

###############################################################################
# Subnet
###############################################################################

resource "google_compute_subnetwork" "subnet" {
  # name
  # https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/compute_subnetwork#name
  name = "gke-subnet"

  # region
  # https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/compute_subnetwork#region
  region = var.gcp_region

  # network
  # https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/compute_subnetwork#network
  network = google_compute_network.vpc.id

  # ip_cidr_range
  # https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/compute_subnetwork#ip_cidr_range
  ip_cidr_range = "10.0.0.0/24"
}

###############################################################################
# GKE Cluster — Control Plane
###############################################################################

resource "google_container_cluster" "cluster" {
  # name
  # https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/container_cluster#name
  name = var.cluster_name

  # location
  # https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/container_cluster#location
  location = var.gcp_region

  # remove_default_node_pool
  # https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/container_cluster#remove_default_node_pool
  remove_default_node_pool = true

  # initial_node_count
  # https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/container_cluster#initial_node_count
  initial_node_count = 1

  # network
  # https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/container_cluster#network
  network = google_compute_network.vpc.name

  # subnetwork
  # https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/container_cluster#subnetwork
  subnetwork = google_compute_subnetwork.subnet.name

  # ip_allocation_policy
  # https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/container_cluster#ip_allocation_policy
  ip_allocation_policy {
    # cluster_ipv4_cidr_block
    # https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/container_cluster#cluster_ipv4_cidr_block
    cluster_ipv4_cidr_block = "/14"

    # services_ipv4_cidr_block
    # https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/container_cluster#services_ipv4_cidr_block
    services_ipv4_cidr_block = "/20"
  }

  # logging_service
  # https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/container_cluster#logging_service
  logging_service = "logging.googleapis.com/kubernetes"

  # monitoring_service
  # https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/container_cluster#monitoring_service
  monitoring_service = "monitoring.googleapis.com/kubernetes"
}

###############################################################################
# Service Account — Nodes do GKE
###############################################################################

resource "google_service_account" "gke_nodes" {
  # account_id
  # https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/google_service_account#account_id
  account_id = "gke-node-sa"

  # display_name
  # https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/google_service_account#display_name
  display_name = "Service Account para nodes do GKE"
}

###############################################################################
# Node Pool — Capacidade de Computação
###############################################################################

resource "google_container_node_pool" "node_pool" {
  # name
  # https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/container_node_pool#name
  name = var.node_pool_name

  # location
  # https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/container_node_pool#location
  location = var.gcp_region

  # cluster
  # https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/container_node_pool#cluster
  cluster = google_container_cluster.cluster.name

  # node_count
  # https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/container_node_pool#node_count
  node_count = var.node_count

  node_config {
    # machine_type
    # https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/container_node_pool#machine_type
    machine_type = var.machine_type

    # service_account
    # https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/container_node_pool#service_account
    service_account = google_service_account.gke_nodes.email

    # oauth_scopes
    # https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/container_node_pool#oauth_scopes
    oauth_scopes = [
      "https://www.googleapis.com/auth/cloud-platform"
    ]
  }

  # autoscaling
  # https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/container_node_pool#autoscaling
  autoscaling {
    # min_node_count
    # https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/container_node_pool#min_node_count
    min_node_count = var.min_node_count

    # max_node_count
    # https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/container_node_pool#max_node_count
    max_node_count = var.max_node_count
  }

  # management
  # https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/container_node_pool#management
  management {
    auto_repair  = true
    auto_upgrade = true
  }
}
