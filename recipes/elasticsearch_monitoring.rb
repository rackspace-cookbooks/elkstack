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

# setup the monitors
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

# create a 'ports' list to iterate through for dropping monitoring files.
ports = []
# default elasticsearch transport port is 9300. If not set, use the default.
es_transport_port = node.deep_fetch('elasticsearch', 'transport', 'tcp', 'port')
ports.push(es_transport_port.nil? ? 9300 : es_transport_port)
# default elasticsearch http port is 9200. If not set, use the default.
es_http_port = node.deep_fetch('elasticsearch', 'http', 'port')
ports.push(es_http_port.nil? ? 9200 : es_http_port)

# iterate through 'ports' to create a monitoring file for each port.
ports.each do | port |
  template "tcp-monitor-#{process_name}-#{port}" do
    cookbook 'elkstack'
    source 'monitoring-tcp.yaml.erb'
    path "/etc/rackspace-monitoring-agent.conf.d/#{process_name}-#{port}-tcp-monitor.yaml"
    owner 'root'
    group 'root'
    mode '0644'
    variables(
      port: port
    )
    notifies 'restart', 'service[rackspace-monitoring-agent]', 'delayed'
    action 'create'
  end
end
