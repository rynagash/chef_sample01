# create user
root_password = node["mysql"]["root_password"]
user_name     = node["mysql"]["user"]["name"]
user_password = node["mysql"]["user"]["password"]
db_name       = node["mysql"]["db_name"]
execute "create_user" do
  command "/usr/bin/mysql -u root -p#{root_password} < #{Chef::Config[:file_cache_path]}/create_user.sql"
  action :nothing
  not_if "/usr/bin/mysql -u #{user_name} -p#{user_password} -D #{db_name}"
end

template "#{Chef::Config[:file_cache_path]}/create_user.sql" do
  owner "root"
  group "root"
  mode 0644
  source "create_user.sql.erb"
  variables({
    :db_name => db_name,
    :username => user_name,
    :password => user_password,
  })
  notifies :run, "execute[create_user]", :immediately
end
