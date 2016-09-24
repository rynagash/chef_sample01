#
# Cookbook Name:: wordpress
# Recipe:: default
#
# Copyright 2016, YOUR_COMPANY_NAME
#
# All rights reserved - Do Not Redistribute
#

user = "vagrant"
wordpress = "wordpress-4.6.1-ja.tar.gz"

cookbook_file "wordpress" do
  source wordpress
  user user
  group user
  path "/home/#{user}/#{wordpress}"
end

document_base = node[:apache][:document_base]
execute "install wordpress" do
  user user
  group user
  command "tar zxvf /home/#{user}/#{wordpress} -C #{document_base}"
  action :run
end
