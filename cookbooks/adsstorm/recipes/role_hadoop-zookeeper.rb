
include_recipe "adsstorm::snippet_cloudera"

if node['hadoop']['cdh_major_version'] == '3'
  package "hadoop-zookeeper"
else
  package "zookeeper"
end

if node['hadoop']['cdh_major_version'] == '3'
  package "hadoop-zookeeper-server"
else
  package "zookeeper-server"
end


service "hadoop-zookeeper-server" do
  supports [:start,:stop,:restart]
end


zookeeper_vars = { :options => node['hadoop']['zookeeper'] }

template "/etc/zookeeper/zoo.cfg" do
  source "zookeeper/zoo.cfg.erb"
  mode 0644
  owner "root"
  group "root"
  variables zookeeper_vars
  action :create_if_missing
  notifies :restart, "service[hadoop-zookeeper-server]",:delayed
end

servers = node['hadoop']['zookeeper']['servers'].map { |x| x.split(':')[0]}
server_index = servers.index(node['ipaddress'])

file "#{node['hadoop']['zookeeper']['dataDir']}/myid" do
  mode 0644
  owner "zookeeper"
  group "zookeeper"
  content "#{server_index}"
end



