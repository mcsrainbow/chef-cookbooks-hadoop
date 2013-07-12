name "redis_slave"
description ""
run_list(
    "recipe[adsstorm::role_redis-slave]"
)
