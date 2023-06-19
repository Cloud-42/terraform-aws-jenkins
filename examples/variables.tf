variable "env" {
  type    = string
  default = "test"
}
variable "tags" {
  type = map(string)
  default = {
    "env"     = "test"
    "service" = "jenkins"
  }
}
variable "region" {
  type = string
}

variable "account_id" {
  type = string
}
