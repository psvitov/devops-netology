terraform {

  backend "remote" {
    organization = "psvitov"

    workspaces {
      name = "diplom"
    }
  }
}
