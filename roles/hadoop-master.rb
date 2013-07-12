name "hadoop_master"
description ""
run_list(
    "recipe[adsstorm::role_hadoop-namenode]",
    "recipe[adsstorm::role_hadoop-jobtracker]",
    "recipe[adsstorm::role_hadoop-zookeeper]",
    "recipe[adsstorm::role_hadoop-hbase-master]"
)
override_attributes(
  'hadoop' => {
    'core_site' => {
     'fs.default.name' => 'hdfs://hadoop-server:54310', 
    },
    'hdfs_site' => {
      'dfs.namenode.secondary.http-address' => '10.1.4.71:50090'
    },
    'mapred_site' => {
      'mapred.job.tracker' => 'hadoop-server:54311'
    },
    'zookeeper' =>{
      'servers' => ['10.1.4.69:2888:3888',
                    '10.1.4.71:2888:3888',
                    '10.1.4.66:2888:3888',
                    '10.1.4.67:2888:3888',
                    '10.1.4.68:2888:3888',
                   ]
    }
  }
)
