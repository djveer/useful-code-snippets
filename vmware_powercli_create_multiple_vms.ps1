#
# PowerCLI to create VMs
# Version 1.0
# Magnus Andersson RTS
# Some documentation can be found:  http://vcdx56.com/2014/01/30/create-multiple-vms-using-powercli/
#
# Specify vCenter Server, vCenter Server username and vCenter Server user password
$vCenter=”vc-demo01.vcdx56.com“
$vCenterUser=”vcdx56\magnus“
$vCenterUserPassword=”notsecret“
#
# Specify number of VMs you want to create
$vm_count = “500“
#
# Specify number of VM CPUs
$numcpu = “2“
#
# Specify number of VM MB RAM
$MBram = “2048“
#
# Specify VM disk size (in MB)
$MBguestdisk = “4096“
#
# Specify VM disk type, available options are Thin, Thick, EagerZeroedThick
$Typeguestdisk =”Thin“
#
# Specify VM guest OS
$guestOS = “winNetStandardGuest“
#
# Specify vCenter Server datastore
$ds = “VCDX56-DS01“
#
# Specify vCenter Server Virtual Machine & Templates folder
$Folder = “Scripttest“
#
# Specify the vSphere Cluster
$Cluster = “VCDX56-02“
#
# Specify the VM name to the left of the – sign
$VM_prefix = “VCDX56-“
#
# End of user input parameters
#_______________________________________________________
#
write-host “Connecting to vCenter Server $vCenter” -foreground green
Connect-viserver $vCenter -user $vCenterUser -password $vCenterUserPassword -WarningAction 0
1..$vm_count | foreach {
$y=”{0:D2}” -f $_
$VM_name= $VM_prefix + $y
$ESXi=Get-Cluster $Cluster | Get-VMHost -state connected | Get-Random
write-host “Creation of VM $VM_name initiated”  -foreground green
New-VM -Name $VM_Name -VMHost $ESXi -numcpu $numcpu -MemoryMB $MBram -DiskMB $MBguestdisk -DiskStorageFormat $Typeguestdisk -Datastore $ds -GuestId $guestOS -Location $Folder
write-host “Power On of the  VM $VM_name initiated”  -foreground green
Start-VM -VM $VM_name -confirm:$false -RunAsync
}
