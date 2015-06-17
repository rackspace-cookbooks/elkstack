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

# find central servers and configure appropriately
include_recipe 'elasticsearch::search_discovery' unless Chef::Config[:solo]
elk_nodes = node.deep_fetch('elasticsearch', 'discovery', 'zen', 'ping', 'unicast', 'hosts')
elk_nodes = '' if elk_nodes.nil?

forwarder_servers = []
elk_nodes.split(',').each do |new_node|
  forwarder_servers << "#{new_node}:5960"
end

if node['logstash_forwarder']['config']['network']['servers'].nil? then
  node.set['logstash_forwarder']['config']['network']['servers'] = forwarder_servers 
end

node.set['lumberjack']['ssl key'] = node['logstash_forwarder']['config']['network']['ssl key']
node.set['lumberjack']['ssl certificate'] = node['logstash_forwarder']['config']['network']['ssl certificate']
node.set['lumberjack']['user'] = node['logstash_forwarder']['user']
node.set['lumberjack']['group'] = node['logstash_forwarder']['group']

include_recipe 'elkstack::_lumberjack_secrets'
unless node.run_state['lumberjack_decoded_certificate'].nil? || node.run_state['lumberjack_decoded_certificate'].nil?
  node.set['logstash_forwarder']['config']['network']['ssl certificate'] = '/etc/lumberjack.crt'
  node.set['logstash_forwarder']['config']['network']['ssl key'] = '/etc/lumberjack.key'
  node.set['logstash_forwarder']['config']['network']['ssl ca'] = '/etc/lumberjack.crt'
end

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
end

cookbook_file '/etc/init.d/logstash-forwarder' do
  source 'logstash-forwarder-init'
  owner 'root' # init script must be root, not user/group configured
  group 'root'
  mode 0755
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
