# Get Windows OS version
#
[System.Environment]::OSVersion.Version
# Get Windows OS version with ReleaseID no
# from https://superuser.com/questions/963910/how-to-find-the-build-version-of-windows-10
#
$WinVer = New-Object -TypeName PSObject
$WinVer | Add-Member -MemberType NoteProperty -Name Major -Value $(Get-ItemProperty -Path 'Registry::HKEY_LOCAL_MACHINE\Software\Microsoft\Windows NT\CurrentVersion' CurrentMajorVersionNumber).CurrentMajorVersionNumber
$WinVer | Add-Member -MemberType NoteProperty -Name Minor -Value $(Get-ItemProperty -Path 'Registry::HKEY_LOCAL_MACHINE\Software\Microsoft\Windows NT\CurrentVersion' CurrentMinorVersionNumber).CurrentMinorVersionNumber
$WinVer | Add-Member -MemberType NoteProperty -Name Build -Value $(Get-ItemProperty -Path 'Registry::HKEY_LOCAL_MACHINE\Software\Microsoft\Windows NT\CurrentVersion' CurrentBuild).CurrentBuild
$WinVer | Add-Member -MemberType NoteProperty -Name Revision -Value $(Get-ItemProperty -Path 'Registry::HKEY_LOCAL_MACHINE\Software\Microsoft\Windows NT\CurrentVersion' UBR).UBR
$WinVer | Add-Member -MemberType NoteProperty -Name ReleaseId -Value $(Get-ItemProperty -Path 'Registry::HKEY_LOCAL_MACHINE\Software\Microsoft\Windows NT\CurrentVersion' ReleaseId).ReleaseId
$WinVer
# EOF
