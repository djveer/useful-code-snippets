# Ran in PowerShell, must have Exchange 2010 or higher PowerShell snap-in.
#

Set-MailboxAutoReplyConfiguration <alias> -AutoReplyState enabled -ExternalAudience all -InternalMessage <Message to internal senders> -ExternalMessage <Message to external senders>
