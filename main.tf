terraform {
  backend "s3" {}

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }

    random = {
      source  = "hashicorp/random"
      version = "~> 3.5"
    }
  }
}

provider "aws" {}
provider "random" {}

variable "exchangerate_api_key" {
  description = "api key for exchangerate-api"
  type        = string
}

resource "random_pet" "exchangerate_api_key" {
  length = 2
}

resource "aws_ssm_parameter" "exchangerate_api_key" {
  name        = "/exchangerate-api/${random_pet.exchangerate_api_key.id}/api_key"
  description = "api key for exchangerate-api"
  type        = "SecureString"
  value       = var.exchangerate_api_key
}

data "aws_region" "current" {}

output "EXCHANGERATE_API_KEY" {
  value = {
    arn: aws_ssm_parameter.exchangerate_api_key.arn
    key: aws_ssm_parameter.exchangerate_api_key.name
    region: data.aws_region.current.name
    type: "ssm"
  }
}

output "EXCHANGERATE_API_URL" {
  value = "https://api.exchangeratesapi.io/v1"
}
