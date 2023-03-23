terraform {

  backend "remote" {
    organization = "psvitov"

    workspaces {
      name = "k8s-stage"
    }
  }
}
