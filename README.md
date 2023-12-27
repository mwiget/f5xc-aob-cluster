# f5xc-aob-cluster

Experimental deployment of single and multi-node bare metal Appstack sites with automatic power cycle
and one time pxe boot triggers.

Clone this repo: `git clone --recurse-submodules https://github.com/mwiget/f5xc-aob-cluster`

Copy terraform.tfvars.example to terraform.tfvars, then update the file with credentials 
and list of node servers

## Prerequisites

- dhcpd server offering boot loader (e.g. BOOTX64.EFI) to clients with vendor-class-identifier "PXEClient"
- tftp server hosting boot loader, grub and pxeboot kernel (vmlinuz and initrd.img)
- http server hosting content of RHEL-9.2023.x-Installer.iso and generated kickstart cfg files
- ipmi/ilo script to force one-shot pxe boot and reset

Copy terraform.tfvars.example to terraform.tfvars and provide the requested credentials and local paths 
to tftp and http folders.

## Preperation

Configure your dhcp server to provide next-server and filename to clients with vendor-class-identifier "PXEClient".
Example config with static ip assignment for isc-dhcp-server:

```
$ sudo cat /etc/dhcp/dhcpd.conf
#
# DHCP Server Configuration file.
#   see /usr/share/doc/dhcp-server/dhcpd.conf.example
#   see dhcpd.conf(5) man page
#
option architecture-type code 93 = unsigned integer 16;

subnet 192.168.42.0 netmask 255.255.255.0 {
  option routers 192.168.42.1;
  option domain-name-servers 1.1.1.1;
  range 192.168.42.20 192.168.42.99;
  default-lease-time 120;
  max-lease-time 240;
  deny unknown-clients;

  class "pxeclients" {
    match if substring (option vendor-class-identifier, 0, 9) = "PXEClient";
    next-server 192.168.42.77;
          if option architecture-type = 00:07 {
            filename "redhat/EFI/BOOT/BOOTX64.EFI";
          }
          else {
            filename "pxelinux/pxelinux.0";
          }
  }
}

host green1 { hardware ethernet 3c:ec:ef:43:1d:66; fixed-address 192.168.42.32; }
host blue1  { hardware ethernet 3c:ec:ef:db:08:62; fixed-address 192.168.42.33; }
host black1 { hardware ethernet 3c:ec:ef:43:1c:b2; fixed-address 192.168.42.36; }
```

Example config for MikroTik router (currently without conditional class handling):

```
/ip dhcp-server network
add address=192.168.42.0/24 boot-file-name=redhat/EFI/BOOT/BOOTX64.EFI gateway=192.168.42.1 next-server=192.168.42.254
```

The shell script [install_f5xc_rhel_iso.sh](./install_f5xc_rhel_iso.sh) downloads the latest F5 XC 
RHEL-9.2023.x-Installer.iso unless already present, grabs the tftp and http paths from terraform.tfvars,
mounts the iso and extracts the required boot, kernel, grub and install files and copies them to the provided
tftp and http folders. The script has been used on OS/X and Linux.

```
$ ./install_f5xc_rhel_iso.sh 
quering https://vesio.blob.core.windows.net/releases/rhel/9/x86_64/images/latest ...
using local image RHEL-9.2023.29-Installer.iso ...
checking if the local target folders /Users/mwiget/Sites/redhat and /private/tftpboot/redhat exist ...
mounting iso ...
/dev/disk8
Executing: /usr/bin/kmutil load -p /System/Library/Extensions/cd9660.kext
copying files to tftp folder /private/tftpboot/redhat/ ...
copying files to http folder /Users/mwiget/Sites/redhat/ ...
"disk8" ejected.
```
(example shown on OS/X with local TFTPD and HTTPD setup)


To verify the files can be fetched via tftp and http, the script [check_tftp_httpd.sh](check_tftp_httpd.sh) can be used:

```
$ ./check_tftp_httpd.sh 

getting redhat/EFI/BOOT/BOOTX64.EFI via tftp ...                
Received 955206 bytes in 0.1 seconds

getting redhat/EFI/BOOT/grub.cfg via tftp ...
Received 741 bytes in 0.0 seconds

getting kickstart files via http  ...
3c:ec:ef:43:1c:b2.cfg
3c:ec:ef:43:1d:66.cfg
3c:ec:ef:db:08:62.cfg
```

The kickstart files will only be created with `terraform apply`.

Update or copy  main.tf with cluster and baremetal node information (name, mac address and optionl
ipmi ip address). If ipmi is provided (username/password via terraform.tfvars and ip via main.tf, 
the nodes will be set to boot once via pxe and go thru a power off and on (with 5 second delay) to
trigger pxe installation. 


```
terraform init
terraform plan
terraform apply
```

Once deployment is complete, a local kubeconfig file will be present in the current folder, which can be used
to access the cluster:

```
export KUBECONFIG="$PWD/mw-baremetal-3.kubeconfig"
$ kubectl get nodes -o wide
NAME     STATUS   ROLES        AGE    VERSION        INTERNAL-IP     EXTERNAL-IP   OS-IMAGE                                      KERNEL-VERSION                 CONTAINER-RUNTIME
black1   Ready    ves-master   103m   v1.24.13-ves   192.168.42.34   <none>        Red Hat Enterprise Linux 9.2023.29.2 (Plow)   5.14.0-284.30.1.el9_2.x86_64   cri-o://1.24.4
blue1    Ready    ves-master   104m   v1.24.13-ves   192.168.42.33   <none>        Red Hat Enterprise Linux 9.2023.29.2 (Plow)   5.14.0-284.30.1.el9_2.x86_64   cri-o://1.24.4
green1   Ready    ves-master   103m   v1.24.13-ves   192.168.42.32   <none>        Red Hat Enterprise Linux 9.2023.29.2 (Plow)   5.14.0-284.30.1.el9_2.x86_64   cri-o://1.24.4
```
## Troubleshooting

- Best to start with `manual_registration` set to true in main.tf for the cluster. This won't automatically
register each node with F5 XC and won't wait for the cluster to become online. It will create grub.cfg and 
the kickstart files and place them under var.local_http_folder/kickstart and var.local_tftp_folder/EFI/BOOT/grub.cfg.
- When stopping terraform, manual cleanup of F5 XC created objects will be required (appstack site and managed k8s) before redeployment.

## Caveats

- Tested so far only with supermicro servers and kvm-voltstack-combo.

