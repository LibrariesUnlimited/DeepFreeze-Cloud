#Tested script but not through DeepFreeze Cloud

#Import Fortiguard Certificates into Root Certificate Store

Invoke-WebRequest "https://devon.imil.uk/adverts/test/Fortinet_CA_SSL(1).cer" -OutFile "C:\Windows\Temp\Fortinet_CA_SSL(1).cer"
Invoke-WebRequest "https://devon.imil.uk/adverts/test/Fortinet_CA_SSL(2).cer" -OutFile "C:\Windows\Temp\Fortinet_CA_SSL(2).cer"


$certFile1 = "C:\Windows\Temp\Fortinet_CA_SSL(1).cer"
$certFile2 = "C:\Windows\Temp\Fortinet_CA_SSL(2).cer"
$certStoreLocation = "Cert:\LocalMachine\Root"

#Import Certificate(1)
Import-Certificate -FilePath $certFile1 -CertStoreLocation $certStoreLocation
#Import Certificate(2)
Import-Certificate -FilePath $certFile2 -CertStoreLocation $certStoreLocation


