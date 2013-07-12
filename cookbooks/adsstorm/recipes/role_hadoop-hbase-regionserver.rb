
include_recipe "adsstorm::snippet_cloudera"

if node['hadoop']['cdh_major_version'] == '3'
  package "hadoop-hbase"
else
  package "hbase"
end

if node['hadoop']['cdh_major_version'] == '3'
  package "hadoop-hbase-regionserver"
else
  package "hbase-regionserver"
end

service "hadoop-hbase-regionserver" do
  supports [:start,:stop,:restart]
end


hbase_site_vars = { :options => node['hadoop']['hbase_site'] }
node['hadoop']['hbase_site']['hbase.rootdir'] = "#{node['hadoop']['core_site']['fs.default.name']}/hbase"
node['hadoop']['hbase_site']['hbase.zookeeper.quorum'] = (node['hadoop']['zookeeper']['servers'].map { |x| x.split(':')[0]}).join(',')

template "/etc/hbase/conf/hbase-site.xml" do
  source "hadoop/generic-site.xml.erb"
  mode 0644
  owner "root"
  group "root"
  variables hbase_site_vars
  action :create_if_missing
  notifies :restart, "service[hadoop-hbase-regionserver]",:delayed
end

