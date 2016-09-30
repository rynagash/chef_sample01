#
# Cookbook Name:: php
# Recipe:: default
#
# Copyright 2016, YOUR_COMPANY_NAME
#
# All rights reserved - Do Not Redistribute
#

bash "install phalcon" do
  not_if 'ls /usr/lib64/php/modules/phalcon.so'
  user "root"
  code <<-EOH
    cd /tmp
    git clone --depth=1 https://github.com/phalcon/cphalcon.git
    cd cphalcon/build
    ./install
    cd php5/64bits
    ./configure --with-php-config=/usr/bin/php-config
    make
    make install
  EOH
end

# php 設定
template "phalcon.ini" do
  path "/etc/php.d/phalcon.ini"
  source "phalcon.ini.erb"
  mode 0644
end
