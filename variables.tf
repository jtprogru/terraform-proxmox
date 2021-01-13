
variable "proxmox_user_login" {
  description = "Логин для доступа в Proxmox"
  type    = string
  default = "proxmox-user@pve"
}

variable "proxmox_user_pass" {
  description = "Пароль для доступа в Proxmox"
  type    = string
  default = "proxmox-passowd"
}

variable "proxmox_target_node" {
  description = "Целевая нода на которую размещается ВМ"
  type    = string
  default = "proxmox-srv-40"
}

variable "proxmox_vm_pool" {
  description = "Ресурсный пулл в который добавляются ВМ"
  type    = string
  default = "proxmox-pool"
}

variable "proxmox_template_name" {
  description = "Наименование шаблона из которого равзорачиваются ВМ"
  type    = string
  default = "ubuntu-2004-cloudinit-template"
}

variable "ci_default_vm_user" {
  description = "Логин пользователя для автоматизации"
  default = "automation-user"
}

variable "ci_default_vm_password" {
  description = "Пароль пользователя для автоматизации"
  default = "automation-password"
}

variable "users_ssh_keys" {
  description = "Список всех публичных ключей которые необходимо добавить в авторизованные пользователю var.ci_default_vm_user"
  default = <<EOF
ssh-rsa ASDFSDFASDF automation-user@example.com
ssh-rsa WERTYQWERTY admin@example.com
EOF

}

variable "ssh_private_key_automator" {
  description = "Приватная часть ключа для логина под пользователем var.ci_default_vm_user"
  default = <<PKEY
-----BEGIN RSA PRIVATE KEY-----
MIIG5AIBAAKCAYEAzI7U1abJBdHDppqiYpQUDgY2PBUKneJNXQ25NqsZs94wT9zt
...
omqPEYE0Hsxy9T5qn1B+GDUhUkAL0g1pM3LbiaVZYhRuAFfQDyaKog==
-----END RSA PRIVATE KEY-----
PKEY
}
