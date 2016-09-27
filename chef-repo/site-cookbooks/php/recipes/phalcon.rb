#
# Cookbook Name:: php
# Recipe:: default
#
# Copyright 2016, YOUR_COMPANY_NAME
#
# All rights reserved - Do Not Redistribute
#

bash "add phalcon repo" do
  user "root"
  code "curl -s https://packagecloud.io/install/repositories/phalcon/stable/script.deb.sh | bash"
end


yum_package "php56-phalcon" do
  action [:install, :upgrade]
  options node[:php][:options]
end

# php 設定
template "falcon.ini" do
  path "/etc/php.d/falcon.ini"
  source "falcon.ini.erb"
  mode 0644
end
