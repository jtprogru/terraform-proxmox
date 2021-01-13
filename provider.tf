provider "proxmox" {
  pm_tls_insecure = true
  pm_api_url      = "https://hypervisor-srv-40.adv.ru:8006/api2/json"
  pm_user         = var.proxmox_user_login
  pm_password     = var.proxmox_user_pass
  pm_otp          = ""
}
