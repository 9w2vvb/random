dir . | Foreach-Object { 
 $file = $_
 $hash = Get-FileHash $file -Algorithm SHA256
 $fileinfo = Get-Item $file
 
 New-Object -TypeName PSObject -Property @{
  LastWriteTime = $fileinfo.Length
  Algorithm = $hash.Algorithm
  MD5 = $hash.Hash
  Name = $fileinfo.Name
 }
} | fl
