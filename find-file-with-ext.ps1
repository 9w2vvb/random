# Find file ext within dir and subdir
Get-ChildItem . -Recurse | where Extension -eq '.edb'
# or
Get-ChildItem . -Recurse | Where-Object {$_.Extension -eq ".edb"}
# EOF
