apt_repository "redis" do
  uri "http://packages.dotdeb.org"
  distribution "stable"
  components ["all"]
  key "http://www.dotdeb.org/dotdeb.gpg"
  deb_src true
  notifies :run, "execute[apt-get update]", :immediately
end

package "redis-server" do
    action :install
end

service "redis-server" do
  supports [:start,:stop,:restart]
end

directory node['redis']['conf_dir'] do
  owner "root"
  group "root"
  mode 0755
end

directory node['redis']['config']['dir'] do
  owner node['redis']['user']
  group node['redis']['group']
  mode 0755
end

redis_master = search(:node, "chef_environment:#{node.chef_environment} AND recipes:adsstorm\\:\\:role_redis-master").first
node['redis']['config']['slave'] = true
node['redis']['config']['master_ip'] = redis_master['ipaddress']
node['redis']['config']['master_port'] = node['redis']['config']['listen_port']

template "#{node['redis']['conf_dir']}/redis.conf" do
  source "redis.conf.erb"
  owner "root"
  group "root"
  mode 0644
  variables node['redis']['config']
  notifies :restart, "service[redis-server]", :delayed
end
