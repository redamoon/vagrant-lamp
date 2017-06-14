Vagrant.configure(2) do |config|
  config.vm.box = "bento/centos-6.7"
  if Vagrant.has_plugin?("vagrant-cachier")
    config.cache.scope = :box
  end
  # config.vm.provision :shell, :path => "provisioning/repository.sh", :privileged => true
  config.vm.network "private_network", ip: "192.168.60.100"
  config.vm.hostname = "local.dev"
  config.hostsupdater.aliases = ["vagrant.web01","vagrant.web02"]
  config.vm.provision :shell, :path => "provisioning/provision.sh", :privileged => false
end
