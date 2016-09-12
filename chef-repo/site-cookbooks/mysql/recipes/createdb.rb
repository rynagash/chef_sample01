# create database
root_password = node["mysql"]["root_password"]
db_name       = node["mysql"]["db_name"]
execute "create_db" do
  command "/usr/bin/mysql -u root -p#{root_password} < #{Chef::Config[:file_cache_path]}/create_db.sql"
  action :nothing
  not_if "/usr/bin/mysql -u root -p#{root_password} -D #{db_name}"
end

template "#{Chef::Config[:file_cache_path]}/create_db.sql" do
  owner "root"
  group "root"
  mode 0644
  source "create_db.sql.erb"
  variables({
    :db_name => db_name,
  })
  notifies :run, "execute[create_db]", :immediately
end
