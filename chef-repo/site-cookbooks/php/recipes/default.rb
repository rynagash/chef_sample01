#
# Cookbook Name:: php
# Recipe:: default
#
# Copyright 2016, YOUR_COMPANY_NAME
#
# All rights reserved - Do Not Redistribute
#
node[:php][:packages].each do |package_name|
  package "#{package_name}" do
    action [:install, :upgrade]
    options node[:php][:options]
  end
end

# php 設定
template "app.ini" do
  path "/etc/php.d/app.ini"
  source "app.ini.erb"
  mode 0644
end

# composer
bash 'install_composer' do
  not_if { File.exists?('/usr/local/bin/composer') }
  user 'root'
  cwd '/tmp'
  code <<-EOH
    curl -sS https://getcomposer.org/installer | php -- --install-dir=/tmp
    mv /tmp/composer.phar /usr/local/bin/composer
  EOH
end
