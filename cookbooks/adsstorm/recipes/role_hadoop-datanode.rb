
include_recipe "adsstorm::snippet_hadoop"

if node['hadoop']['cdh_major_version'] == '3'
  package "hadoop-#{node['hadoop']['version']}-datanode"
else
  package "hadoop-hdfs-datanode"
end

node['hadoop']['hdfs_site']['dfs.data.dir'].split(',').each do |dir|

  directory dir do
    mode 0700
    owner "hdfs"
    group "hadoop"
    recursive  true
  end

  directory "#{dir}/lost+found" do
    recursive  true
    owner "hdfs"
    group "hadoop"
  end

end


