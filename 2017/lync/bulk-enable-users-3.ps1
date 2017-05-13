# From http://www.markc.me.uk/blog/files/BulkSkypeUsers.html 
#
#Skype/Lync Enable Users
#Mac@MarkC.me.uk
#2016-03-30 v1.0 (clean)
 
import-Module Lync

#Update these variables appropriately
$DefaultPool="LyncPool.ds.co.uk"
$LogFile=".\EnableLOG.txt"
$UserCSV=".\EnableUsers.csv"

$LogLine="================================================================================"

Out-File $LogFile -Input $LogLine
Out-File $LogFile -Input "Enabling users...." -Append
Out-File $LogFile -Input $LogLine -Append

$oShell=new-object -com "wscript.shell"
$Computername=$oShell.ExpandEnvironmentStrings("%COMPUTERNAME%")
$UserName=$oShell.ExpandEnvironmentStrings("%USERNAME%")
$Domain=$oShell.ExpandEnvironmentStrings("%USERDOMAIN%")
$Date=date

Out-File $LogFile -Input "Computername	: $Computername" -Append
Out-File $LogFile -Input "User Name	: $Username" -Append
Out-File $LogFile -Input "Domain		: $Domain" -Append
Out-File $Logfile -Input "Executed	: $Date" -Append
Out-File $LogFile -Input $Logline -Append

$UserCSVFile=import-csv $UserCSV

ForEach ($LineItem in $UserCSVFile) {

	$mail=$null
	$RegistrarPool=$null
	$sipAddress=$null
	$ConferencingPolicy=$null
	$ClientPolicy=$null
	$ExternalAccessPolicy=$null
	$Command=$null
	
	$mail=$LineItem.mail
	$RegistrarPool=$LineItem.RegistrarPool
	$sipAddress=$LineItem.sipAddress
	$ConferencingPolicy=$LineItem.ConferencingPolicy
	$ClientPolicy=$LineItem.ClientPolicy
	$ExternalAccessPolicy=$lineItem.ExternalAccessPolicy
	
	IF ($mail -eq "") {
		Out-File $LogFile -Input "Error - missing Mail Address for user. User will NOT be enabled." -Append
		}
	ELSE {
		Out-File $LogFile -Input "Enabling: $mail" -Append
		}
	
	IF ($RegistrarPool -eq "") {
		Out-File $LogFile -Input "	No pool - using default $DefaultPool" -Append
		$RegistrarPool=$DefaultPool
		}
	ELSE {
		Out-File $LogFile -Input "	Pool: $RegistrarPool" -Append
		}
	
	IF ($sipAddress -eq "") {
		$sipAddress="sip:"+$mail
		Out-File $LogFile -Input "	No SIP Address, using Email $sipAddress" -Append
		}
	ELSE {
		Out-File $LogFile -Input "	SIP Address $sipAddress" -Append
		IF ($sipAddress.substring(0,3) -eq "sip") {
			Out-File $LogFile -Input "	Correctly formatted SIP address." -Append
			}
		ELSE	{
			Out-File $LogFile -Input "	SIP address missing SIP designator - adding." -Append
			$sipAddress="sip:"+$sipAddress
			Out-File $LogFile -Input "	Corrected SIP Address: $sipAddress" -Append
			}
		}
	
	IF ($ConferencingPolicy -eq "" -OR $ConferencingPolicy -eq $null) {
		Out-File $LogFile -Input "	No Conferencing Policy to be assigned." -Append
		}
	ELSE {
		Out-File $LogFile -Input "	Conferencing Policy: $ConferencingPolicy" -Append
		}
		
	IF ($ClientPolicy -eq "" -OR $ClientPolicy -eq $null) {
		Out-File $LogFile -Input "	No Client Policy to be assigned." -Append
		}
	ELSE {
		Out-File $LogFile -Input "	Client Policy: $ClientPolicy" -Append
		}
	
	IF ($ExternalAccessPolicy -eq "" -Or $ExternalAccessPolicy -eq $null) {
		Out-File $LogFile -Input "	No External Access Policy to be assigned." -Append
		}
	ELSE {
		Out-File $LogFile -Input "	External Access Policy: $ExternalAccessPolicy" -Append
		}

	#Now let's formulate the command for the enablement
	
	$Command = @"
		Get-csADUser -Ldapfilter ("mail=$mail")|enable-csUser -RegistrarPool "$RegistrarPool" -SipAddress "$sipAddress"
"@
	Out-File $LogFile -Input "	Enabling user..." -Append
	Out-File $LogFile -Input $Command -Append
	Out-File $LogFile -Input "		Executing enablement...." -Append

	invoke-expression $Command
	
	#Now apply client policy
	$Command=$null
	
	
	IF ($ClientPolicy -eq "" -OR $ClientPolicy -eq $null) {
		Out-File $LogFile -Input "	No client policy to apply." -Append
		}
	ELSE {
		$Command=@"
		Get-csADUser -LdapFilter ("mail=$mail")|Grant-csclientpolicy -PolicyName "$ClientPolicy"
"@
		Out-File $LogFile -Input "	Policy Application Command: " -Append
		Out-File $LogFile -Input "	$Command" -Append
		Out-File $LogFile -Input "			Executing client policy application..." -Append
		Invoke-Expression $Command
		}
	
	#Now apply conferencing policy
	$Command=$null
	
	IF ($ConferencingPolicy -eq "" -OR $ConferencingPolicy -eq $null) {
		Out-File $LogFile -Input "	No conferencing policy to apply." -Append
		}
	ELSE {
		$Command=@"
		Get-csADUser -LdapFilter ("mail=$mail")|Grant-csconferencingpolicy -PolicyName "$ConferencingPolicy"
"@
		Out-File $LogFile -Input "	Policy Application Command: " -Append
		Out-File $LogFile -Input "	$Command" -Append
		Out-File $LogFile -Input "			Executing conferencing policy application..." -Append
		Invoke-Expression $Command
		}
		
	#Now apply external access policy
	$Command=$null
	
	IF ($ExternalAccessPolicy -eq "" -OR $ExternalAccessPolicy -eq $null) {
		Out-File $LogFile -Input "	No external access policy to apply." -Append
		}
	ELSE {
		$Command=@"
		Get-csADUser -LdapFilter ("mail=$mail")|Grant-csExternalAccessPolicy -PolicyName "$ExternalAccessPolicy"
"@
		Out-File $LogFile -Input "	Policy Application Command: " -Append
		Out-File $LogFile -Input "	$Command" -Append
		Out-File $LogFile -Input "			Executing external access policy application..." -Append
		Invoke-Expression $Command
		}	
	
	Out-File $LogFile -Input $LogLine -Append
	
	}
	
