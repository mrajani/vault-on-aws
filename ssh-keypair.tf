#-------- Gen Key Pair --------#
resource "tls_private_key" "key_pair" {
  algorithm = "RSA"
  rsa_bits  = "2048"
}

resource "aws_key_pair" "ssh_key" {
  key_name   = var.ec2_key_pair_name
  public_key = tls_private_key.key_pair.public_key_openssh
}

resource "local_file" "private_pem" {
  content         = tls_private_key.key_pair.private_key_pem
  filename        = pathexpand("~/.ssh/${var.ec2_key_pair_name}.pem")
  file_permission = "0600"
}

resource "local_file" "public_openssh" {
  content         = tls_private_key.key_pair.public_key_openssh
  filename        = pathexpand("~/.ssh/${var.ec2_key_pair_name}.pub")
  file_permission = "0644"
}

output "vault_ssh_key" {
  value = aws_key_pair.ssh_key.id
}
