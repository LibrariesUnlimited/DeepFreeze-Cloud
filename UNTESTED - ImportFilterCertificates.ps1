#Tested script but not through DeepFreeze Cloud

#Import Fortiguard Certificates into Root Certificate Store

Invoke-WebRequest "https://devon.imil.uk/adverts/test/Fortinet_CA_SSL(1).cer" -OutFile "C:\Windows\Temp\Fortinet_CA_SSL(1).cer"
Invoke-WebRequest "https://devon.imil.uk/adverts/test/Fortinet_CA_SSL(2).cer" -OutFile "C:\Windows\Temp\Fortinet_CA_SSL(2).cer"

#Import Certificate(1)
$params = @{
    FilePath = 'C:\Windows\Temp\Fortinet_CA_SSL(1).cer'
    CertStoreLocations = 'Cert:\LocalMachine\Root'
}
Import-Certificate $params

#Import Certificate(2)
$params = @{
    FilePath = 'C:\Windows\Temp\Fortinet_CA_SSL(2).cer'
    CertStoreLocations = 'Cert:\LocalMachine\Root'
}
Import-Certificate $params

