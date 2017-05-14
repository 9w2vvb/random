# From https://twitter.com/msuiche/status/863737365290000384
# Get MD5 hash for file(s)

dir . | Foreach-Object {
        $file = $_
        $hash = Get-FileHash $file -Algorithm SHA256
        $fileinfo = Get-Item $file

        New-Object -TypeName PSObject -Property @{
        LastWriteTime = $fileinfo.Length
        Algorithm = $hash.Algorithm
        MD5 = $hash.Hash
        Name = $fileinfo.Name }

     } | fl

# EOF
