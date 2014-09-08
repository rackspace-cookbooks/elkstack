# Encoding: utf-8
#
# Cookbook Name:: elkstack
# Recipe:: logstash_monitoring
#
# Copyright 2014, Rackspace
#

# Cloud monitoring currently doesn't provide a hook to push in files from git, just from the cookbook.
# Push the file ourselves and configure the monitor.

cm = node['elkstack']['cloud_monitoring']
process_name = 'logstash'

# # make sure directory structure exists
# directory '/usr/lib/rackspace-monitoring-agent/plugins' do
#   recursive true
#   action :create
# end
# 
# # drop the file
# remote_file '/usr/lib/rackspace-monitoring-agent/plugins/process_mon.sh' do
#   owner 'root'
#   group 'root'
#   mode 00755
#   source 'https://raw.github.com/racker/rackspace-monitoring-agent-plugins-contrib/master/process_mon.sh'
# end
# 
# # setup the monitors
# template "process-monitor-#{process_name}" do
#   cookbook 'elkstack'
#   source 'monitoring-process.yaml.erb'
#   path "/etc/rackspace-monitoring-agent.conf.d/#{process_name}-monitor.yaml"
#   owner 'root'
#   group 'root'
#   mode '0644'
#   variables(
#     process_name: process_name,
#     disabled: cm["process_#{process_name}"]['disabled'],
#     period: cm["process_#{process_name}"]['period'],
#     timeout: cm["process_#{process_name}"]['timeout'],
#     alarm: cm["process_#{process_name}"]['alarm']
#   )
#   notifies 'restart', 'service[rackspace-monitoring-agent]', 'delayed'
#   action 'create'
# end

# setup the port monitor
port = node['rsyslog']['port']

template "tcp-monitor-#{process_name}-#{port}" do
  cookbook 'elkstack'
  source 'monitoring-tcp.yaml.erb'
  path "/etc/rackspace-monitoring-agent.conf.d/#{process_name}-#{port}-tcp-monitor.yaml"
  owner 'root'
  group 'root'
  mode '0644'
  variables(
    port: port,
    disabled: cm["port_#{port}"]['disabled'],
    period: cm["port_#{port}"]['period'],
    timeout: cm["port_#{port}"]['timeout'],
    alarm: cm["port_#{port}"]['alarm']
  )
  notifies 'restart', 'service[rackspace-monitoring-agent]', 'delayed'
  action 'create'
end
