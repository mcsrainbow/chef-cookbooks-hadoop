
include_recipe "adsstorm::snippet_hadoop"


if node['hadoop']['cdh_major_version'] == '3'
  package "hadoop-#{node['hadoop']['version']}-secondarynamenode"
else
  package "hadoop-hdfs-secondarynamenode"
end
