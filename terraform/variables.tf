variable "location" {
  default = "East US 2"
}

variable "resource_group_name" {
  default = "rg-aks-tf"
}

variable "acr_name" {
  default = "acraks98872"  # must be globally unique and lowercase
}

variable "aks_name" {
  default = "aksclustermj"
}
