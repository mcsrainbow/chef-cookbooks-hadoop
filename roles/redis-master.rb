name "redis_master"
description ""
run_list(
    "recipe[adsstorm::role_redis-master]"
)
