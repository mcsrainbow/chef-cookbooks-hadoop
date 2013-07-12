#
# Cookbook Name:: adsstorm
# Recipe:: default
#
# Copyright 2012, YOUR_COMPANY_NAME
#
# All rights reserved - Do Not Redistribute
#
#
#
#template  "/etc/resolv.conf" do
  #source "global/resolv.conf.erb"
  #owner "root"
  #group "root"
  #mode 0644
  #variables(
    #"nameservers" => ["10.6.8.52","10.6.255.253","10.6.255.254"],
    #"search" => "cs1cloud.internal",
    #"domain" => "cs1cloud.internal"
  #)
#end
