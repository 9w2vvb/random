# 1. from http://bit.ly/2nfNfWe
#
get-mailbox -server <server> -ResultSize unlimited |
 Where {$_.UseDatabaseQuotaDefaults -eq $false} |
   ft DisplayName,IssueWarningQuota,ProhibitSendQuota,@{label="TotalItemSize(MB)";expression={(get-mailboxstatistics $_).TotalItemSize.Value.ToMB()}}
#
# 2. from http://bit.ly/2nfXhGQ
#
Get-Mailbox -Server EXCH2-CU1.CU1.COM -ResultSize unlimited |
 Where {$_.UseDatabaseQuotaDefaults -eq $false} |
 Select DisplayName,IssueWarningQuota,ProhibitSendQuota,@{label="TotalItemSize(MB)";expression={(get-mailboxstatistics $_).TotalItemSize.Value.ToMB()}} |
 Export-Csv "C:\test\UserMailboxSizes.csv" -NoTypeInformation
#
# 3. from http://bit.ly/2lTx9kC
#
Get-Mailbox -ResultSize unlimited |
 Select-Object DisplayName, Alias, UseDatabaseQuotaDefaults, IssueWarningQuota, ProhibitSendQuota, ProhibitSendReceiveQuota, @{label="TotalItemSize(MB)";expression={(get-mailboxstatistics $_).TotalItemSize.Value.ToMB()}}, @{label="ItemCount";expression={(get-mailboxstatistics $_).ItemCount}}, Database |
 Export-Csv C:\Temp\MailboxSizes.CSV –NoTypeInformation –Encoding UTF8
#

# test 1
# assuming the csv file has samaccountname header
$users = import-csv user.csv

@(foreach ($user in $users) {
    get-mailbox $user.samaccountname | select-object DisplayName, @{name="TotalItemSize(MB)";expression={(get-mailboxstatistics $_).TotalItemSize.Value.ToMB()}}, *quota*
}) | Export-Csv UserMailboxSizes.csv -NoTypeInformation

# test 2 (same as test 1)
import-csv user.csv | ForEach-Object {get-mailbox $_.samaccountname | select-object DisplayName, @{name="TotalItemSize(MB)";expression={(get-mailboxstatistics $_).TotalItemSize.Value.ToMB()}}, *quota*} | Export-Csv UserMailboxSizes.csv -NoTypeInformation

# test 3
# assuming the csv file has emailaddress header
$users = (import-csv "user.csv")
foreach ($user in $users){
    $userResults = Get-Mailbox $user | Select DisplayName,IssueWarningQuota,ProhibitSendQuota,UseDatabaseQuotaDefaults,@{label="TotalItemSize(MB)";expression={(get-mailboxstatistics $_).TotalItemSize.Value.ToMB()}}
    $userResults | Export-Csv "UserMailboxSizes.csv" -NoType -Append
}

# test 4 (same as test 3)
$users = (import-csv "user.csv")
foreach ($user in $users){
    $userResults = Get-Mailbox $user | where{$_.UseDatabaseQuotaDefaults -eq $False} | Select DisplayName,IssueWarningQuota,ProhibitSendQuota,UseDatabaseQuotaDefaults,@{label="TotalItemSize(MB)";expression={(get-mailboxstatistics $_).TotalItemSize.Value.ToMB()}}
    IF($userresults){$userResults | Export-Csv "UserMailboxSizes.csv" -NoType -Append}
}

