name "hadoop_flume_agent"
description ""
run_list(
    "recipe[adsstorm::role_hadoop-flume-node]"
)
override_attributes(
  'hadoop' => {
    'zookeeper' =>{
      'servers' => ['10.1.4.69:2888:3888',
                    '10.1.4.71:2888:3888',
                    '10.1.4.66:2888:3888',
                    '10.1.4.67:2888:3888',
                    '10.1.4.68:2888:3888',
                   ]
    },
    'flume_site' => {
      'flume.master.servers' => '10.1.4.66'
    }
  }
)
