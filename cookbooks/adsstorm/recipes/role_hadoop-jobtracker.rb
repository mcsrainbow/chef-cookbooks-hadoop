
include_recipe "adsstorm::snippet_hadoop"


if node['hadoop']['cdh_major_version'] == '3'
  package "hadoop-#{node['hadoop']['version']}-jobtracker"
else
  package "hadoop-0.20-mapreduce-jobtracker"
end

node['hadoop']['mapred_site']['mapred.local.dir'].split(',').each do |dir|
  directory dir do
    mode 0755
    owner "mapred"
    group "hadoop"
    recursive true
  end
end

bash "ensure mapred hdfs dirs" do
  user "root"
  code <<-EOH
    sudo -u hdfs hadoop fs -mkdir #{node['hadoop']['mapred_site']['mapred.system.dir']}
    sudo -u hdfs hadoop fs -chown mapred:hadoop  #{node['hadoop']['mapred_site']['mapred.system.dir']}
  EOH
  not_if "sudo -u hdfs hadoop fs -t #{node['hadoop']['mapred_site']['mapred.system.dir']}"
end
