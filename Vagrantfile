# coding: utf-8
# -*- mode: ruby -*-
# vi: set ft=ruby :

require 'rbconfig'

CFG_TZ = "Europe/Madrid" # timezone, like US/Pacific, US/Eastern, UTC, Europe/Warsaw, etc.

Vagrant.configure("2") do |config|

  config.vm.box = "ubuntu/wily64"

  config.vm.hostname = "vagrant-bdge"

  config.vm.network :private_network, ip: "192.168.15.166"
  # Hadoop web UI ports
  config.vm.network :forwarded_port, guest: 50070, host: 50070
  config.vm.network :forwarded_port, guest: 50075, host: 50075
  config.vm.network :forwarded_port, guest: 50090, host: 50090
  # HBase web UI ports
  config.vm.network :forwarded_port, guest: 60010, host: 60010
  config.vm.network :forwarded_port, guest: 60030, host: 60030
  # Thrift
  config.vm.network :forwarded_port, guest: 9090, host: 9090
  # ZooKeeper
  config.vm.network :forwarded_port, guest: 2181, host: 2181

  # Spark
  #config.vm.network :forwarded_port, guest: 7077, host: 7077

  # Couchdb
  config.vm.network :forwarded_port, guest: 5984, host: 5984

  # Mongodb
  config.vm.network :forwarded_port, guest: 27017, host: 27017

  # Neo4j
  config.vm.network :forwarded_port, guest: 7474, host: 7474

  # MySQL
  config.vm.network :forwarded_port, guest: 3306, host: 3306

  # Cassandra
  config.vm.network :forwarded_port, guest: 9042, host: 9042

  # Node.js
  config.vm.network :forwarded_port, guest: 3000, host: 3000

  # Jupyter playbook
  config.vm.network :forwarded_port, guest: 8888, host: 8888

  # Hue
  config.vm.network :forwarded_port, guest: 8000, host: 8000


  config.ssh.forward_agent = true

  # increase available memory
  config.vm.provider :virtualbox do |vb|
     vb.customize ["modifyvm", :id, "--memory", "2560"]
     vb.customize ["modifyvm", :id, "--cpus", "2"]
     vb.customize ["modifyvm", :id, "--ioapic", "on"]
  end
  is_windows = (RbConfig::CONFIG['host_os'] =~ /mswin|mingw|cygwin/)
  if is_windows
    # Provisioning configuration for shell script.
    config.vm.provision "shell" do |sh|
      sh.privileged = false
      sh.path = "windows/windows.sh"
      sh.args = "ansible/playbook.yml ansible/ansible_hosts"
    end
  else
    config.vm.provision :ansible do |ansible|
      ansible.playbook = "ansible/playbook.yml"
      ansible.inventory_path = "ansible/ansible_hosts"
      ansible.limit = "all"
      ansible.verbose = "vvvv"
    end

  end

end
