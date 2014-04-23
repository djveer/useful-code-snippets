# A simple script to check AD credentials that you provide against AD
# # Script created by David J. Veer of the Server team - April 2014.
#
Function Test-ADAuthentication {
    param($username,$password)
    (new-object directoryservices.directoryentry "",$username,$password).psbase.name -ne $null
}

$username = Read-Host "Please type the username to test (domain\username or username@domain)"
$password = Read-Host "Please type the password to test for the above user"

Write-Output " "
Test-ADAuthentication $username $password
Write-Output " "
Write-Host "True = working, False = not working"
