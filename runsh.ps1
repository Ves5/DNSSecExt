$protocols = @{}
$protocols['Do53'] = '192.168.53.53:53'
$protocols['DoT'] = 'tls://dns.vessy.xyz'
$protocols['DoH'] = 'https://dns.vessy.xyz/dns-query'
$protocols['DoH3'] = 'h3://dns.vessy.xyz/dns-query'

Set-Location .\.vagrant\machines\client\vmware_desktop\*
$clientIP = (vmrun getGuestIPAddress ubuntu-20.04-amd64.vmx) | Out-String
$clientIP = [IPAddress]$clientIP.Trim()
Set-Location $PSScriptRoot
Set-Location .\.vagrant\machines\proxy\vmware_desktop\*
$proxyIP = (vmrun getGuestIPAddress ubuntu-20.04-amd64.vmx) | Out-String
$proxyIP = [IPAddress]$proxyIP.Trim()
Set-Location $PSScriptRoot
#Write-Host $clientIP
#Write-Host $proxyIP

$clientKey = ".\.vagrant\machines\client\vmware_desktop\private_key"
$proxyKey = ".\.vagrant\machines\proxy\vmware_desktop\private_key"

foreach ($k in $protocols.Keys) {
    Write-Host "Testing sh $($k)"
    # set up proxy
    ssh -i $proxyKey vagrant@$proxyIP "cd linux-amd64/ && sudo -b ./dnsproxy -l 192.168.53.10 -p 53 -u $($protocols[$k]) &> /dev/null"
    # start client 
    ssh -i $clientKey vagrant@$clientIP "cd /client && python3 dnstest.py -n 192.168.53.10 -i ./self_hosted.csv -e 10000 -o sh_r10k_$($k).csv -l $($k)_sh"
    # close proxy
    ssh -i $proxyKey vagrant@$proxyIP "sudo pkill -9 dnsproxy"
}


