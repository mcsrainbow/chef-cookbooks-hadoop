
include_recipe "adsstorm::snippet_cloudera"

if node['hadoop']['cdh_major_version'] == '3'
  package "hadoop-hbase"
else
  package "hbase"
end

if node['hadoop']['cdh_major_version'] == '3'
  package "hadoop-hbase-master"
else
  package "hbase-master"
end

if node['hadoop']['cdh_major_version'] == '3'
  package "hadoop-hbase-thrift"
else
  package "hbase-thrift"
end

service "hadoop-hbase-master" do
  supports [:start,:stop,:restart]
end

service "hadoop-hbase-thrift" do
  supports [:start,:stop,:restart]
end

bash "ensure hbase hdfs dirs" do
  user "root"
  code <<-EOH
    sudo -u hdfs hadoop fs -mkdir /hbase
    sudo -u hdfs hadoop fs -chown hbase /hbase
  EOH
  not_if "sudo -u hdfs hadoop fs -t /hbase"
end

node['hadoop']['hbase_site']['hbase.rootdir'] = "#{node['hadoop']['core_site']['fs.default.name']}/hbase"
node['hadoop']['hbase_site']['hbase.zookeeper.quorum'] = (node['hadoop']['zookeeper']['servers'].map { |x| x.split(':')[0]}).join(',')
hbase_site_vars = { :options => node['hadoop']['hbase_site'] }

template "/etc/hbase/conf/hbase-site.xml" do
  source "hadoop/generic-site.xml.erb"
  mode 0644
  owner "root"
  group "root"
  variables hbase_site_vars
  action :create_if_missing
  notifies :restart, "service[hadoop-hbase-master]",:delayed
  notifies :restart, "service[hadoop-hbase-thrift]",:delayed
end

