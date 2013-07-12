include_recipe "rabbitmq"
include_recipe "rabbitmq-management"

rabbitmq_vhost "/beluga" do
  action :add
end

%w{adprediction beluga billing notification reporting tracking}.each  do |user|

  rabbitmq_user user do
    password '123456'
    action :add
  end

  rabbitmq_user user do
    vhost "/beluga"
    permissions "\".*\" \".*\" \".*\""
    action :set_permissions
  end

end

