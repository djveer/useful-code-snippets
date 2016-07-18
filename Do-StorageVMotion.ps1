# Move VMs (Storage vMotion) between datastores in the snapshots_ds* datastore cluster from where they exist currently
[CmdletBinding()]
Param(
  # File name with list of VMs
  [Parameter(Mandatory=$True)]
  [string]$filename,
  
  # Number of VMs from that list to migrate
  [Parameter(Mandatory=$True)]
  [string]$number_of_lines
    
)

$VMs = Get-VM (Get-Content $filename -First $number_of_lines)  
foreach ($v in $VMs) {
If ((Get-VM $v | Get-Datastore) -notlike "snapshots_ds*")  
    {
        $random_new_datastore = Get-Datastore snapshots_ds* | Where-object {$_.freespacegb -GE ($v.provisionedspaceGB*1.25)} | Get-Random -Count 1  
        do { Move-VM -VM $v -Datastore $random_New_Datastore -Confirm:$false -Verbose } While ($_.freespacegb -gt 750)
    }
Else {
        Write-Output "$v VM was already in one of the snapshots_ds* datastores, skipping."
     }
        Write-Output " "
}