# OpenSSL
## Various commands
curl https://gist.github.com/zhiguangwang/7555cf13e15d64a5e0f3
curl https://www.sslshopper.com/article-most-common-openssl-commands.html

## View various thumbprints
curl https://knowledge.symantec.com/support/identity-protection-support/index?page=content&id=SO28771&actp=RSS&viewlocale=en_US

#SHA-1
openssl x509 -noout -fingerprint -sha1 -inform pem -in [certificate-file.crt] 

#SHA-256
openssl x509 -noout -fingerprint -sha256 -inform pem -in [certificate-file.crt] 

#SHA-1
openssl x509 -noout -fingerprint -sha1 -inform pem -in [certificate-file.crt]

#MD5
openssl x509 -noout -fingerprint -md5 -inform pem -in [certificate-file.crt]

# fin
