name "mysql_slave"
description ""
run_list(
    "recipe[adsstorm::role_mysql-slave]"
)
override_attributes(
 'mysql' => {
  'server_root_password' => "belugaP@ssw0rd",
  'server_repl_password' => "replP@ssw0rd",
  'server_debian_password' => "debianP@ssw0rd",
  'server-id' => 2,
  'cluster_name' => 'beluga' # only use for identify different mysql cluster with setup .
  }
)