Out-File $LogFile -Input "Creating the check file." -Append
Out-File $LogFile -Input $LogLine -Append

#Check to see if UserCheck.CSV exists
$UserCheckExists=Test-Path "UserCheck.CSV"

IF ($UserCheckExists -eq $True) {
	Out-File $LogFile -Input "UserCheck.CSV already exists - deleting." -Append
	Remove-Item UserCheck.CSV
	}
ELSE {
	Out-File $LogFile -Input "UserCheck.CSV not found." -Append
	}

$UserCSVFile=$null
$UserCSVFile=import-csv $UserCSV
$UserCheckFile=".\UserCheck.CSV"

Out-File $LogFile -Input "Exporting user information to UserCheck.CSV." -Append

ForEach ($LineItem in $UserCSVFile) {
	$Command=$null
	$sipAddress=$null
	$sipAddress=$LineItem.sipAddress
	$Command=@"
	Get-csUser -Identity $sipAddress|select-object sipAddress,RegistrarPool,ConferencingPolicy,ClientPolicy,ExternalAccessPolicy|Export-csv $UserCheckFile -Append
"@
	Invoke-Expression $Command
	}
	
Out-File $LogFile -Input "Finished exporting." -Append
Out-File $LogFile -Input $LogLine -Append
Out-File $LogFile -Input "Log files to check: $Logfile contains the output logging (this file....)" -Append
Out-File $LogFile -Input "UserCheck.CSV contains an export of the affected users - check SIP address and relevant policies." -Append
Out-File $LogFile -Input $LogLine -Append

Write-Host "Operation finished. Please check the logs."
Write-Host "$LogFile for the main functional logs."
Write-Host "UserCheck.CSV contains a list of the users and associated policies - check for accuracy/errors."
#
# CSV file format (minimum)
mail
Test.User1@DeathStar.co.uk
Test.User2@DeathStar.co.uk
Test.User3@DeathStar.co.uk
#
# CSV file format (add-ons)
sAMAccountName,mail,RegistrarPool,sipAddress,ConferencingPolicy,ClientPolicy,ExternalAccessPolicy
Test1,Test.User1@DeathStar.co.uk,LyncPool.ds.co.uk,Test.User1@DeathStar.co.uk,All Conferencing Facilities,SkypeSkin,Full External Access
Test2,Test.User2@DeathStar.co.uk,LyncPool.ds.co.uk,Test.User2@DeathStar.co.uk,All Conferencing Facilities,SkypeSkin,Full External Access
Test3,Test.User3@DeathStar.co.uk,LyncPool.ds.co.uk,Test.User3@DeathStar.co.uk,No Conferencing,LyncSkin,No External Access
#
# EOF
