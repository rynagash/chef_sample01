# secure install
root_password = node["mysql"]["root_password"]
execute "secure_install" do
  command "/usr/bin/mysql -u root < #{Chef::Config[:file_cache_path]}/secure_install.sql"
  action :nothing
  only_if "/usr/bin/mysql -u root -e 'show databases;'"
end

template "#{Chef::Config[:file_cache_path]}/secure_install.sql" do
  owner "root"
  group "root"
  mode 0644
  source "secure_install.sql.erb"
  variables({
    :root_password => root_password,
  })
  notifies :run, "execute[secure_install]", :immediately
end
