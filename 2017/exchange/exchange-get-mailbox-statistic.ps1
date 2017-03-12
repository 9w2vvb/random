# from http://bit.ly/2mfDgLL
#
$report = @()
$outfile = "MailboxSizeReport" + ".csv" 
$user = Import-CSV c:\users.csv
foreach ($id in $user)
{
   Get-MailboxStatistics $id.alias | Sort-Object TotalItemSize -Descending 
     $tmp = New-Object PSObject
     $tmp | Add-Member -type NoteProperty -name DisplayName -value $id.DisplayName
     $tmp | Add-Member -type NoteProperty -name TotalItemSize -value $id.TotalItemSize
     $report += $tmp
}
$report | Export-CSV c:\$outfile –notypeinformation -encoding "unicode"
