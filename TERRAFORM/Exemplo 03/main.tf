###############################################################################
# Terraform & Provider
###############################################################################

terraform {
  required_version = ">= 1.5.0"

  required_providers {

    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 3.0"
    }
  }

  backend "azurerm" {
    resource_group_name  = "rg-terraform-state"
    storage_account_name = "felipesalesstorage"
    container_name       = "remote-state"
    key                  = "azure-vnet/terraform.tfstate"
  }

}

provider "azurerm" {
  features {}
}
resource "azurerm_resource_group" "resource_group" {
  name     = "curso-terraform"
  location = var.location

  tags = local.common_tags

}
