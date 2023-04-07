terraform {

  backend "remote" {
    organization = "<login_TC>"

    workspaces {
      name = "<name>"
    }
  }
}
