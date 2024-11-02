# Resource Group/Location
variable "location" {
    type          = string
}
variable "resource_group" {
    type          = string
}

# Resource Virtual Machine
variable "application_type" {
    type          = string
}
variable "resource_type" {
    type          = string
}
variable "public_ip_address_id" {
    type          = string
}
variable "public_subnet_id" {
    type          = string
}
variable "admin_username" {
    type          = string
}

variable "admin_username" {
  description = "The admin username for the VM"
  type        = string
  default     = "NhanNT57"
}

variable "admin_password" {
  description = "The admin password for the VM"
  type        = string
  sensitive   = true
  default     = "Gobackhome339@#"
}


variable "ssh_key" {
    type          = string
    default       = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQCvF+ImNNa98cauW5DR0I2tKxdisy9OWCVy8UdcSXYDA1y/hH8xytsdOtKvzwYBvT5pLZmkYr93jXPf1AjDV8Xo/krp1iMrPcmGZtQprtVHz1s1bTr3hRz3JJ0G2++ECKws/iQDcqdo9Sug7merheIJz4khhIjd5v6jttyfeEVsk6tP34s0S7szUhafJgkKFRQY0acWumThIoYz+jpo934fMwBCrbD2QSQETsfgFxslee57O91IeGDqBGjgC43RRWiABi2LkczqU6Rkm3rumFe/gbMnaO5hEyM2/nqo2wUhBes5dLg3H1O5snj7knsocgnXSvc2oeJl63QL7hCSZ149ILUhZZWC6GExD5F/qQNEVldttVxcO9hOzSxeCxkzfGrlmPEP9moxhHGqW++sCK/4qslHRxbKBqnFBUfvdUVsPeUNbXC5GD27vfIa3XKCy0y872zMcuLYQUvRV/7v3UyFCZHmZKUfHqpk7B+X7xj+R2z6IwdOSnnuoVIYOjfrQpE= ad@DESKTOP-RAH6IHC"
}