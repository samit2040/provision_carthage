#
# Cookbook Name:: setupcarthage
# Recipe:: default
#
# Copyright (C) 2017 YOUR_NAME
#
# All rights reserved - Do Not Redistribute
#

include_recipe 'java'
# include_recipe 'maven'

#node.default['jenkins']['master']['version'] = '2.63'
include_recipe 'jenkins::master'

package 'maven' 


# out this at the end credentials=2.1.2 ssh-credentials=1.6.1 ssh-slaves=1.20 bouncycastle-api=2.16.1 structs=1.9 ssh-credentials=1.6.1 credentials=2.1.10 
node['jenkins']['plugins'].each do |plugin|
 name, ver = plugin.split('=')
 jenkins_plugin name do
  version ver
  install_deps false
  # notifies :restart, 'service[jenkins]', :immediately
 end
end
execute 'restart the jenkins' do
  command 'sudo service jenkins restart'
end

# Create password credentials
jenkins_password_credentials 'vagrant' do
  id          'vagrant-password'
  description 'Vagrant user name and pwd'
  password    'vagrant'
end

# Create a slave launched via SSH
jenkins_ssh_slave 'slave1' do
  description 'Run Carthage '
  remote_fs   '/home/vagrant'
  labels      ['vagrant-vm']

  # SSH specific attributes
  host        'localhost' # or 'slave.example.org'
  user        'vagrant'
  credentials 'vagrant-password'
  launch_timeout   30
  ssh_retries      5
  ssh_wait_retries 60
end
# strting the slave
jenkins_ssh_slave 'slave1' do
  action :connect
end

docker_service 'default' do
  action :create
end
execute 'add vagrant user to docker group' do
  command 'sudo usermod -aG docker vagrant'
end
docker_service 'default' do
  action :start
end


git_client 'default' do
  action :install
end

=begin
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
=end

# xml = File.join('Chef::Config[:file_cache_path]','carthage-config.xml')
xml = File.join('/var/chef/cache','carthage-config.xml')

template xml do
  source 'job-config.xml.erb'
end

jenkins_job 'carthage' do
  config xml
end

=begin

%w{ structs=1.9 scm-api=2.2.0 git=3.4.1 }.each do |addon|
 name, ver = plugin.split('=')
 jenkins_plugin name do
 version ver
 end
end
=end

