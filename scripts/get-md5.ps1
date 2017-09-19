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
# change Algorithm to (supported): "MACTripleDES", "MD5", "RIPEMD160", "SHA1", "SHA256", "SHA384", "SHA512".
