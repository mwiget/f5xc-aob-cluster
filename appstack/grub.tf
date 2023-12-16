resource "local_file" "grub_cfg" {
  content       = templatefile("${path.module}/templates/grub.cfg", {
    base_url    = var.base_url
  })
  filename = format("%s/EFI/BOOT/grub.cfg", var.local_tftp_folder)
}

output "grub_file" {
  value = format("%s/EFI/BOOT/grub.cfg", var.local_tftp_folder)
}
