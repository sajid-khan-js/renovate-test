locals {
  # use random for the project random suffix.
  server_name = "${var.env}-${random_pet.pet_name.id}-${random_id.random.hex}"
}

resource "random_pet" "pet_name" {
  keepers = {
    env = var.env
  }
}

resource "random_id" "random" {
  byte_length = 2
}
