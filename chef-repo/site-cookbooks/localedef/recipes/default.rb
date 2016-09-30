#
# Cookbook Name:: localedef
# Recipe:: default
#
# Copyright 2016, YOUR_COMPANY_NAME
#
# All rights reserved - Do Not Redistribute
#
bash 'loca7ledef' do
  user "root"
  code 'localedef -f UTF-8 -i ja_JP ja_JP.UTF-8'
end

# clock settings
log("tz-info(before): #{Time.now.strftime("%z %Z")}")

service 'crond'

link '/etc/localtime' do
  to '/usr/share/zoneinfo/Asia/Tokyo'
  notifies :restart, 'service[crond]', :immediately
  only_if {File.exists?('/usr/share/zoneinfo/Asia/Tokyo')}
end

log("tz-info(after): #{Time.now.strftime("%z %Z")}")

yum_package 'yum-fastestmirror' do
  action :install
end

%w(zsh vim tree jq git).each do |package_name|
  package "#{package_name}" do
    action [:install, :upgrade]
  end
end

bash 'chsh' do
  code 'chsh -s /bin/zsh vagrant'
end

template '/home/vagrant/.zshrc' do
  owner 'vagrant'
  mode 0755
  source 'zshrc.erb'
  path '/home/vagrant/.zshrc'
end

bash "yum-update" do
  user "root"
  code "yum -y update"
end
