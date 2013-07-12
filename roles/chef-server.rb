name "chef_server"
description ""
run_list(
  "recipe[adsstorm::role_chef-server]"
)

override_attributes(
    "authorization" => {
      "sudo" => {
        "groups" => ["admin"],
        "passwordless" => true,
        "users" => ["zabbix"]
      }
    },

    "users" => [ "dongguo"],
    "openssh" => {
        "PasswordAuthentication" => "no"
    },
    :zabbix => {
        :server_addr => "10.1.4.56"
    },
    "chef_client" =>{
      "server_url"  =>  "10.1.4.55"
    }
)
