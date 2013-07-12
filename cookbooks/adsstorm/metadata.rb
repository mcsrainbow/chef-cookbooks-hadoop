maintainer       "YOUR_COMPANY_NAME"
maintainer_email "YOUR_EMAIL"
license          "All rights reserved"
description      "Installs/Configures adsstorm"
long_description IO.read(File.join(File.dirname(__FILE__), 'README.md'))
version          "0.0.1"

%w{chef-client apt build-essential ntp openssh timezone user zabbix sudo nginx logrotate python mongodb cloudera mysql rabbitmq rabbitmq-management}.each do |cb|
  depends cb
end
