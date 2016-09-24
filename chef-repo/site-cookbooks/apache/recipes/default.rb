#
# Cookbook Name:: apache
# Recipe:: default
#
# Copyright 2016, YOUR_COMPANY_NAME
#
# All rights reserved - Do Not Redistribute
#
# sourceのインストールディレクトリ
# install_dir = '/usr/local/src'
#

# vhosts利用可否
use_vhosts = node[:apache][:use_vhosts]

%w(openssl-devel pcre-devel).each do |package_name|
  package "#{package_name}" do
    action :install
  end
end

node[:apache][:packages].each do |package_name|
  package "#{package_name}" do
    action [:install, :upgrade]
    options node[:apache][:options]
  end
end

script 'chmod_log_file' do
  only_if 'ls /var/log/httpd/*'
  interpreter 'bash'
  user        'root'
  code <<-EOL
    chmod 755 /var/log/httpd
    chmod 666 /var/log/httpd/*
  EOL
end

# template '/usr/local/apache2/conf/app.conf' do
template '/etc/httpd/conf.d/app.conf' do
  # not_if '/etc/httpd/conf.d/app.conf'
  owner 'root'
  mode 0644
  source 'app.conf.erb'
  path '/etc/httpd/conf.d/app.conf'

  variables ({
    :listen          => node[:apache][:listen],
    :user            => node[:apache][:user],
    :group           => node[:apache][:group],
    :server_admin    => 'localhost@example.com',
    :server_name     => 'localhost',
    :document_root   => node[:apache][:document_root],
    :directory_index => 'index.php index.html',
    :use_vhosts      => use_vhosts,
  })
end

# 作成するvhostsの情報、複数登録可能
vhosts = {
  :test => {
    :path          => '/etc/httpd/conf.d/app-vhosts-test.conf',
    :source        => 'app-vhosts-test.conf.erb',
    :listen        => 8080,
    :server_admin  => 'localhost@vhosts.com',
    :server_name   => 'localhost',
    :document_root => node[:apache][:vhosts][:test][:document_root],
    :log_directory => node[:apache][:vhosts][:test][:log_directory],
    :error_log     => 'error_log',
    :access_log    => 'access_log'
  }
}

vhosts.each do |key, vhost|
  template "#{vhost[:path]}" do
    only_if 'ls /etc/httpd/conf.d'
    owner 'root'
    mode 0644
    source vhost[:source]

    variables ({
      :listen        => vhost[:listen],
      :server_admin  => vhost[:server_admin],
      :server_name   => vhost[:server_name],
      :document_root => vhost[:document_root],
      :error_log     => "#{vhost[:log_directory]}#{vhost[:error_log]}",
      :access_log    => "#{vhost[:log_directory]}#{vhost[:access_log]} common"
    })
  end

  script 'make_document_root' do
    not_if "ls #{vhost[:document_root]}"
    interpreter 'bash'
    user        'root'
    code <<-EOL
      mkdir -p #{vhost[:document_root]}
    EOL
  end

  script 'make_log_directory' do
    not_if "ls #{vhost[:log_directory]}"
    interpreter 'bash'
    user        'root'
    code <<-EOL
      mkdir -p #{vhost[:log_directory]}
      chmod 755 #{vhost[:log_directory]}
    EOL
  end

  script 'chmod_log_file_' + key.to_s do
    interpreter 'bash'
    user        'root'
    code <<-EOL
      touch      #{vhost[:log_directory]}#{vhost[:error_log]} #{vhost[:log_directory]}#{vhost[:access_log]}
      chmod 666  #{vhost[:log_directory]}#{vhost[:error_log]} #{vhost[:log_directory]}#{vhost[:access_log]}
    EOL
  end
end
