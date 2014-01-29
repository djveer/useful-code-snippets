$hostname = Read-Host "Please enter the system name to fix dial-in on (64-bit only)"

copy-item \\isdvee2k8\C$\Windows\system32\mprsnap.dll \\$hostname\C$\Windows\system32\ -verbose
copy-item \\isdvee2k8\C$\Windows\system32\rasuser.dll \\$hostname\C$\Windows\system32\ -verbose
copy-item \\isdvee2k8\C$\Windows\system32\rtrfiltr.dll \\$hostname\C$\Windows\system32\ -verbose
copy-item \\isdvee2k8\C$\Windows\system32\en-US\mprsnap.dll.mui \\$hostname\C$\Windows\system32\en-US\ -verbose
copy-item \\isdvee2k8\C$\Windows\system32\en-US\rasuser.dll.mui \\$hostname\C$\Windows\system32\en-US\ -verbose
copy-item \\isdvee2k8\C$\Windows\system32\en-US\rtrfiltr.dll.mui \\$hostname\C$\Windows\system32\en-US\ -verbose
Write-Output " "
Write-Output "Script execution completed."

#psexec \\$hostname regsvr32 C:\Windows\system32\rasuser.dll

