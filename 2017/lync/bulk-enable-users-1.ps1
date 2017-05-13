# From http://hseminiano.blogspot.com/2013/03/lync-powershell-script-to-mass-enable.html
# Also https://digitalbamboo.wordpress.com/2016/06/30/hermans-mass-enable-ad-users-for-lync-or-skype-for-business/
# To enable PC-to-PC users only

if ($args[0] -eq $null)
    { 
    $userNameFile = read-host “Enter the full path of the .csv file with the user information.” 
    $userNameFile  = $usernamefile -replace ‘”‘,””}  
else  
    {$usernamefile = $args[0]} 
if ($userNameFile -ne “”)  
    {$csv=import-csv $userNameFile}  
else  
    {“Could not find a valid .csv with the user information.”
    exit} 
foreach($c in $csv) 
# enable for lync 
{ 
“Enabling ” + $c.Identity + ” for Lync 2010″ 
Enable-csuser -identity $c.Identity -registrarpool $c.RegistrarPool –sipaddresstype $c.SipAddressType -sipdomain $c.SipDomain 
}

#
# CSV file format
Identity,RegistrarPool,SIPAddressType,SipDomain
John Doe,PoolFQDN.Domain.com,EmailAddress,SIPDomain.com
#
