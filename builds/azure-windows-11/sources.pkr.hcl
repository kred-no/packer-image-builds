//////////////////////////////////
// Source
//////////////////////////////////

source "azure-arm" "windows-11" {

  # Azure Authentication
  subscription_id = var.subscription_id
  tenant_id       = var.tenant_id
  client_id       = var.client_id
  client_secret   = var.client_secret

  # Build image
  build_resource_group_name = var.build_resource_group_name

  # Store image
  managed_image_resource_group_name = var.image_resource_group_name
  managed_image_name                = join("-", ["windows-11", local.timestamp])

  # Copy to SIG
  /*shared_image_gallery_destination {
    subscription         = var.shared_image_gallery.subscription_id
    resource_group       = var.shared_image_gallery.resource_group_name
    gallery_name         = var.shared_image_gallery.gallery_name
    image_name           = "WindowsServer"
    image_version        = "1.0.1"
    replication_regions  = local.sig_locations
    storage_account_type = "Standard_LRS"
  }*/

  # Source image
  image_publisher = var.source_image.publisher
  image_offer     = var.source_image.offer
  image_sku       = var.source_image.sku
  image_version   = var.source_image.version

  vm_size = var.build_properties.vm_size
  os_type = "Windows"
  #os_disk_size_gb = 127

  communicator   = "winrm"
  winrm_timeout  = "5m"
  winrm_insecure = true
  winrm_use_ssl  = true
  winrm_username = "packer"
}
