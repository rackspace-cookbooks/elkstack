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
