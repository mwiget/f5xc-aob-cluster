# f5xc-aob-cluster

Experimental deployment of single and multi-node bare metal Appstack sites.

Clone this repo: `git clone --recurse-submodules https://github.com/mwiget/f5xc-aoa-cluster`

Copy terraform.tfvars.example to terraform.tfvars, then update the file with credentials 
and list of node servers

## Prerequisites

- dhcpd server offering boot loader (e.g. BOOTX64.EFI) to clients with vendor-class-identifier "PXEClient"
- tftp server hosting boot loader, grub and pxeboot kernel (vmlinuz and initrd.img)
- http server hosting content of RHEL-9.2023.x-Installer.iso and generated kickstart cfg files
- ipmi/ilo script to force one-shot pxe boot and reset

## Deployment

```
terraform init
terraform plan
terraform apply
```

