foreach ($dev in Get-PnpDevice -FriendlyName '*Intel(R) UHD Graphics 630*') {
    pnputil /remove-device $dev.InstanceId }