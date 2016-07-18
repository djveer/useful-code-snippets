# Move VMs (Storage vMotion) between datastores in the nosnapshots_ds* datastores from where they exist currently
$VMs = Get-VM (Get-Content C:\temp\storage_vmotions\dsc3-la3stor-ds0-ds2_all.txt )  
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