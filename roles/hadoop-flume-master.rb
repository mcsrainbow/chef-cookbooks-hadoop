name "hadoop_flume_master"
description ""
run_list(
    "recipe[adsstorm::role_hadoop-flume-master]"
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
    },
    'flume' => {
      'delivery' => {
      # must use hostname  ,flume report to master use hostname as logicnode , i manually add it to master's /etc/hosts file 
       #'agents' => ['10.1.4.59','10.1.4.60'],
       #'collectors' => ['10.1.4.67','10.1.4.68'],
       'agents' => ['application-server01','application-server02'],
       'collectors' => ['hadoop-server02','hadoop-server03'],
      },
      'tracking' => {
      # must use hostname
       #'agents' => ['10.1.4.59','10.1.4.60'],
       #'collectors' => ['10.1.4.67','10.1.4.68'],
       'agents' => ['application-server01','application-server02'],
       'collectors' => ['hadoop-server02','hadoop-server03'],
      }
    }

  }
)
