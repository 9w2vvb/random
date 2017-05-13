# From http://hseminiano.blogspot.com/2013/03/lync-powershell-script-to-mass-enable.html
# Also https://digitalbamboo.wordpress.com/2016/06/30/hermans-mass-enable-ad-users-for-lync-or-skype-for-business/
# To enable Enterprise Voice users
#
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
“Enabling ” + $c.Identity + ” for Lync” 
$lineuri = “tel:+1” + $c.PhoneNumber + “;ext=” + $c.Extension
Enable-csuser -identity $c.Identity -registrarpool $c.RegistrarPool -sipaddresstype $c.SipAddressType -sipdomain $c.SipDomain 

# Pause for 30 seconds for AD Replication
write-host -foregroundcolor Green “Pausing for 30 seconds for AD Replication”

Start-Sleep -s 30

Set-CsUser -Identity $c.Identity -enterprisevoiceenabled $True -lineuri $lineuri
Grant-CsDialPlan -Identity $c.Identity -PolicyName $c.DialPlan
Grant-CsVoicePolicy -Identity $c.Identity -PolicyName $c.VoicePolicy
}
#

<# CSV file format
Identity,RegistrarPool,SIPAddressType,SipDomain,PhoneNumber,Extension,DialPlan,VoicePolicy
John Doe,PoolFQDN.Domain.com,EmailAddress,SIPDomain.com,2815551234,1234,HoustonDialPlan,HoustonVoicePolicy
#>

# EOF 
