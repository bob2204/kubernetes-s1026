variable "admin_user" {
  type        = string
  description = "admin"
  default     = "admin"
}

variable "admin_pass" {
  type        = string
  description = "admin"
}

variable "keycloak_url" {
  type        = string
  description = "URL du serveur Keycloak"
  default     = "https://auth.stage.local:8443"
}

variable "kubernetes_client_secret" {
  type        = string
  description = "Secret du client kubernetes"
}

variable "bob_password" {
  type        = string
  description = "Mot de passe de Bob"
}
