# Encoding: utf-8
#
# Cookbook Name:: elkstack
# Recipe:: elasticsearch
#
# Copyright 2014, Rackspace
#

# base stack requirements
include_recipe 'elkstack::_base'

# do clustering magic, with custom query for our tags
include_recipe 'chef-sugar'
should_cluster = node.deep_fetch('elkstack', 'config', 'cluster')
if !should_cluster.nil? && should_cluster
  include_recipe 'elasticsearch::search_discovery'
  node.override['elasticsearch']['network']['host'] = '0.0.0.0'
else
  node.override['elasticsearch']['discovery']['zen']['ping']['multicast']['enabled'] = false
  # if the cluster flag isn't set, turn that junk off
  # ['elasticsearch']['network']['host'] already defaults to localhost
end

# many of the interesting customizations for this were done in attributes
include_recipe 'elasticsearch::default'
include_recipe 'elasticsearch::plugins'

# this must be started for other things like logstash to be startable
service 'elasticsearch' do
  action :start
end

tag('elkstack')
tag('elkstack_cluster') unless should_cluster.nil? || !should_cluster

# Cloud monitoring currently doesn't provide a hook to push in files from git, just from the cookbook.
# Push the file ourselves and configure the monitor.

process_name = 'elasticsearch'

# make sure directory structure exists
directory '/usr/lib/rackspace-monitoring-agent/plugins' do
  recursive true
  action :create
end

# drop the file
remote_file '/usr/lib/rackspace-monitoring-agent/plugins/process_mon.sh' do
  owner 'root'
  group 'root'
  mode 00755
  source 'https://raw.github.com/racker/rackspace-monitoring-agent-plugins-contrib/master/process_mon.sh'
end

# setup the monitor
template "process-monitor-#{process_name}-#{site['server_name']}" do
  cookbook 'elkstack'
  source 'monitoring-process.yaml.erb'
  path "/etc/rackspace-monitoring-agent.conf.d/#{site['server_name']}-#{process_name}-monitor.yaml"
  owner 'root'
  group 'root'
  mode '0644'
  variables(
    server_name: site['server_name'],
    process_name: process_name
  )
  notifies 'restart', 'service[rackspace-monitoring-agent]', 'delayed'
  action 'create'
end
