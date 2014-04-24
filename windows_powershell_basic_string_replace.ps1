# Replaces words in a file with ones that you generate or specify
(Get-Content C:\TEMP\posh_testing\test.txt) | ForEach-Object {$_ -replace 'xyzqdata','$(hostname)'} | Out-File C:\TEMP\posh_testing\test.txt
