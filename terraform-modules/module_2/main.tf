resource "terraform_data" "echo" {
  triggers_replace = {
    always_run = timestamp()
  }
  provisioner "local-exec" {
    command = "echo 'Module_2 executed.'"
  }
}

