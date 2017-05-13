# From https://blogs.technet.microsoft.com/parallel_universe_-_ms_tech_blog/2012/02/06/powershell-mass-import-and-enable-lync-users-for-ev/
# Author John McCabe [MSFT]February 6, 2012
#
#############################################################################################

import-module lync

$path = $env:USERPROFILE + “\Desktop”
$importfile = “import.csv”
$fullpath = $path + “\” + $importfile
$fullpath

$testinputfile = test-path $fullpath

if ($testinputfile -eq $false)
{
 write-host “$fullpath is not found please create this file before continuing” -foregroundcolor red -backgroundcolor black
 exit 0
}

$users = $null
$users = import-csv $fullpath

if ($users -eq $null)
{

 write-host “No Users Found in Input File” -foregroundcolor red -backgroundcolor black
 exit 0
}
else
{

 $count = $users.count
 $count
 write-host “We have found ” $count “Users to import”
}

write-host “Processing Users…..`n” -foregroundcolor Yellow -backgroundcolor Black
$index = 1

Foreach ($user in $users)
{
 
 write-host “Processing User ” $index ” of ” $count
 $samaccountname = $user.samaccountname
 $phone = $user.phonenumber
 $ext = $user.extension
 $lineuri = “tel:”+$phone+”;ext=”+$ext

 write-host “Testing is $samaccountname is enabled for Lync” -foregroundcolor Yellow -backgroundcolor black

 $adexist = get-csaduser | where {$_.samaccountname -eq $samaccountname}
 
 if ($adexist -eq $null)
 {
  $usernotinad = $true
  write-host “User ” $samaccountname ” not in AD”
 }
 else
 {
  $usernotinad = $false
 }

 
 if ($usernotinad -ne $true)
 {

  $enabled = get-csuser |where {$_.samaccountname -eq $samaccountname}

  if ($enabled -eq $null)
  {
  
 
    write-host “User not Lync enabled, Do You Wish To Enable Y/N?”
    $ans = read-host
   
     if ($ans -eq “Y”)
     {
    write-host “Enabing the User…”
    $sipdomain = get-cssipdomain
    $pool = get-csservice -registrar
    get-csaduser | where {$_.samaccountname -eq $samaccountname} | Enable-Csuser -registrarpool $pool.poolfqdn -sipaddresstype SamaccountName -sipdomain $sipdomain.name
     }
  

  
   
  }

  $enabled = get-csuser |where {$_.samaccountname -eq $samaccountname}

  if ($enabled -ne $null)
  {
   write-host “User is enabled” -foregroundcolor Green -backgroundcolor black

   if ($enabled.enterprisevoiceenabled -eq $False)
   {
   
    write-host “User is not EV Enabled , Enabling Now…” -foregroundcolor yellow -backgroundcolor black
    set-csuser -identity $enabled.displayname -EnterpriseVoiceEnabled $True -LineUri $lineuri
    
    if ($?)
    {
     write-host “Successfully Enabled $samaccountname” -foregroundcolor Green -backgroundcolor black
    }
    else
    {
     write-host “$samaccountname not enabled successfullly for EV” -foregroundcolor red -backgroundcolor black

   }
 
  }

 }

 $index++
 

}

<# CSV file format
firstname,lastname,samaccountname,phonenumber,extension
john,doe,jdoe,+35312791234,1234
sean,test,test,+12312312312,1234
#>

# EOF
