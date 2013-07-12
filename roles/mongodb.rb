name "mongodb"
description ""
run_list(
  "recipe[adsstorm::role_mongodb]"
)
override_attributes(
  :mongodb =>{
    :cluster_name => 'addeliver'
  }
)
