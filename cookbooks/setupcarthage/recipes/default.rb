#
# Cookbook Name:: setupcarthage
# Recipe:: default
#
# Copyright (C) 2017 YOUR_NAME
#
# All rights reserved - Do Not Redistribute
#
include_recipe 'java'
#include_recipe 'maven'

node.default['jenkins']['master']['version'] = '2.63'
include_recipe 'jenkins::master'



git_client 'default' do
  action :install
end

jenkins_command 'safe-restart'

#------------------- git plugin dependencies

jenkins_plugin 'git' do 
    version '3.4.1'
    install_deps true
    notifies :restart, 'service[jenkins]', :immediately
end

jenkins_plugin 'structs' do 
    version '1.9'
    action :install
end

jenkins_plugin 'scm-api' do 
    version '2.2.0'
    action :install
end


xml = File.join('Chef::Config[:file_cache_path]','carthage-config.xml')

template xml do
  source 'job-config.xml.erb'
end

jenkins_job 'carthage' do
  config xml
end

=begin
execute 'add maven to Path' do
  command 'export PATH=/usr/local/maven-3.3.9/bin:$PATH'
end
%w{ structs=1.9 scm-api=2.2.0 git=3.4.1 }.each do |addon|
 name, ver = plugin.split('=')
 jenkins_plugin name do
 version ver
 end
end
=end

