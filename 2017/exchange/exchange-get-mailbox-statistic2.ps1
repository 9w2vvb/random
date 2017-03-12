# from http://bit.ly/2mflCIQ
#
Import-Csv "c:\list.csv" | ForEach-Object -Process
{Get-Mailbox $_.Name | Select-Object name,@{n="Size(MB)";e = {$MBXstat = Get-MailboxStatistics $_.name; $MBXstat.totalItemsize.value.toMB()}},@{n="DeletedSize(MB)";e = {$MBXstat = Get-MailboxStatistics $_.name; $MBXstat.totalDeletedItemsize.value.toMB()}},@{n="Items"; e = {$MBXstat = Get-MailboxStatistics $_.name ; $MBXstat.itemcount}},@{n="DeleteItems"; e = {$MBXstat = Get-MailboxStatistics $_.name ; $MBXstat.deleteditemcount}}} | Export-CSV "c:\userstats.csv" -notype
