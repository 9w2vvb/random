# working!

$users = Import-Csv .\user.csv
@(foreach ($user in $users) {
    Get-Mailbox $user.SamAccountName | Select-Object DisplayName, @{name="TotalItemSize(MB)";expression={(get-mailboxstatistics $_).TotalItemSize.Value.ToMB()}}, *quota*
}) | Export-Csv UserMailboxSizes.csv -NoTypeInformation

# format of csv file:
# SamAccountName
# user1
# user2
# user3
