
include_recipe "adsstorm::snippet_hadoop"

if node['hadoop']['cdh_major_version'] == '3'
  package "hadoop-#{node['hadoop']['version']}-tasktracker"
else
  package "hadoop-0.20-mapreduce-tasktracker"
end

node['hadoop']['mapred_site']['mapred.local.dir'].split(',').each do |dir|
  directory dir do
    mode 0755
    owner "mapred"
    group "hadoop"
    recursive true
  end
end

