# -*- mode: ruby -*-
# vi: set ft=ruby :

# Vagrantfile API/syntax version. Don't touch unless you know what you're doing!
VAGRANTFILE_API_VERSION = "2"



Vagrant.configure(VAGRANTFILE_API_VERSION) do |config|
  config.vm.box = "puppetlabs/centos-6.5-64-puppet"

   config.vm.provision :shell, :inline => '/usr/bin/puppet module install puppetlabs-stdlib'
   config.vm.provision :shell, :inline => '/usr/bin/puppet module install nanliu-staging'

   config.vm.provision :puppet do |puppet|
     puppet.manifests_path = "vagrant"
     puppet.manifest_file  = "vagrant.pp"
     puppet.module_path = '../'
     puppet.hiera_config_path = "spec/fixtures/hiera.yaml"
     puppet.working_directory = "/vagrant"
   end

end
