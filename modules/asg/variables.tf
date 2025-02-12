variable "security_group_ids" {
  type = list(string)
}

variable "apiServerEndpoint" {
  type = string
}

variable "certificateAuthority" {
  type = string
}

variable "subnets" {
  type = list(string)
}