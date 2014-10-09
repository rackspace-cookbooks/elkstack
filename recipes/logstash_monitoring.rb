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

# in case platformstack not loaded
node.default_unless['platformstack']['cloud_monitoring']['service']['name'] = []

name = "tcp-monitor-#{process_name}-#{port}"
node.default['platformstack']['cloud_monitoring']['service']['name'].push(name)
my_variables = {
  port: port,
  disabled: cm["port_#{port}"]['disabled'],
  period: cm["port_#{port}"]['period'],
  timeout: cm["port_#{port}"]['timeout'],
  alarm: cm["port_#{port}"]['alarm']
}

node.set['platformstack']['cloud_monitoring']['custom_monitors'][name]['source'] = 'monitoring-tcp.yaml.erb'
node.set['platformstack']['cloud_monitoring']['custom_monitors'][name]['cookbook'] = 'elkstack'
node.set['platformstack']['cloud_monitoring']['custom_monitors'][name]['variables'] = my_variables
