
cdh_version = node['hadoop']['release']
os_dist = node['lsb']['id'].downcase
os_version = node['lsb']['codename']
os_arch = node['kernel']['machine']
os_arch = 'amd64' if os_arch == 'x86_64'

node['hadoop']['cdh_major_version'] = node['hadoop']['release'][0..0]


if cdh_version[0..0] == '3'
  # deb http://archive.cloudera.com/debian <RELEASE>-cdh3 contrib
  apt_repo_uri = "http://archive.cloudera.com/debian"
  apt_dist = "#{os_version}-cdh#{cdh_version}"
  apt_key = "http://archive.cloudera.com/debian/archive.key"
else
  # deb [arch=amd64] http://archive.cloudera.com/cdh4/<OS-release-arch> <RELEASE>-cdh4 contrib
  apt_repo_uri ="[arch=amd64] http://archive.cloudera.com/cdh4/#{os_dist}/#{os_version}/#{os_arch}/cdh"
  apt_dist = "#{os_version}-cdh4"
  apt_key = "http://archive.cloudera.com/cdh4/#{os_dist}/#{os_version}/#{os_arch}/cdh/archive.key"
end

apt_repository "cloudera-cdh#{cdh_version}" do
  uri apt_repo_uri
  distribution apt_dist
  components [ "contrib" ]
  key apt_key
  deb_src true
end

# we're forcing apt-get update manually for now, due to http://tickets.opscode.com/browse/COOK-1385
execute "apt-get update" do
  user    "root"
  group   "root"
  command "apt-get update"
  ignore_failure true
end

if node['hadoop']['cdh_major_version'] == '3'
  package "hadoop-#{node['hadoop']['version']}"
  package "hadoop-#{node['hadoop']['version']}-native"
else
  package "hadoop"
  package "hadoop-hdfs"
end

package "nscd"

service "nscd" do
  action [ :start, :enable ]
end
