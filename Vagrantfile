# -*- mode: ruby -*-
# vi: set ft=ruby :

# Vagrantfile API/syntax version. Don't touch unless you know what you're doing!
VAGRANTFILE_API_VERSION = "2"


Vagrant.configure(VAGRANTFILE_API_VERSION) do |config|

  config.vm.box = "test-welly-xenial"

  config.vm.network "private_network", type: "dhcp"
  config.vm.network :forwarded_port, guest: 1080, host: 1080

  config.ssh.insert_key = false
  config.ssh.private_key_path = ["~/.vagrant.d/insecure_private_key"]

  config.vm.boot_timeout = 360

  config.vm.synced_folder "src/", "/home/vagrant/src",
    create: true,
    owner: "www-data",
    group: "www-data",
    mount_options: ["dmode=775,fmode=775"]

  config.vm.provider :virtualbox do |vb|
    vb.customize ["modifyvm", :id, "--memory", "2048"]
  end

  config.vm.provision "ansible" do |ansible|
    ansible.playbook = "playbook.yml"
    ansible.inventory_path = "config/local"
    ansible.limit = "local"
  end

end
