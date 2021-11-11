resource "null_resource" "default-setting" {

 provisioner "local-exec" {

    command = "/bin/bash default.sh"
  }
}
