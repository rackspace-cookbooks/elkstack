# Encoding: utf-8
#
# Cookbook Name:: elkstack
# Recipe:: kibana_monitoring
#
# Copyright 2014, Rackspace
#

# Cloud monitoring currently doesn't provide a hook to push in files from git, just from the cookbook.
# Push the file ourselves and configure the monitor.

process_name = 'nginx'

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
template "process-monitor-#{process_name}" do
  cookbook 'elkstack'
  source 'monitoring-process.yaml.erb'
  path "/etc/rackspace-monitoring-agent.conf.d/#{process_name}-monitor.yaml"
  owner 'root'
  group 'root'
  mode '0644'
  variables(
    process_name: process_name
  )
  notifies 'restart', 'service[rackspace-monitoring-agent]', 'delayed'
  action 'create'
end
