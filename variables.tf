variable "vpc-cidr" {
  type    = string
  default = "10.0.0.0/16"
}

variable "enable-dns" {
  type    = bool
  default = true
}

variable "subject" {
  type    = string
  default = "cloud2"
}

variable "port" {
  type    = number
  default = 3000
}

variable "subnets" {
  type = list(
    object({
      cidr = string
      az   = string
    })
  )

  description = "Conjunto de variables para subnets de la vpc vpc-cloud2"

  default = [
    {
      cidr = "10.0.1.0/24",
      az   = "us-east-1a"
    },
    {
      cidr = "10.0.2.0/24",
      az   = "us-east-1b"
    },
    {
      cidr = "10.0.3.0/24",
      az   = "us-east-1a"
    },
    {
      cidr = "10.0.4.0/24",
      az   = "us-east-1b"
    },
  ]
}

variable "region" {
  type        = string
  description = "Región que estoy usando"
  default     = "us-east-1"
}
