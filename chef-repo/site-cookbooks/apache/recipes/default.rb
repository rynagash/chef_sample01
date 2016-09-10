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

# template '/usr/local/apache2/conf/app.conf' do
template '/etc/httpd/conf.d/app.conf' do
  # only_if 'ls /usr/local/apache2/conf'
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
    # :use_vhosts      => use_vhosts,
  })

  # notifies :start, 'bash[apachectl start]'  # ←　ここで:start指令を送る
  # notifies :reload, 'service[apache]'
end

# vhosts.each do |key, vhost|
#   template "#{vhost[:path]}" do
#     only_if 'ls /usr/local/apache2/conf/extra'
#     owner 'root'
#     mode 0644
#     source vhost[:source]
#
#     variables ({
#       :listen        => vhost[:listen],
#       :server_admin  => vhost[:server_admin],
#       :server_name   => vhost[:server_name],
#       :document_root => vhost[:document_root],
#       :error_log     => "#{vhost[:log_directory]}#{vhost[:error_log]}",
#       :access_log    => "#{vhost[:log_directory]}#{vhost[:access_log]}"
#     })
#   end
#
#   script 'make_document_root' do
#     not_if "ls #{vhost[:document_root]}"
#     interpreter 'bash'
#     user        'root'
#     code <<-EOL
#       mkdir -p #{vhost[:document_root]}
#     EOL
#   end
#
#   script 'make_log_directory' do
#     not_if "ls #{vhost[:log_directory]}"
#     interpreter 'bash'
#     user        'root'
#     code <<-EOL
#       mkdir -p #{vhost[:log_directory]}
#     EOL
#   end
# end
