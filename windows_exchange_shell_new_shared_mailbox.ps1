# Creates a new shared mailbox with the options you specify, note that -WhatIf is on the end and will need to be removed for actions to complete.
# Requires the Exchange 2010 Management snap-in for PowerShell to be loaded.
#
New-Mailbox [Mailbox Name] -Shared -UserPrincipalName [username]@domain.tld -Database [Mailbox Database] -OrganizationalUnit [AD OU] -Whatif
