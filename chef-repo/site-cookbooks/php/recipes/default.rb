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
