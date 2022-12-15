$protocol = @{}
$protocol['do53'] = @{}
$protocol['do53']['cf'] = '1.1.1.1:53'
$protocol['do53']['g'] = '8.8.8.8:53'
$protocol['dot'] = @{}
$protocol['dot']['cf'] = 'tls://one.one.one.one'
$protocol['dot']['g'] = 'tls://dns.google'
$protocol['doh'] = @{}
$protocol['doh']['cf'] = 'https://cloudflare-dns.com/dns-query'
$protocol['doh']['g'] = 'https://dns.google/dns-query'
$protocol['doh3'] = @{}
$protocol['doh3']['cf'] = 'h3://cloudflare-dns.com/dns-query'
$protocol['doh3']['g'] = 'h3://dns.google/dns-query'

$chosen = $args[0]
$file_prefix = $args[1]

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

foreach ($k in $protocol[$chosen].Keys) {
    #Write-Host "cd linux-amd64/ && ./dnsproxy -l 192.168.53.10 -p 53 -u $($protocol[$chosen][$k]) &"
    # set up proxy
    ssh -i $proxyKey vagrant@$proxyIP "cd linux-amd64/ && sudo -b ./dnsproxy -l 192.168.53.10 -p 53 -u $($protocol[$chosen][$k]) &> /dev/null"
    # start client 
    ssh -i $clientKey vagrant@$clientIP "cd /client && python3 dnstest.py -n 192.168.53.10 -i ./majestic_top1m.csv -e 2 -o $($fileprefix)_r10k_$($k)_$($chosen).csv"
    # close proxy
    ssh -i $proxyKey vagrant@$proxyIP "sudo pkill -9 dnsproxy"
}


