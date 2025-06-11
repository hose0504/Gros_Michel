variable "instance_name" {
  type = string
}

variable "ami_id" {
  type = string
}

variable "instance_type" {
  type = string
}

variable "key_name" {
  type = string
}

variable "allow_all_access" {
  type    = bool
  default = false
}

variable "vpc_id" {
  type = string
}

variable "subnet_id" {
  type = string
}

variable "user_data" {
  type    = string
  default = ""
}
