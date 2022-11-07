//////////////////////////////////
// Packer Builds
//////////////////////////////////

source "azure-arm" "debian-11" {

  # Azure Authentication
  subscription_id = var.subscription_id
  tenant_id       = var.tenant_id
  client_id       = var.client_id
  client_secret   = var.client_secret

  # Build image
  build_resource_group_name = var.build_resource_group_name

  custom_data = base64encode(file(var.build_properties.cloud_init_file))

  vm_size         = var.build_properties.vm_size
  os_type         = "Linux"
  os_disk_size_gb = 60

  # Store image
  managed_image_resource_group_name = var.image_resource_group_name
  managed_image_name                = join("-", ["debian-11", local.timestamp])

  # Copy to SIG
  /*shared_image_gallery_destination {
    subscription         = var.shared_image_gallery.subscription_id
    resource_group       = var.shared_image_gallery.resource_group_name
    gallery_name         = var.shared_image_gallery.gallery_name
    image_name           = var.image.name
    image_version        = var.image.version
    replication_regions  = local.azure_sig.locations
    storage_account_type = "Standard_LRS"
  }*/

  # Source image
  image_publisher = var.source_image.publisher
  image_offer     = var.source_image.offer
  image_sku       = var.source_image.sku
  image_version   = var.source_image.version
}
