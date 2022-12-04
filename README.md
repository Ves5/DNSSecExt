# Research Project

## Provisions
Each machine after launch has a launch script written within [Vagrantfile](./Vagrantfile) that provisions required tools and software.

Each service used for testing is not launched at startup, just ready to be launched after connecting to the machine

### Client
Client starts with a synced folder containing the dns testing pythons [script](./client/synced/dnstest.py) and [reqs.txt](./client/synced/reqs.txt) file used for automatic installation of required python modules. File modifications within `synced` folder on host machine are reflected in client VM.

### DNS testing script
There is available `--help` command for the script.
```
python3 dnstest.py --help
```
Scripts takes in a `csv` file with domain names and a nameserver IP addresses then resolves names and writes results to a `csv` file.

It's possible to specify a range of domains from the file to be tested.

> The script was tested on Windows 11 OS and deemed working, may require small adjustements for Linux OS.

### Proxy

Used addresses of public resolvers:
* CloudFlare:
    * Do53: 1.1.1.1:53
    * DoT: tls://one.one.one.one
    * DoH: https://cloudflare-dns.com/dns-query
    * DoH3: h3://cloudflare-dns.com/dns-query
* Google:
    * Do53: 8.8.8.8:53
    * DoT: tls://dns.google
    * DoH: https://dns.google/dns-query
    * DoH3: h3://dns.google/dns-query
* AdGuard Home self-hosted Server:
    * Do53: 192.168.53.53:53
    * DoT: tls://certed.domain.name
    * DoH: https://certed.domain.name/dns-query
    * Doh3: h3://certed.domain.name/dns-query

### Server

https://davidaugustat.com/web/set-up-lets-encrypt-on-intranet-website for server certificate that's allowed by AdGuardHome, requires owning a publicly available domain (not server itself).

With current server and environment configuration, web dashboard can be accessed via http://localhost:3000 with credentials:
* Login: `admin`
* Password: `admin000`

## Vagrant commands
All commands to be used while inside the project directory or any of its subdirectories: `(C:)/path/to/project/DNSSecExt/`.

Vagrant virtual environment can be launched with command:
```
vagrant up --provider=<provider_name>
```
The environment was so far only tested with the use of `vmware_desktop` provider using VMWare Workstation 16 Player

To connect to each of the started VMs after the launch sequence, simply use:
```
vagrant ssh <VM_name>
```
Currently available machines: `client`, `proxy` or `server`.

To shut down the machines:
```
vagrant halt
```

To clean up the machines:
```
vagrant destroy
```

> Current setup was only tested under Windows 11 operating system.
