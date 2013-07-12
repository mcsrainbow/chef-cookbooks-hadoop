# service user & group
default['redis']['conf_dir'] = "/etc/redis"
default['redis']['user'] = "redis"
default['redis']['group'] = "redis"

# configuration
default['redis']['config']['appendonly'] = "no"
default['redis']['config']['appendfsync'] = "everysec"
default['redis']['config']['daemonize'] = "yes"
default['redis']['config']['databases'] = "16"
default['redis']['config']['dbfilename'] = "dump.rdb"
default['redis']['config']['dir'] = "/var/lib/redis"
default['redis']['config']['listen_addr'] = "0.0.0.0"
default['redis']['config']['listen_port'] = "6379"
default['redis']['config']['logfile'] = "stdout"
default['redis']['config']['loglevel'] = "warning"
default['redis']['config']['pidfile'] = "/var/run/redis.pid"
default['redis']['config']['rdbcompression'] = "yes"
default['redis']['config']['timeout'] = "300"
default['redis']['config']['vm']['enabled'] = "no"
default['redis']['config']['vm']['max_memory'] = "0"
default['redis']['config']['vm']['max_threads'] = "4"
default['redis']['config']['vm']['page_size'] = "32"
default['redis']['config']['vm']['pages'] = "134217728"
default['redis']['config']['vm']['vm_swap_file'] = "/var/lib/redis/redis.swap"

###
## the following configuration settings may only work with a recent redis release
###
default['redis']['config']['configure_slowlog'] = false
default['redis']['config']['slowlog_log_slower_than'] = "10000"
default['redis']['config']['slowlog_max_len'] = "1024"
