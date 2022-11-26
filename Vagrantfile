$client_script = <<-SCRIPT
echo "Updating system..."
sudo apt update
# possibly unneded? - upgrade takes a long time
# sudo apt upgrade -y
echo "Installing pip..."
sudo apt install python3-pip -y
echo "Installing required python modules..."
pip3 install -r /client/reqs.txt
echo "Client done!"
SCRIPT

$proxy_script = <<-SCRIPT
echo "Updating system..."
sudo apt update
# possibly unneded? - upgrade takes a long time
# sudo apt upgrade -y
# go might not be needed when installing compiled version!
#echo "Installing go.."
#curl -OL https://go.dev/dl/go1.19.1.linux-amd64.tar.gz
#sudo tar -C /usr/local -xf go1.19.1.linux-amd64.tar.gz
#sudo echo "export PATH=$PATH:/usr/local/go/bin" >> ~/.profile
#rm go1.19.1.linux-amd64.tar.gz
echo "Intalling AdGuard DNS Proxy..."
curl -OL https://github.com/AdguardTeam/dnsproxy/releases/download/v0.46.2/dnsproxy-linux-amd64-v0.46.2.tar.gz && tar -xf dnsproxy-linux-amd64-v0.46.2.tar.gz && rm dnsproxy-linux-amd64-v0.46.2.tar.gz && cd linux-amd64/
./dnsproxy --version
echo "Proxy done!"
SCRIPT

$server_script = <<-SCRIPT
echo "Updating system..."
sudo apt update
echo "Installing AdGuardHome..."
curl -s -S -L https://raw.githubusercontent.com/AdguardTeam/AdGuardHome/master/scripts/install.sh | sh -s -- -v
sudo service AdGuardHome stop
cd /opt/AdGuardHome/
# sudo ./AdGuardHome -c /server/serverConfig.yaml -s start
echo "Server done!"
SCRIPT

Vagrant.configure("2") do |config|
    config.vm.define "client" do |client|
        client.vm.box = "bento/ubuntu-20.04"
        client.vm.network "private_network", ip: "192.168.53.11"
        client.vm.hostname = "client"
        client.vm.synced_folder "client/synced", "/client"
        client.vm.provision "shell", inline: $client_script
    end
    config.vm.define "proxy" do |proxy|
        proxy.vm.box = "bento/ubuntu-20.04"
        proxy.vm.network "private_network", ip: "192.168.53.10"
        proxy.vm.hostname = "proxy"
        #proxy.vm.synced_folder "../pc" "/vm"
        proxy.vm.provision "shell", inline: $proxy_script
    end
    # config.vm.define "server" do |server|
    #     server.vm.box = "bento/ubuntu-20.04"
    #     server.vm.network "private_network", ip: "192.168.53.53"
    #     server.vm.hostname = "server"
    #     server.vm.network "forwarded_port", guest: 3000, host: 3000
    #     client.vm.synced_folder "server", "/server"
    #     server.vm.provision "shell", inline: $server_script
    # end
end