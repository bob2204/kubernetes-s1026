resource "keycloak_realm" "k8s" {
  realm   = "k8s"
  enabled = true
}

resource "keycloak_openid_client" "kubernetes" {
  realm_id    = keycloak_realm.k8s.id
  client_id   = "kubernetes"
  name        = "kubernetes"
  access_type = "CONFIDENTIAL"
  service_accounts_enabled = true
  enabled     = true
  client_secret = var.kubernetes_client_secret 

  standard_flow_enabled = true
  oauth2_device_authorization_grant_enabled = true

  valid_redirect_uris = [
    "http://localhost:8000/*"
  ]

  authorization {
    allow_remote_resource_management = true
    decision_strategy                = "UNANIMOUS"
    keep_defaults                    = false
    policy_enforcement_mode          = "ENFORCING"
  }
}

resource "keycloak_user" "bob" {
  realm_id       = keycloak_realm.k8s.id
  username       = "bob"
  enabled        = true
  email          = "bob@stage.local"
  email_verified = true
  first_name     = "bob"
  last_name      = "solo"

  initial_password {
    value        = var.bob_password
    temporary    = false
  }
}

resource "keycloak_group" "stage" {
  realm_id       = keycloak_realm.k8s.id
  name           = "stage"
}

resource "keycloak_group_memberships" "stage_members" {
  realm_id       = keycloak_realm.k8s.id
  group_id       = keycloak_group.stage.id

  members  = [
    keycloak_user.bob.username
  ]
}

resource "keycloak_openid_client_scope" "groups_client_scope" {
  realm_id               = keycloak_realm.k8s.id
  name                   = "groups"
  description            = "When requested, this scope will map a user's group memberships to a claim"
  include_in_token_scope = true
}

resource "keycloak_openid_group_membership_protocol_mapper" "group_membership_mapper" {
  realm_id               = keycloak_realm.k8s.id
  client_scope_id        = keycloak_openid_client_scope.groups_client_scope.id
  name                   = "group-membership-mapper"
  full_path              = false

  claim_name             = "groups"
}

resource "keycloak_openid_client_scope" "name_client_scope" {
  realm_id               = keycloak_realm.k8s.id
  name                   = "name"
  include_in_token_scope = true
}

resource "keycloak_openid_user_attribute_protocol_mapper" "name_claim_mapper" {
  realm_id               = keycloak_realm.k8s.id
  client_scope_id        = keycloak_openid_client_scope.name_client_scope.id
  name                   = "username"

  claim_name     = "name"
  user_attribute = "username"
}

resource "keycloak_openid_client_default_scopes" "kubernetes_client_default_scopes" {
  realm_id  = keycloak_realm.k8s.id
  client_id = keycloak_openid_client.kubernetes.id

  default_scopes = [
    "profile",
    "email",
    "groups",
    "name"
  ]
}
