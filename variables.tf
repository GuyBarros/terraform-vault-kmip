variable "kmip_path" {
  description = "The mount path for the ADP KMIP Secret Engine"
  default     = "kmip"
}

variable "kmip_scope" {
  description = "The scope of the KMIP client"
  default     = "hashicups"
}

variable "kmip_role" {
  description = "the role for the scope of the KMIP client"
  default     = "payment"
}