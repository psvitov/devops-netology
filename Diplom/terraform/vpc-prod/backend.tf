terraform {

  backend "remote" {
    organization = "psvitov"

    workspaces {
      name = "vpc-prod"
    }
  }
}
