
include_recipe "python::pip"

# core 
%w{build-essential libmysqlclient-dev python2.6-dev libxml2-dev libevent-dev python-mysqldb python-gevent python-numpy }.each do |pkg|
  package pkg
end

%w{ django==1.3 redis setproctitle django-storages boto pika==0.9.5 thrift==0.8.0 }.each do |pypkg|
  pypkgs = pypkg.split("==")
  if pypkgs.length == 2
    python_pip pypkgs[0] do
      version pypkgs[1]
      action :install
    end
  else
    python_pip pypkgs[0] do
      action :install
    end
  end
end

#shared
%w{ build-essential python-pip python2.6-dev autoconf }.each do |pkg|
  package pkg
end

%w{ simplejson thrift==0.8.0 pika==0.9.5}.each do |pypkg|
  pypkgs = pypkg.split("==")
  if pypkgs.length == 2
    python_pip pypkgs[0] do
      version pypkgs[1]
      action :install
    end
  else
    python_pip pypkgs[0] do
      action :install
    end
  end
end

bash "build_zookeeper" do
  user "root"
  cwd "/tmp"
  code <<-EOH
      if [[ ! -e zookeeper-3.4.3.tar.gz ]]; then
        wget http://labs.mop.com/apache-mirror/zookeeper/zookeeper-3.4.3/zookeeper-3.4.3.tar.gz
      fi             
      tar zxf zookeeper-3.4.3.tar.gz
      cd zookeeper-3.4.3/src/c
      ./configure --prefix=/usr/local
      make
      make install
      ldconfig
  EOH
  not_if do ::File.exists?("/usr/local/lib/python2.6/dist-packages/zookeeper.so") end
end

cookbook_file "/usr/local/lib/python2.6/dist-packages/zookeeper.so" do
  source "zookeeper.so"
  owner "root"
  group "staff"
  mode 0755
  not_if do ::File.exists?("/usr/local/lib/python2.6/dist-packages/zookeeper.so") end
end

# website
%w{python-software-properties python2.6-dev python-mysqldb libxml2-dev libjpeg8-dev gettext}.each do |pkg|
  package pkg
end

%w{uwsgi==1.0.4 django==1.3 south PIL raven}.each do |pypkg|
  pypkgs = pypkg.split("==")
  if pypkgs.length == 2
    python_pip pypkgs[0] do
      version pypkgs[1]
      action :install
    end
  else
    python_pip pypkgs[0] do
      action :install
    end
  end
end

# tracking
%w{python2.6-dev s3cmd python-mysqldb}.each do |pkg|
  package pkg
end                                                                                                

%w{django==1.3  uwsgi==1.0.4 pymongo==2.2  setproctitle redis pymysql raven}.each do |pypkg|
  pypkgs = pypkg.split("==")
  if pypkgs.length == 2
    python_pip pypkgs[0] do
      version pypkgs[1]
      action :install
    end
  else
    python_pip pypkgs[0] do
      action :install
    end
  end
end                                           

# addeliver
%w{python2.6-dev libxml2-dev libevent-dev mongodb s3cmd}.each do |pkg|
  package pkg
end                                                             

%w{django==1.3 uwsgi==1.0.4 pymongo==2.2 simplejson raven}.each do |pypkg|
  pypkgs = pypkg.split("==")
  if pypkgs.length == 2
    python_pip pypkgs[0] do
      version pypkgs[1]
      action :install
    end
  else
    python_pip pypkgs[0] do
      action :install
    end
  end
end                                                                          
