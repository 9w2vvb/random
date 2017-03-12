# from http://bit.ly/2lQFUvY
#
$usersFromFile = Get-Content "users.txt"

$userstats = @()
ForEach ($u in $usersFromFile)
{
    Write-Host "Processing $u..."
    $foundUserStats = Get-MailboxStatistics $u | `
        Select DisplayName, TotalItemSize, ItemCount, ServerName, StorageGroupName, Database
        
    $userstats = $userstats + $foundUserStats
}

$userstats | Export-Csv -Path "userstats.csv" -notype
