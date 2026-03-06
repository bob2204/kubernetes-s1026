terraform {
  required_providers {
    keycloak = {
      source  = "keycloak/keycloak"
      version = ">= 5.6.0"
    }
  }

  required_version = ">= 1.0.0"
}

provider "keycloak" {
  client_id = "admin-cli"
  username  = var.admin_user
  password  = var.admin_pass
  url       = var.keycloak_url
  realm     = "master"
}
