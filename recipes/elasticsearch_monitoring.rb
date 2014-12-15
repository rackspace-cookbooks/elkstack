# Encoding: utf-8
#
# Cookbook Name:: elkstack
# Recipe:: elasticsearch_monitoring
#
# Copyright 2014, Rackspace
#

include_recipe 'elkstack::newrelic'

# Cloud monitoring currently doesn't provide a hook to push in files from git, just from the cookbook.
# Push the file ourselves and configure the monitor.

cm = node['elkstack']['cloud_monitoring']
process_name = 'elasticsearch'

# create a 'ports' list to iterate through for dropping monitoring files.
ports = []
# default elasticsearch transport port is 9300. If not set, use the default.
es_transport_port = node.deep_fetch('elasticsearch', 'transport', 'tcp', 'port')
ports.push(es_transport_port.nil? ? 9300 : es_transport_port)
# default elasticsearch http port is 9200. If not set, use the default.
es_http_port = node.deep_fetch('elasticsearch', 'http', 'port')
ports.push(es_http_port.nil? ? 9200 : es_http_port)

# in case platformstack not loaded
node.default_unless['platformstack']['cloud_monitoring']['service']['name'] = []

# iterate through 'ports' to create a monitoring file for each port.
ports.each do | port |
  name = "tcp-#{process_name}-#{port}"
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
end
