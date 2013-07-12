
default['hadoop']['version'] = "0.20"
default['hadoop']['release'] = "3u3"

default['hadoop']['conf_dir'] = "/etc/hadoop-#{node['hadoop']['version']}/conf.chef"

default['hadoop']['namenode_port']   = "54310"
default['hadoop']['jobtracker_port'] = "54311"
default['hadoop']['secondarynamenode_port']   = "50090"

default['hadoop']['core_site'] = {
    'fs.default.name' => "hdfs://localhost:#{node['hadoop']['namenode_port']}",
    'hadoop.tmp.dir' => "/tmp/hadoop-hdfs",
}


default['hadoop']['hdfs_site'] = {
    'dfs.name.dir' => '/mnt/data/dfs/nn',
    'dfs.data.dir' => '/mnt/data/dfs/dn',
    'dfs.replication' => 3,
    'dfs.datanode.max.xcievers' => 4096,
    'dfs.namenode.secondary.http-address' => "localhost:#{node['hadoop']['secondarynamenode_port']}",
}

default['hadoop']['mapred_site'] = {
    'mapred.job.tracker' => "localhost:#{node['hadoop']['jobtracker_port']}",
    'mapred.local.dir' => '/mnt/data/mapred/local',
    'mapred.fairscheduler.allocation.file' => "#{node['hadoop']['conf_dir']}/fair-scheduler.xml",
    'mapred.system.dir' => '/mapred/system',
}



default['hadoop']['zookeeper'] = {
    'tickTime' => 2000,
    'initLimit' => 10,
    'syncLimit' => 5,
    'dataDir' => '/var/zookeeper',
    'clientPort' => 2181,
    'servers' => ['127.0.0.1::2888:3888']
}

default['hadoop']['hbase_site'] = {
    'hbase.cluster.distributed' => true,
    'hbase.rootdir' => "#{node['hadoop']['core_site']['fs.default.name']}/hbase",
    'hbase.zookeeper.quorum' => (node['hadoop']['zookeeper']['servers'].map { |x| x.split(':')[0]}).join(','),
    'hbase.client.scanner.caching' => 100,
    'hbase.hregion.memstore.mslab.enabled' => true,
    'hbase.regionserver.handler.count' => 10,
    'hbase.hregion.max.filesize' => 256000000,
    'zookeeper.session.timeout' => 300000,
}


default['hadoop']['hive_site'] = {
  'javax.jdo.option.ConnectionURL' => 'jdbc:mysql://localhost/metastore?createDatabaseIfNotExist=true',
  'javax.jdo.option.ConnectionDriverName' => 'com.mysql.jdbc.Driver',
  'javax.jdo.option.ConnectionUserName' => 'hiveuser',
  'javax.jdo.option.ConnectionPassword' => 'belugaP@ssw0rd',
  'hive.metastore.uris' => 'thrift://localhost:10000',
  'datanucleus.autoCreateSchema' => 'false',
  'datanucleus.fixedDatastore' => 'true',
  'hive.metastore.warehouse.dir' => '/mnt/hive/warehouse',
  'hive.exec.scratchdir' => '/tmp',
  'hive.exec.dynamic.partition' => 'true',
  'hive.hwi.listen.host' => '0.0.0.0',
  'hive.hwi.listen.port' => '9999',
  'hive.hwi.war.file' => 'lib/hive-hwi-0.8.1.war',
  'hive.aux.jars.path' => 'file:///usr/lib/hive/lib/hive-hbase-handler-0.8.1.jar,file:///usr/lib/hbase/hbase-0.90.4-cdh3u3.jar,file:///usr/lib/zookeeper/zookeeper-3.3.4-cdh3u3.jar,file:///usr/lib/hbase/lib/guava-r06.jar'
}

default['hadoop']['flume_site'] = {
    'flume.agent.logdir' => "/var/tmp/flume-${user.name}/agent",
    'flume.agent.logdir.retransmit' => 60000,
    'flume.collector.dfs.dir' => "file:///var/tmp/flume-${user.name}/collected",
    'flume.collector.dfs.compress.codec' => "None",
    'flume.collector.roll.millis' => 30000,
    'flume.collector.output.format' => "raw",
    'flume.master.servers' => "localhost",
    'flume.master.serverid' => 0,
    'flume.master.zk.logdir' => "/var/tmp/flume-${user.name}-zk",
    'flume.master.zk.use.external' => true,
    'flume.master.zk.servers' => (node['hadoop']['zookeeper']['servers'].map { |x| x.split(':')[0]+":2181" }).join(','),
}

default['hadoop']['flume']['delivery'] = {
   'logs' => [
                "/tmp/coin-requests.log",
                "/tmp/cash-requests.log"
             ],
   'ports' => [35850,35851],
   'prefixs' => ["coin-requests","cash-requests"],
   'dfspath' => "#{node['hadoop']['core_site']['fs.default.name'].split(':')[0,2].join(':')}/tracking/logs/raw/%Y/%m/%d/%H%M/",
   'agents' => [],
   'collectors' => [],
  }

default['hadoop']['flume']['tracking'] = {
   'logs' => [
                "/var/app/log/service/cash-clicks.log",
                "/var/app/log/service/coin-clicks.log",
                "/var/app/log/service/cash-impresses.log",
                "/var/app/log/service/coin-impresses.log",
                "/var/app/log/service/cash-installs.log",
                "/var/app/log/service/coin-installs.log"
             ],
   'ports' => [35852, 35853, 35854, 35855, 35856, 35857],
   'prefixs' => ["cash-clicks", "coin-clicks", "cash-impresses", "coin-impresses", "cash-installs", "coin-installs"],
   'dfspath' => "#{node['hadoop']['core_site']['fs.default.name'].split(':')[0,2].join(':')}/tracking/logs/raw/%Y/%m/%d/%H%M/",
   'agents' => [],
   'collectors' => [],
  }




