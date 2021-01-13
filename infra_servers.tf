
#################
# INFRA SERVERS
#################

resource "proxmox_vm_qemu" "infra_servers" {
  count       = 2
  name        = "project-infra-${count.index}"
  target_node = var.proxmox_target_node
  clone       = var.proxmox_template_name
  os_type     = "cloud-init"
  cores       = 2
  sockets     = "1"
  cpu         = "host"
  numa        = true
  memory      = 4096
  scsihw      = "virtio-scsi-pci"
  bootdisk    = "scsi0"
  hotplug     = "network,disk,cpu,memory,usb"
  pool        = var.proxmox_vm_pool
  agent       = 1
  ciuser      = var.ci_default_vm_user
  cipassword  = var.ci_default_vm_password

  disk {

    size     = "32G"
    type     = "scsi"
    storage  = "vm_pool_1"
    discard  = "on"
    iothread = 1
  }

  network {
    tag      = 5
    firewall = true
    model    = "virtio"
    bridge   = "vmbr2"
  }

  # This is to avoid terraform plan detecting changes that are not handled correctly by the plugin
  lifecycle {
    ignore_changes = [
      network,
      bootdisk,
      cipassword,
      ciuser,
      ipconfig0,
      nameserver,
      sshkeys,
      searchdomain,
      qemu_os,
    ]
  }

  # Cloud Init Settings
  ipconfig0 = "ip=10.20.213.10${count.index + 1}/24,gw=10.20.213.1"

  sshkeys = <<EOF
${var.users_ssh_keys}
EOF

  # Copy setup.sh
  provisioner "file" {
    source      = "scripts/setup.sh"
    destination = "/tmp/setup.sh"
    connection {
      type        = "ssh"
      user        = "automator"
      private_key = <<EOF
${var.ssh_private_key_automator}
EOF
      host        = self.ssh_host
      agent       = true
    }
  }

  # Run specific shell-script
  provisioner "remote-exec" {
    inline = [
      "sudo chmod a+x /tmp/setup.sh",
      "sudo bash /tmp/setup.sh",
    ]
    connection {
      type        = "ssh"
      user        = "automator"
      private_key = <<EOF
${var.ssh_private_key_automator}
EOF
      host        = self.ssh_host
      agent       = true
    }
  }

  # Reboot VM to fix DNS entry and remove cloud-init drive
  provisioner "local-exec" {
    working_dir = "./ansible/"
    command     = "ansible-playbook -i inventory.yaml phase1.yaml --extra-vars 'vm=${self.name}' --limit=${self.target_node}"
  }

  # Write info about hosts
  provisioner "local-exec" {
    working_dir = "./ansible/"
    command     = "echo '${self.name} ansible_host=${self.ssh_host} ansible_user=automator\n' >> hosts.ini"
  }

}
