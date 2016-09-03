#
# Cookbook Name:: php
# Recipe:: default
#
# Copyright 2016, YOUR_COMPANY_NAME
#
# All rights reserved - Do Not Redistribute
#
%w[
  php php-devel
  php-common
  php-cli
  php-pear
  php-pdo
  php-mysqlnd
  php-xml
  php-process
  php-mbstring
  php-mcrypt
  php-pecl-xdebug
].each do |p|
  package p do
    action :install
    options "--enablerepo=remi,epel --enablerepo=remi-php56"
  end
end

# php 設定
template "php.ini" do
  path "/etc/php.ini"
  source "php.ini.erb"
  mode 0644
end
