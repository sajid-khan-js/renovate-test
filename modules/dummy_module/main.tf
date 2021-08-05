# Creating resource
resource "null_resource" "echo_vars" {
  provisioner "local-exec" {
    command = "echo $FOO $BAR $BAZ"
    environment = {
      FOO = "aaa"
      BAR = 1234
      BAZ = "true"
    }
  }
}
