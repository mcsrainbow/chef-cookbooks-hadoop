

if node['hadoop']['cdh_major_version'] == '3'
  package "hadoop-hive"
  package "hadoop-#{node['hadoop']['version']}-native"
else
  package "hive"
end

if node['hadoop']['cdh_major_version'] == '3'
  package "hadoop-hive-metastore"
else
  package "hive-metastore"
end

if node['hadoop']['cdh_major_version'] == '3'
  package "hadoop-hive-server"
else
  package "hive-server"
end

service "hadoop-hive-server" do
  supports [:start,:stop,:restart]
end

service "hadoop-hive-metastore" do
  supports [:start,:stop,:restart]
end

include_recipe "mysql::server"

hiveuser = node['hadoop']['hive_site']['javax.jdo.option.ConnectionUserName']
hiveuser_pwd = node['hadoop']['hive_site']['javax.jdo.option.ConnectionPassword']

## mysql::master
bash "setup mysql for hive metastore" do
  user "root"
  cwd "/tmp"
  code <<-EOH
    mysql -uroot -p#{node['mysql']['server_root_password']}  -e "CREATE DATABASE IF NOT EXISTS metastore ;"
    mysql -uroot -p#{node['mysql']['server_root_password']}  -e "GRANT ALL ON metastore.* TO '#{hiveuser}'@'%' identified by '#{hiveuser_pwd}'; "
  EOH
  only_if "pgrep 'mysqld$'"
  subscribes :create, resources(:service => "mysql")
end

package "libmysql-java"
execute "copy_connector" do
  command "cp /usr/share/java/mysql-connector-java.jar /usr/lib/hive/lib/mysql-connector-java.jar"
end


hive_site_vars = { :options => node['hadoop']['hive_site'] }

template "/etc/hive/conf/hive-site.xml" do
  source "hadoop/generic-site.xml.erb"
  mode 0644
  owner "root"
  group "root"
  action :create
  variables hive_site_vars
  action :create_if_missing
  notifies :restart, "service[hadoop-hive-server]",:delayed
  notifies :restart, "service[hadoop-hive-metastore]",:delayed
end

