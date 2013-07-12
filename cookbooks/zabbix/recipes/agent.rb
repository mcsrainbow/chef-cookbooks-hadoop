#
# Cookbook Name:: zabbix
# Recipe:: agent
#

package "zabbix-agent"

template "zabbix_agent.conf" do
    path "#{node[:zabbix][:dir]}/zabbix_agent.conf"
    source "zabbix_agent.conf.erb"
    owner "root"
    group "root"
    mode 0644
end

template "zabbix_agentd.conf" do
    path "#{node[:zabbix][:dir]}/zabbix_agentd.conf"
    source "zabbix_agentd.conf.erb"
    owner "root"
    group "root"
    mode 0644
end

service "zabbix-agent" do
    action [:enable, :restart]
end

