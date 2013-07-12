
include_recipe "adsstorm::snippet_cloudera"

package "flume"
package "flume-master"


service "flume-master" do
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
  notifies :restart, "service[flume-master]",:delayed
end



node['hadoop']['flume'].each do |app,conf| 

  conf['dfspath'] = "#{node['hadoop']['core_site']['fs.default.name'].split(':')[0,2].join(':')}/tracking/logs/raw/%Y/%m/%d/%H%M/"
  commands = []

  conf['logs'].each_with_index do |log,l_index|
    port = conf['ports'][l_index]
    prefix = conf['prefixs'][l_index]

    conf['agents'].each_with_index do |agent,a_index|
      collectors = (conf['collectors'].map { |x| "\"#{x}:#{port}\"" }).join(',')
      commands.push("exec map #{agent} #{app}-agent#{a_index}-log#{l_index}")
      commands.push("exec config #{app}-agent#{a_index}-log#{l_index} 'tail(\"#{log}\",true)' 'agentE2EChain(#{collectors})'")
    end

    conf['collectors'].each_with_index do |clct,c_index|
      commands.push("exec map #{clct} #{app}-clct#{c_index}-log#{l_index}")
      commands.push("exec config #{app}-clct#{c_index}-log#{l_index} 'collectorSource(#{port})' 'collectorSink(\"#{conf['dfspath']}\",\"#{prefix}\")'")
    end

  end

  file "/tmp/flume-shell-commands-#{app}.txt" do
    mode  0644
    owner 'flume'
    group 'flume'
    content commands.join("\n")
  end

  # run it manually
  #execute 'import flume config' do
    #command "flume shell -c localhost -s /tmp/flume-shell-commands-#{app}.txt"
    #only_if do ::File.exists?("/tmp/flume-shell-commands.txt")
  #end

end

