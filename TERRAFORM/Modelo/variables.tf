###############################################################################
# Variáveis AWS S3 Bucket
###############################################################################





###############################################################################
# Variáveis Azure storage account
###############################################################################

variable "location" {
  description = "Região onde os recursos serão criados na Azure."
  type        = string
  default     = "East US"
}

variable "account_tier" {
  description = "Tier da Storage Account na Azure."
  type        = string
  default     = "Standard"
}

variable "account_replication_type" {
  description = "Tipo de replicação de dados da Storage Account na Azure."
  type        = string
  default     = "LRS"
}

variable "storage_account_id" {
  description = "ID da Storage Account na Azure."
  type        = string
  default     = ""
}

variable "resource_group_name" {
  description = "Nome do Resource Group na Azure."
  type        = string
  default     = "rg-teeraform"
}

variable "storage_account_name" {
  description = "Nome da Storage Account na Azure."
  type        = string
  default     = "felipesalesterraform"

}
variable "storage_container_name" {
  description = "Nome do Container na Storage Account da Azure."
  type        = string
  default     = "container-terraform"
}
