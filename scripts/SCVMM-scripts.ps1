#---First script
#---This is to get MacAddress for all VMs listed in VMs.txt
#
Import-Module virtualmachinemanager
$VMs = Get-Content -Path c:\temp\VMs.txt
foreach ($i in $VMs)
{ 
Get-VM -name $i | Get-VirtualNetworkAdapter | ft Name, SlotID, MACAddress >> .\Mac.txt
}
#
#---Second script
#---This is to set all VMs listed in VMs.txt to boot from the first NIC card
#
Import-Module virtualmachinemanager
$VMs = Get-Content -Path c:\temp\VMs.txt
foreach ($i in $VMs)
{ 
Get-VM -name $i | Set-SCVirtualMachine –FirstBootDevice “NIC,0”
}
#
