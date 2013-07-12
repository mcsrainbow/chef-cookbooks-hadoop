
include_recipe "adsstorm::snippet_hadoop"

if node['hadoop']['cdh_major_version'] == '3'
  package "hadoop-#{node['hadoop']['version']}-namenode"
else
  package "hadoop-hdfs-namenode"
end

node['hadoop']['hdfs_site']['dfs.name.dir'].split(',').each do |dir|
  directory dir do
    mode 0700
    owner "hdfs"
    group "hadoop"
    recursive true
  end
end

#bash "ensure format namenode" do
  #user "root"
  #code <<-EOH
     #echo "Y" | sudo -u hdfs hadoop namenode -format
  #EOH
  #not_if "sudo -u hdfs hadoop fs -t #{node['hdfs_site']['dfs.name.dir']['mapred.system.dir']}"
#end

#$ sudo -u hdfs hadoop namenode -format
#You'll get a confirmation prompt; for example:
#Re-format filesystem in /data/namedir ? (Y or N)

