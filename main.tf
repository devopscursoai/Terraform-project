terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "5.9.0"
    }
  }
}

provider "azurerm" {
  features {}
  subscription_id = "c14c9ee6-90d8-42ff-93bc-a92def63864b"
}

# create a resource group
resource "azurerm_resource_group" "rg" {
  name     = "rg-terraform"
  location = "eastus"
}

# create a storage account
resource "azurerm_storage_account" "storage" {
  name                     = "tfstore20261013a7"
  location                 = azurerm_resource_group.rg.location
  resource_group_name      = azurerm_resource_group.rg.name
  account_tier             = "Standard"
  account_replication_type = "LRS"
}

# create network security group
resource "azurerm_network_security_group" "nsg" {
  name        = "my-nsg"
  location    =  azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
}

resource "azurerm_virtual_network" "vnet" {
  name                = "my-vnet"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  address_space       = ["10.0.0.0/16"]
}

resource "azurerm_subnet" "subnet1" {
  name                 = "subnet1"
  resource_group_name  = azurerm_resource_group.rg.name
  virtual_network_name = azurerm_virtual_network.vnet.name
  address_prefixes     = ["10.0.1.0/24"]
}
