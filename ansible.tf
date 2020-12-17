locals {
  ansible-hosts = pathexpand("./ansible-hosts")
  ansible-cfg   = pathexpand("./ansible.cfg")
}

resource "local_file" "ansible-hosts" {
  filename        = local.ansible-hosts
  file_permission = "0644"
  content         = <<EOF
[jumpbox]
bastion

[vault]
vault-0
vault-1
vault-2

EOF
}

resource "local_file" "ansible-cfg" {
  filename        = local.ansible-cfg
  file_permission = "0644"
  content         = <<EOF
[defaults]
stdout_callback = yaml
inventory = ./ansible-hosts
host_key_checking = False
deprecation_warnings = False

[ssh_connection]
ssh_args = -F ssh_vault_config
control_path = ~/.ssh/ansible-%r@%h:%p
EOF
}
