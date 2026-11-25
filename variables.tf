variable "image" {
  description = "Image Docker à utiliser"
  type        = string
  default     = "nginx:latest"
}

variable "memory" {
  description = "Mémoire max par conteneur, en Mo"
  type        = number
  default     = 256
}

variable "privileged" {
  description = "Lancer les conteneurs en mode privilégié"
  type        = bool
  default     = false
}

variable "container_count" {
  description = "Nombre de conteneurs à lancer"
  type        = number
  default     = 1

  validation {
    condition     = var.container_count >= 1
    error_message = "container_count doit valoir au moins 1."
  }
}

variable "start_port" {
  description = "Port hôte du premier conteneur ; les suivants prennent +1, +2…"
  type        = number
  default     = 8000
}

variable "name_prefix" {
  description = "Préfixe des noms de conteneurs (<prefix>-0, <prefix>-1…)"
  type        = string
  default     = "tf-container"
}

variable "internal_port" {
  description = "Port d'écoute de l'application dans le conteneur"
  type        = number
  default     = 80
}
