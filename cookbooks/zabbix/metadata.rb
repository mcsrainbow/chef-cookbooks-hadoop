maintainer       "ChangLi"
maintainer_email "leechannl@gmail.com"
license          "Apache 2.0"
description      "Installs/Configures zabbix"
long_description IO.read(File.join(File.dirname(__FILE__), 'README.md'))
version          "0.0.1"

recipe "zabbix::agent", "Install zabbix agent"

%w{ apt }.each do |dep|
    depends dep
end

%w{ ubuntu }.each do |os|
    supports os
end
