//////////////////////////////////
// vSphere Build Sources
//////////////////////////////////

source "vsphere-iso" "ubuntu" {
  disable_shutdown    = var.disable_shutdown
  convert_to_template = var.convert_to_template

  // vSphere Credentials
  vcenter_server      = var.vcenter_server
  insecure_connection = var.vcenter_insecure
  username            = var.vcenter_username
  password            = var.vcenter_password

  // vSphere Config
  datacenter = var.datacenter_name
  cluster    = var.cluster_name
  datastore  = var.datastore_name
  folder     = var.folder_name

  // VM Settings
  vm_name    = join("-", [var.vm_name, local.timestamp])
  vm_version = 14

  notes = join("\n", [
    format("OS: %s", "Ubuntu"),
    format("Version: %s", "22.04 LTS"),
    format("AdminUser: %s", var.admin.username),
    format("AdminPassword: %s", var.admin.password),
    format("Builder: %s", "Packer"),
    format("Built: %s", local.timestamp),
  ])

  CPUs                 = 2
  cpu_cores            = 1
  RAM                  = 4 * 1024
  CPU_hot_plug         = false
  RAM_hot_plug         = false
  guest_os_type        = "ubuntu64Guest" # See https://developer.vmware.com/apis/358/vsphere/doc/vim.vm.GuestOsDescriptor.GuestOsIdentifier.html
  firmware             = "efi"
  cdrom_type           = "ide"
  disk_controller_type = ["pvscsi"]

  storage {
    disk_controller_index = 0
    disk_size             = 20 * 1024
    disk_thin_provisioned = true
  }

  network_adapters {
    network      = var.network_name
    network_card = "vmxnet3"
  }

  // Removable Media (Installer)
  iso_paths = var.iso_paths

  // See https://cloudinit.readthedocs.io/en/latest/topics/datasources/nocloud.html
  http_directory = "" // No http-server

  cd_label = "CIDATA"
  cd_content = {
    "meta-data" = file("./data/meta-data")
    "user-data" = templatefile("./data/user-data.tpl", {
      hostname    = var.userdata.hostname
      address     = var.userdata.address
      gateway     = var.userdata.gateway
      nameservers = var.userdata.nameservers
      ssh_keys    = var.admin.ssh_keys
      username    = var.admin.username
      password    = var.admin.password_encrypted
    }),
  }

  // Boot & Provisioning
  ip_wait_timeout = "30m"
  boot_order      = "disk,cdrom"
  boot_wait       = "2s"
  boot_command = [
    "<wait>c<wait>",
    "linux /casper/vmlinuz --- autoinstall ds=\"nocloud\"",
    "<enter><wait>",
    "initrd /casper/initrd",
    "<enter><wait>",
    "boot",
    "<enter>",
  ]

  // Communication
  communicator              = "ssh"
  ssh_timeout               = "30m"
  ssh_port                  = 22
  ssh_handshake_attempts    = "100000"
  ssh_username              = var.admin.username
  ssh_password              = var.admin.password
  ssh_clear_authorized_keys = true

  shutdown_timeout     = "120m"
  tools_upgrade_policy = true
  remove_cdrom         = true
}
