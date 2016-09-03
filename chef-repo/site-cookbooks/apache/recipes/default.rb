#
# Cookbook Name:: apache
# Recipe:: default
#
# Copyright 2016, YOUR_COMPANY_NAME
#
# All rights reserved - Do Not Redistribute
#
# sourceのインストールディレクトリ
install_dir = '/usr/local/src'

# インストールするソースの情報
source_info = {
  :apr => {
    :file_name  => 'apr-1.5.2.tar.gz',
    :file_dir   => 'apr-1.5.2',
    :configure  => './configure',
    :remote_uri => 'http://ftp.kddilabs.jp/infosystems/apache/apr/apr-1.5.2.tar.gz'
  },
  :apr_util => {
    :file_name  => 'apr-util-1.5.4.tar.gz',
    :file_dir   => 'apr-util-1.5.4',
    :configure  => './configure --with-apr=/usr/local/apr',
    :remote_uri => 'http://ftp.kddilabs.jp/infosystems/apache/apr/apr-util-1.5.4.tar.gz'
  },
  :httpd => {
    :file_name  => 'httpd-2.4.23.tar.gz',
    :file_dir   => 'httpd-2.4.23',
    :configure  => './configure --enable-modules=all --enable-ssl',
    :remote_uri => 'http://ftp.riken.jp/net/apache/httpd/httpd-2.4.23.tar.gz'
  }
}

# # vhosts利用可否
# use_vhosts = true
#
# # 作成するvhostsの情報、複数登録可能
# vhosts = {
#   :sample => {
#     :path          => '/usr/local/apache2/conf/extra/httpd-vhosts-sample.conf',
#     :source        => 'httpd-vhosts-sample.conf.erb',
#     :listen        => 80,
#     :server_admin  => 'localhost@vhosts.com',
#     :server_name   => 'vhosts',
#     :document_root => '/var/www/vhosts',
#     :log_directory => '/var/log/vhosts/',
#     :error_log     => 'error_log',
#     :access_log    => 'access_log common'
#   }
# }

%w(openssl-devel pcre-devel).each do |package_name|
  package "#{package_name}" do
    :install
  end
end

script 'register_httpd_to_service' do
  action :nothing
  only_if 'ls /usr/local/apache2/bin/apachectl'
  interpreter 'bash'
  user        'root'

  code <<-EOL
    cp /usr/local/apache2/bin/apachectl /etc/init.d/httpd
    echo "# chkconfig: 3 65 35" >> /etc/init.d/httpd
    echo "# description: Apache httpd Web server" >> /etc/init.d/httpd
    chkconfig --add httpd
  EOL
end

source_info.each do |key, info|
  remote_file "/tmp/#{info[:file_name]}" do
    source "#{info[:remote_uri]}"
  end

  script 'install_httpd' do
    not_if 'ls /etc/init.d/httpd'
    interpreter 'bash'
    user        'root'

    code <<-EOL
      install -d #{install_dir}
      tar xvfz /tmp/#{info[:file_name]} -C #{install_dir}
      cd #{install_dir}/#{info[:file_dir]} && #{info[:configure]} && make && make install
    EOL

    notifies :run, resources(:script => 'register_httpd_to_service')
  end
end

template '/usr/local/apache2/conf/httpd.conf' do
  only_if 'ls /usr/local/apache2/conf'
  owner 'root'
  mode 0644
  source 'httpd.conf.erb'

  variables ({
    :listen          => 80,
    :user            => 'apache',
    :group           => 'apache',
    :server_admin    => 'localhost@example.com',
    :server_name     => 'localhost',
    # :document_root   => '/usr/local/apache2/htdocs',
    :document_root   => node[:apache][:document_root],
    # :directory_index => 'index.html',
    :directory_index => 'index.php index.html',
    # :use_vhosts      => use_vhosts,
  })
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
