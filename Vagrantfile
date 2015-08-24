# -*- mode: ruby -*-
# vi: set ft=ruby sw=2 et :

# Vagrantfile API/syntax version. Don't touch unless you know what you're doing!
VAGRANTFILE_API_VERSION = "2"

# NOTE: guest machine:
#  - user: docker
#  - pass: tcuser

Vagrant.configure(VAGRANTFILE_API_VERSION) do |config|
  config.vm.box = "parallels/boot2docker"

  #config.vm.network "private_network", ip: "10.211.55.51"
  # config.vm.synced_folder <HOST-DIR>, <B2D-DIR>
  synced_dir = ENV["HOME"] + "/dev"
  config.vm.synced_folder synced_dir, synced_dir, id: "b2d"

  # WWW ports: [8000, 8010), [8080, 8090)
  10.times { |i|
    portno = 8000 + i
    config.vm.network "forwarded_port", guest: portno, host: portno
    portno = 8080 + i
    config.vm.network "forwarded_port", guest: portno, host: portno
  }
  # Etcd
  config.vm.network "forwarded_port", guest: 4001, host: 4001
  # Fake-S3 port
  config.vm.network "forwarded_port", guest: 4567, host: 4567
  # Postgres ports
  config.vm.network "forwarded_port", guest: 5432, host: 5432
  config.vm.network "forwarded_port", guest: 5433, host: 5433
  # Redis port
  config.vm.network "forwarded_port", guest: 6379, host: 6379

  config.vm.provider :virtualbox do |v|
    v.name = "b2d"
  end

  config.vm.provider :parallels do |v|
    v.name = "b2d"
    v.memory = 2024
    v.cpus = 2
    v.update_guest_tools = true
  end

  # Fix busybox/udhcpc issue
  config.vm.provision :shell do |s|
    s.inline = <<-EOT
      if ! grep -qs ^nameserver /etc/resolv.conf; then
        sudo /sbin/udhcpc
      fi
      cat /etc/resolv.conf
    EOT
  end

  # Adjust datetime after suspend and resume
  config.vm.provision :shell do |s|
    s.inline = <<-EOT
      sudo /usr/local/bin/ntpclient -s -h pool.ntp.org
      date
    EOT
  end

end
