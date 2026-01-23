###############################################################################
# Terraform
###############################################################################

terraform {
  required_version = ">= 1.5.0"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }

    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 3.0"
    }

    google = {
      source  = "hashicorp/google"
      version = "~> 5.0"
    }
  }
}

###############################################################################
# Provider
###############################################################################

provider "aws" {
  region = "us-east-1"

  default_tags {
    tags = {
      owner       = "felipesales"
      mangaged-by = "terraform"
    }
  }
}

provider "azurerm" {
  features {}
}
resource "azurerm_resource_group" "resource_group" {
  name     = "nome_resouce_group"
  location = ""

  tags = {
    environment = "value"
  }
}

provider "google" {
  project = "value"
  region  = "value"
}
