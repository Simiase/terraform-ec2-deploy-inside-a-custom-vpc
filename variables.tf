variable "project_vpc_cidr" {
default     = "10.0.0.0/16"
description = "Project vpc cidr block"
type        = string 
}

variable "private_subnet_cidr" {
default     = "10.0.8.0/24"
description = "private subnet cidr block"
type        = string
}

variable "public_subnet_cidr" {
default     = "10.0.9.0/24"
description = "public subnet cidr block"
type        = string  
}

