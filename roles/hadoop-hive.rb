name "hadoop_hive"
description ""
run_list(
    "recipe[adsstorm::role_hadoop-hive]"
)
override_attributes(
 'mysql' => {
  'server_root_password' => "hiveP@ssw0rd",
  'server_repl_password' => "replP@ssw0rd",
  'server_debian_password' => "debianP@ssw0rd",
  'server-id' => 1,
  'tunable' => {
                'log_bin' => '/var/log/mysql/mysql-bin.log',
               },
  'cluster_name' => 'hive' # only use for identify different mysql cluster with setup .
  }
)
