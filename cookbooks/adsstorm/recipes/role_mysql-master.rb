include_recipe "mysql::server"

require 'mysql'

## mysql::master
ruby_block "store_mysql_master_status" do
  block do
    node.set['mysql']['master'] = true
    m = Mysql.new("localhost", "root", node['mysql']['server_root_password'])
    m.query("grant replication slave on *.* to 'repl'@'%' identified by '#{node['mysql']['server_repl_password']}'")
    m.query("show master status") do |row|
      row.each_hash do |h|
        node.set["mysql"]["master_file"] = h['File']
        node.set["mysql"]["master_position"] = h['Position']
      end
    end
    Chef::Log.info "Storing database master replication status: #{node["mysql"]["master_file"]} #{node["mysql"]["master_position"]}"
    node.save
  end
  # only execute if mysql is running
  only_if "pgrep 'mysqld$'"
  # subscribe to mysql service to catch restarts
  subscribes :create, resources(:service => "mysql")
end
