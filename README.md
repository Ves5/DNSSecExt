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
Scripts takes in a `csv` file with domain names in the form of [example file](./client/test_domains.csv) and a list of nameserver IP addresses then resolves names and writes results to a `csv` file.

> The script was tested on Windows 11 OS and deemed working, may require small adjustements for Linux OS.

## Vagrant commands
All commands to be used while inside the project directory or any of its subdirectories: `(C:)/path/to/project/badawczy/`.

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