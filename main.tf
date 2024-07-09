provider "aws" {
  region = "your_region"
  access_key = "your_access_key_id"
  secret_key = "your_secret_access_key"
}

# Generate timestamp for state file name
data "external" "generate_state_filename" {
  program = ["bash", "-c", "echo '{\"timestamped_filename\": \"terraform-state-$(date +%Y-%m-%d-%H-%M-%S).tfstate\"}'"]
}

terraform {
  backend "s3" {
    bucket = "terraform-state-bucket"
    key    = data.external.generate_state_filename.result.timestamped_filename  # Use timestamped state file name
    region = "your_bucket_region"
    access_key = "your_access_key_id"
    secret_key = "your_secret_access_key"
  }
}

resource "aws_s3_bucket" "example_bucket" {
  bucket = "example-bucket"
  acl    = "private"
}

output "terraform_state_file" {
  value = data.external.generate_state_filename.result.timestamped_filename
}
