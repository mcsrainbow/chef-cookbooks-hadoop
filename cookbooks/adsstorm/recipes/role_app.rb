
include_recipe "python::pip"

# core 
%w{build-essential libmysqlclient-dev python2.6-dev python-mysqldb libxml2-dev libevent-dev python-gevent python-numpy }.each do |pkg|
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

# website data
%w{ python-software-properties python2.6-dev libxml2-dev python-mysqldb ant }.each  do |pkg|
  package pkg
end 

%w{ django thrift==0.8.0 south pil raven simplejson pika==0.9.5 }.each do |pypkg|
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

# websitescheduler
%w{ python-software-properties python2.6-dev libxml2-dev python-mysqldb }.each do |pkg|
  package pkg
end

%w{ django==1.3.0 thrift==0.8.0 raven}.each do |pypkg|
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

%w{ python2.6-dev  python-MySQLdb python-twisted}.each do |pkg|
  package pkg
end

# blackhole
%w{ SQLAlchemy==0.7.6 thrift==0.8.0 importlib==1.0.2 raven pika==0.9.5 simplejson}.each do |pypkg|
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


# synchbase
%w{ python2.6-dev  python-MySQLdb python-twisted} .each do |pkg|
  package pkg
end

%w{ thrift==0.8.0 pika==0.9.5 simplejson raven }.each do |pypkg|
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

# reporting
%w{python-pip python2.6-dev  python-MySQLdb python-twisted} .each do |pkg|
  package pkg
end

%w{ thrift==0.8.0 simplejson raven }.each do |pypkg|
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

# adnotify
%w{ python-dev build-essential}.each do |pkg|
  package pkg
end

%w{thrift==0.8.0 pika==0.9.5 redis apscheduler pymongo==2.2 raven }.each do |pypkg|
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

%w{ python-dev python-MySQLdb build-essential mysql-client}.each do |pkg|
  package pkg
end

%w{ pika==0.9.5 apscheduler pymongo==2.2 SQLAlchemy==0.7.6 simplejson raven}.each do |pypkg|
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
