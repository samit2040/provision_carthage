#
# Cookbook Name:: demo
# Recipe:: default
#
# Copyright (C) 2017 YOUR_NAME
#
# All rights reserved - Do Not Redistribute
#
include_recipe 'java'
include_recipe 'maven'
include_recipe 'jenkins::master'



git_client 'default' do
  action :install
end

jenkins_plugin 'git' do 
    version '3.4.1'
    notifies :restart, 'service[jenkins]', :immediately
end

#jenkins_command 'safe-restart'