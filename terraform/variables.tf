variable "location" {
  default = "East US"
}

variable "resource_group_name" {
  default = "myResourceGroup"
}

variable "acr_name" {
  default = "myacrregistry123"  # must be globally unique and lowercase
}

variable "aks_name" {
  default = "myAKSCluster"
}
