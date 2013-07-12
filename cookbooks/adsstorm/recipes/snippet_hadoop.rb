
include_recipe "adsstorm::snippet_cloudera"

# need to set JAVA_HOME for hadoop
template "/etc/profile.d/cloudera-hadoop-java.sh" do
  source "hadoop/profile-java.sh.erb"
  mode 0755
  owner "root"
  group "root"
  action :create
  variables :java_home => node['java']['java_home']
end

chef_conf_dir = node['hadoop']['conf_dir']

directory chef_conf_dir do
  mode 0755
  owner "root"
  group "root"
  recursive true
end

core_site_vars = { :options => node['hadoop']['core_site'] }

template "#{chef_conf_dir}/core-site.xml" do
  source "hadoop/generic-site.xml.erb"
  mode 0644
  owner "root"
  group "hadoop"
  variables core_site_vars
  action :create_if_missing
end

hdfs_site_vars = { :options => node['hadoop']['hdfs_site'] }

template "#{chef_conf_dir}/hdfs-site.xml" do
  source "hadoop/generic-site.xml.erb"
  mode 0644
  owner "root"
  group "hadoop"
  variables hdfs_site_vars
  action :create_if_missing
end

mapred_site_vars = { :options => node['hadoop']['mapred_site'] }

template "#{chef_conf_dir}/mapred-site.xml" do
  source "hadoop/generic-site.xml.erb"
  mode 0644
  owner "root"
  group "hadoop"
  variables mapred_site_vars
  action :create_if_missing
end


template "#{chef_conf_dir}/hadoop-env.sh" do
  source "hadoop/hadoop-env.sh.erb"
  mode 0755
  owner "root"
  group "hadoop"
  variables( :options => node['hadoop']['hadoop_env'] )
end

template node['hadoop']['mapred_site']['mapred.fairscheduler.allocation.file'] do
  source "hadoop/fair-scheduler.xml.erb"
  mode 0644
  owner "root"
  group "hadoop"
  variables node['hadoop']['fair_scheduler']
  action :create_if_missing
end

cookbook_file "#{chef_conf_dir}/log4j.properties" do
  source  "hadoop/log4j-cdh#{node['hadoop']['cdh_major_version']}.properties"
  mode 0644
  owner "root"
  group "hadoop"
  action :create_if_missing
end

template "#{chef_conf_dir}/hadoop-metrics.properties" do
  source "hadoop/generic.properties.erb"
  mode 0644
  owner "root"
  group "hadoop"
  variables( :properties => node['hadoop']['hadoop_metrics'] )
  action :create_if_missing
end

hadoop_tmp_dir = File.dirname(node['hadoop']['core_site']['hadoop.tmp.dir'])

directory hadoop_tmp_dir do
  mode 0777
  owner "root"
  group "root"
  recursive true
end

execute "update hadoop alternatives" do
  if node['hadoop']['cdh_major_version'] == '3'
    alternative_link = "/etc/hadoop-#{node['hadoop']['version']}/conf"
    alternative_name = "hadoop-#{node['hadoop']['version']}-conf"
  else
    alternative_link = "/etc/hadoop/conf"
    alternative_name = "hadoop-conf"
  end
  command "update-alternatives --install #{alternative_link} #{alternative_name} #{chef_conf_dir} 50"
  only_if "update-alternatives --display #{alternative_link} | grep \"'best' version is '#{chef_conf_dir}'\""
end
