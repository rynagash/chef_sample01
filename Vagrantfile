# -*- mode: ruby -*-
# vi: set ft=ruby :

sync_folder = 'www/app'

chef_setting = {
  :apache =>  {
    :packages => %w(httpd24u httpd24u-devel),
    :options  => '--enablerepo=ius',
    :document_root => '/var/www/app',
    :user          => 'vagrant',
    :group         => 'vagrant',
    :listen        => 80
  },
  :php => {
    :packages => %w(php php-devel php-common php-cli php-pear php-pdo php-mysqlnd php-xml php-process php-mbstring php-mcrypt php-pecl-xdebug php-opcache),
    :options  => "--enablerepo=remi,epel --enablerepo=remi-php56"
  }
}
# All Vagrant configuration is done below. The "2" in Vagrant.configure
# configures the configuration version (we support older styles for
# backwards compatibility). Please don't change it unless you know what
# you're doing.
Vagrant.configure("2") do |config|
  # The most common configuration options are documented and commented below.
  # For a complete reference, please see the online documentation at
  # https://docs.vagrantup.com.

  # Every Vagrant development environment requires a box. You can search for
  # boxes at https://atlas.hashicorp.com/search.
  config.vm.box = "bento/centos-7.2"

  # Disable automatic box update checking. If you disable this, then
  # boxes will only be checked for updates when the user runs
  # `vagrant box outdated`. This is not recommended.
  # config.vm.box_check_update = false

  # Create a forwarded port mapping which allows access to a specific port
  # within the machine from a port on the host machine. In the example below,
  # accessing "localhost:8080" will access port 80 on the guest machine.
  # config.vm.network "forwarded_port", guest: 80, host: 8080

  # Create a private network, which allows host-only access to the machine
  # using a specific IP.
  config.vm.network "private_network", ip: "192.168.33.11"
  config.vm.hostname = "chef-sample01.local"

  # Create a public network, which generally matched to bridged network.
  # Bridged networks make the machine appear as another physical device on
  # your network.
  # config.vm.network "public_network"

  # Share an additional folder to the guest VM. The first argument is
  # the path on the host to the actual folder. The second argument is
  # the path on the guest to mount the folder. And the optional third
  # argument is a set of non-required options.
  # config.vm.synced_folder "../data", "/vagrant_data"
  config.vm.synced_folder ".", "/vagrant", :mount_options => ['dmode=755', 'fmode=644']
  config.vm.synced_folder sync_folder, chef_setting[:apache][:document_root], :create => "true", :mount_options => ['dmode=755', 'fmode=644']

  # Provider-specific configuration so you can fine-tune various
  # backing providers for Vagrant. These expose provider-specific options.
  # Example for VirtualBox:
  #
  # config.vm.provider "virtualbox" do |vb|
  #   # Display the VirtualBox GUI when booting the machine
  #   vb.gui = true
  #
  #   # Customize the amount of memory on the VM:
  #   vb.memory = "1024"
  # end
  #
  # View the documentation for the provider you are using for more
  # information on available options.

  # Define a Vagrant Push strategy for pushing to Atlas. Other push strategies
  # such as FTP and Heroku are also available. See the documentation at
  # https://docs.vagrantup.com/v2/push/atlas.html for more information.
  # config.push.define "atlas" do |push|
  #   push.app = "YOUR_ATLAS_USERNAME/YOUR_APPLICATION_NAME"
  # end

  # Enable provisioning with a shell script. Additional provisioners such as
  # Puppet, Chef, Ansible, Salt, and Docker are also available. Please see the
  # documentation for more information about their specific syntax and use.
  # config.vm.provision "shell", inline: <<-SHELL
  #   # apt-get update
  #   # apt-get install -y apache2
  #  timedatectl set-timezone Asia/Tokyo
  # SHELL
  config.vm.provision "chef_solo" do |chef|
    # chef.cookbooks_path = "chef-repo/site-cookbooks/"
    chef.cookbooks_path = [ "chef-repo/cookbooks", "chef-repo/site-cookbooks" ]
    chef.run_list = [
      "build-essential",
      "yum-epel",
      "yum-remi",
      "yum-ius",
      "localedef",
      "apache",
      "php",
      "mysql",
    ]
    chef.json = chef_setting
  end

  # Vagrant plugin setting
  unless Vagrant.has_plugin?("vagrant-omnibus")
    raise "Plugin not installed: vagrant-omnibus. Please excecute `vagrant plugin install vagrant-omnibus`."
  end
  config.omnibus.chef_version = :latest

  unless Vagrant.has_plugin?("vagrant-berkshelf")
    raise "Plugin not installed: vagrant-berkshelf. Please excecute `vagrant plugin install vagrant-berkshelf`."
  end
  config.berkshelf.berksfile_path = "./chef-repo/Berksfile"
  config.berkshelf.enabled = true

  unless Vagrant.has_plugin?("vagrant-cachier")
    raise "Plugin not installed: vagrant-cachier. Please excecute `vagrant plugin install vagrant-cachier`."
  end
  config.cache.scope = :box

end
