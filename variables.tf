variable "domain_example" {
  default = "tech.test"
}

variable "access_key" {
  description = "The access key for the AWS account"
  type        = string
}
variable "secret_key" {
  description = "The secret_key for the AWS account"
  type        = string
}

variable "token" {
  description = "Oauth token for authenticating to github"
  type        = string
}