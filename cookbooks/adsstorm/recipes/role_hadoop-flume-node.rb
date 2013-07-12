
include_recipe "adsstorm::snippet_cloudera"

package "flume"
package "flume-node"


service "flume-node" do
  supports [:start,:stop,:restart]
end

node['hadoop']['flume_site']['flume.master.zk.servers'] = (node['hadoop']['zookeeper']['servers'].map { |x| x.split(':')[0]+":2181"}).join(',')
flume_site_vars = { :options => node['hadoop']['flume_site'] }

template "/etc/flume/conf/flume-site.xml" do
  source "hadoop/generic-site.xml.erb"
  mode 0644
  owner "root"
  group "root"
  variables flume_site_vars
  action :create_if_missing
  notifies :restart, "service[flume-node]",:delayed
end

