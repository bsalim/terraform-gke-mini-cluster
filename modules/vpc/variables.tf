variable "region" {
    description = "Region of the GKE cluster to be setup"
    type        = string
}

variable "vpc_name" {
    description = "VPC name"
    type        = string
}


variable "ip_cidr_range" {
    description = "IP CIDR range"
    type        = string
}

variable "ip_cidr_range_list" {
    description = "IP CIDR range in List format"
    type        = list(string)
}