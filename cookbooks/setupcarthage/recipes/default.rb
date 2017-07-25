#
# Cookbook Name:: setupcarthage
# Recipe:: default
#
# Copyright (C) 2017 Amit Sharma
#
# All rights reserved - Do Not Redistribute
#

include_recipe 'java'
include_recipe 'maven'

mvnVersion = "#{node['maven']['version']}"
execute 'create a symlink' do
  command 'sudo ln -sf /usr/local/maven-'+mvnVersion+'/bin/mvn /usr/bin/mvn'
end

#docker installation
docker_service 'default' do
  action :create
end
execute 'add vagrant user to docker group' do
  command 'sudo usermod -aG docker vagrant'
end

docker_registry 'https://index.docker.io/v1/' do
  username 'samit2040'
  password 'samit2040'
end
docker_service 'default' do
  action :start
end
execute 'docker login' do
  command 'sudo docker  login --username=samit2040 --password=samit2040'
end

#git installation
git_client 'default' do
  action :install
end

# Complete jenkins setup
include_recipe 'jenkins::master'


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
jenkins_ssh_slave 'vagrant-vm' do
  description 'Run Carthage '
  remote_fs   '/home/vagrant'
  labels      ['vagrant-vm','maven','java','docker']

  # SSH specific attributes
  host        'localhost' # or 'slave.example.org'
  user        'vagrant'
  credentials 'vagrant-password'
  launch_timeout   30
  ssh_retries      5
  ssh_wait_retries 60
end
# strting the slave
jenkins_ssh_slave 'vagrant-vm' do
  action :connect
end


# xml = File.join('Chef::Config[:file_cache_path]','carthage-pipeline-config.xml')
pipelineXml = File.join('/var/chef/cache','carthage-pipeline-config.xml')

template pipelineXml do
  source 'job-config-pipeline.xml.erb'
end

jenkins_job 'carthage-pipeline' do
  config pipelineXml
end

freeStyleXml = File.join('/var/chef/cache','carthage-deploy-docker-config.xml')

template freeStyleXml do
  source 'job-config-freeStyle.xml.erb'
end

jenkins_job 'carthage-deploy-docker' do
  config freeStyleXml
end

jenkins_command 'safe-restart'
