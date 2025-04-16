variable "location" {
  default = "East US 2"
}

variable "resource_group_name" {
  default = "rg-aks-tf"
}

variable "acr_name" {
  default = "acr-aks-tf98872"  # must be globally unique and lowercase
}

variable "aks_name" {
  default = "AKSClustermj"
}
