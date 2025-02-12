variable "private_subnets" {
  type = list(string)
}

variable "role_arn" {
  type = string
}

variable "security_group_ids" {
  type = list(string)
}

variable "node_role_arn" {
  type = string
}
