#Import Fortiguard Certificates into Root Certificate Store

#Download file to local machine
Invoke-WebRequest "https://devon.imil.uk/adverts/test/Fortinet_CA_SSL(1).cer" -OutFile "C:\Windows\Temp\Fortinet_CA_SSL(1).cer"

#Import Certificate
$params = @{
    FilePath = 'C:\Windows\Temp\Fortinet_CA_SSL(1).cer'
    CertStoreLocations = 'Cert:\LocalMachine\Root'
}

Import-Certificate @params
