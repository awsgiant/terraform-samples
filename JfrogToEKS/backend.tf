terraform {
  backend "local" {
    path = "fetch_docker_image.tfstate"
  }
}
