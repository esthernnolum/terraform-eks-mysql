variable "mydbinstance_identifier" {
  description = "The identifier for the RDS MySQL database instance."
  default     = "my-db-instance"
}

variable "mydbinstance_username" {
  description = "The username for the RDS MySQL database."
  default     = "admin"
}

variable "mydbinstance_password" {
  description = "The password for the RDS MySQL database."
  default     = "admin" # input your password here
}
variable "db-sg-id" {
  type = list(string)
}