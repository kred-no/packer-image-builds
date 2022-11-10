//////////////////////////////////
// vSphere Sources
//////////////////////////////////

source "vsphere-iso" "win2k22" {
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
    format("OS: %s", "WindowsServer"),
    format("Version: %s", "2022"),
    format("AdminUser: %s", var.admin.username),
    format("AdminPassword: %s", var.admin.password),
    format("Builder: %s", "Packer (OpenSSH)"),
    format("Built: %s", local.timestamp),
  ])

  CPUs                 = 2
  cpu_cores            = 1
  RAM                  = 4 * 1024
  CPU_hot_plug         = false
  RAM_hot_plug         = false
  guest_os_type        = "windows9_64Guest" # See https://developer.vmware.com/apis/358/vsphere/doc/vim.vm.GuestOsDescriptor.GuestOsIdentifier.html
  firmware             = "bios"
  cdrom_type           = "ide"
  disk_controller_type = ["lsilogic-sas"]

  storage {
    disk_controller_index = 0
    disk_size             = 32 * 1024
    disk_thin_provisioned = true
  }

  network_adapters {
    network      = var.network_name
    network_card = "e1000"
  }

  // Removable Media (Installer & VMware Tools)
  iso_paths = compact([
    var.iso_installer_path,
    var.iso_tools_path,
  ])

  // See https://cloudinit.readthedocs.io/en/latest/topics/datasources/nocloud.html
  http_directory = "" // No http-server

  floppy_content = {
    "Autounattend.xml" = templatefile(join("/", [var.resources_folder, "templates/Autounattend.xml.template"]), {
      hostname = var.vm_name // Do not use same hostname and ssh-username
      username = var.admin.username
      password = var.admin.password

      files = [
        "A:\\Set-AutoUpdateDisabled.ps1",
        "A:\\Set-StaticNetwork.ps1",
        "A:\\Add-OpenSSH.ps1",
        "A:\\Add-VMwareTools.ps1", // Run last; used to retrieve ip-address automatically.
      ]
    })

    "Set-StaticNetwork.ps1" = templatefile(join("/", [var.resources_folder, "templates/Set-StaticNetwork.ps1.template"]), {
      address     = var.static_network.address
      netmask     = var.static_network.netmask
      gateway     = var.static_network.gateway
      nameservers = var.static_network.nameservers
    })

    "Set-AutoUpdateDisabled.ps1" = file(join("/", [var.resources_folder, "powershell/Set-AutoUpdateDisabled.ps1"]))
    "Add-OpenSSH.ps1"               = file(join("/", [var.resources_folder, "powershell/Add-OpenSSH.ps1"]))
    "Add-VMwareTools.ps1"           = file(join("/", [var.resources_folder, "powershell/Add-VMwareTools.ps1"]))
  }

  // Boot & Provisioning
  ip_wait_timeout = "120m"
  boot_order      = "disk,cdrom"
  boot_wait       = "2s"
  boot_command    = ["<spacebar>"]

  // Communication
  communicator              = "ssh"
  ssh_timeout               = "120m"
  ssh_port                  = 22
  ssh_handshake_attempts    = "100000"
  ssh_username              = var.admin.username
  ssh_password              = var.admin.password
  ssh_clear_authorized_keys = true

  shutdown_timeout     = "120m"
  tools_upgrade_policy = true
  remove_cdrom         = true
}
