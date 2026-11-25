variable "image" {
  description = "Image Docker à utiliser (ex : nginx:latest, httpd:2.4)"
  type        = string
  default     = "nginx:latest"

  validation {
    # nom[:tag] — minuscules, chiffres, . _ / - ; pas d'espace
    condition     = can(regex("^[a-z0-9][a-z0-9._/-]*(:[A-Za-z0-9._-]+)?$", var.image))
    error_message = "image doit être un nom d'image Docker valide, ex : nginx:latest."
  }
}

variable "memory" {
  description = "Mémoire max par conteneur, en Mo"
  type        = number
  default     = 256

  validation {
    # Docker refuse moins de 6 Mo ; plafond arbitraire pour éviter les fautes de frappe
    condition     = var.memory >= 6 && var.memory <= 4096
    error_message = "memory doit être compris entre 6 et 4096 Mo."
  }
}

variable "privileged" {
  description = "Lancer les conteneurs en mode privilégié"
  type        = bool
  default     = false
  # type = bool suffit : Terraform refuse déjà toute valeur autre que true/false
}

variable "container_count" {
  description = "Nombre de conteneurs à lancer"
  type        = number
  default     = 1

  validation {
    condition     = var.container_count >= 1 && var.container_count <= 10 && floor(var.container_count) == var.container_count
    error_message = "container_count doit être un entier entre 1 et 10."
  }
}

variable "start_port" {
  description = "Port hôte du premier conteneur ; les suivants prennent +1, +2…"
  type        = number
  default     = 8000

  validation {
    # < 1024 = ports privilégiés (root requis) ; le dernier port doit rester ≤ 65535
    condition     = var.start_port >= 1024 && var.start_port + var.container_count - 1 <= 65535
    error_message = "start_port doit être ≥ 1024 et start_port + container_count - 1 ne doit pas dépasser 65535."
  }
}

variable "name_prefix" {
  description = "Préfixe des noms de conteneurs (<prefix>-0, <prefix>-1…)"
  type        = string
  default     = "tf-container"

  validation {
    # Sert aussi de hostname : minuscules, chiffres, tirets, sans tiret au début ni à la fin
    condition     = can(regex("^[a-z0-9]([a-z0-9-]{0,30}[a-z0-9])?$", var.name_prefix))
    error_message = "name_prefix : 1 à 32 caractères, minuscules, chiffres ou tirets, sans tiret au début ni à la fin."
  }
}

variable "internal_port" {
  description = "Port d'écoute de l'application dans le conteneur"
  type        = number
  default     = 80

  validation {
    condition     = var.internal_port >= 1 && var.internal_port <= 65535
    error_message = "internal_port doit être compris entre 1 et 65535."
  }
}
