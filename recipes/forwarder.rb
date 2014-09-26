# Encoding: utf-8
#
# Cookbook Name:: elkstack
# Recipe:: forwarder
#
# Copyright 2014, Rackspace
#

# base stack requirements for an all-in-one node
include_recipe 'elkstack::_base'
include_recipe 'chef-sugar'

# override logstash values with forwarder ones, ensure directory exists, for _secrets.rb
node.set['logstash']['instance_default']['user'] = node['logstash_forwarder']['user']
node.set['logstash']['instance_default']['group'] = node['logstash_forwarder']['user']
directory node['logstash']['instance_default']['basedir'] do
  user node['logstash']['instance_default']['user']
  group node['logstash']['instance_default']['group']
  mode 0700
end

# find central servers and configure appropriately
include_recipe 'elasticsearch::search_discovery'
elk_nodes = node['elasticsearch']['discovery']['zen']['ping']['unicast']['hosts']
elk_nodes = [] if elk_nodes.nil?

forwarder_servers = []
elk_nodes.split(',').each do |new_node|
  forwarder_servers << "#{new_node}:5960"
end
node.set['logstash_forwarder']['config']['network']['servers'] = forwarder_servers

include_recipe 'elkstack::_secrets'
unless node.run_state['lumberjack_decoded_certificate'].nil? || node.run_state['lumberjack_decoded_certificate'].nil?
  node.set['logstash_forwarder']['config']['network']['ssl certificate'] = "#{node['logstash']['instance_default']['basedir']}/lumberjack.crt"
  node.set['logstash_forwarder']['config']['network']['ssl key'] = "#{node['logstash']['instance_default']['basedir']}/lumberjack.key"
  node.set['logstash_forwarder']['config']['network']['ssl ca'] = "#{node['logstash']['instance_default']['basedir']}/lumberjack.crt"
end

# This next section was heavily inspired and adapted from https://github.com/zeroXten/logstash_forwarder

case node['platform_family']
when 'debian'
  apt_repository 'logstash-forwarder' do
    uri 'http://packages.elasticsearch.org/logstashforwarder/debian'
    components ['stable', 'main']
    key 'http://packages.elasticsearch.org/GPG-KEY-elasticsearch'
  end

  package 'logstash-forwarder'
when 'rhel'
  yum_repository 'logstash-forwarder' do
    description 'logstash forwarder'
    baseurl 'http://packages.elasticsearch.org/logstashforwarder/centos'
    gpgkey 'http://packages.elasticsearch.org/GPG-KEY-elasticsearch'
  end

  package 'logstash-forwarder'

  cookbook_file '/etc/init.d/logstash-forwarder' do
    source 'logstash-forwarder-init-rhel'
    owner 'root' # init script must be root, not user/group configured
    group 'root'
    mode 0755
  end
end

require 'json'
config = node['logstash_forwarder']['config'].to_hash
config['files'] = []
node['logstash_forwarder']['config']['files'].each_pair do |name, value|
  config['files'] << { 'paths' => value['paths'].map { |k, v| k if v }, 'fields' => value['fields'] }
end

file node['logstash_forwarder']['config_file'] do
  owner node['logstash_forwarder']['user']
  group node['logstash_forwarder']['group']
  mode 0644
  content JSON.pretty_generate(config)
  notifies :restart, 'service[logstash-forwarder]'
end

service 'logstash-forwarder' do
  supports status: true, restart: true
  action [:enable, :start]
end
