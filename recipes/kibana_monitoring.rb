# Encoding: utf-8
#
# Cookbook Name:: elkstack
# Recipe:: kibana_monitoring
#
# Copyright 2014, Rackspace
#

# Cloud monitoring currently doesn't provide a hook to push in files from git, just from the cookbook.
# Push the file ourselves and configure the monitor.

cm = node['elkstack']['cloud_monitoring']
process_name = 'nginx'

# setup the port monitors
# create a 'ports' list to iterate through for dropping monitoring files.
# these ports are currently hardcoded for kibana.
ports = ['80', '443']

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
      port: port,
      disabled: cm["port_#{port}"]['disabled'],
      period: cm["port_#{port}"]['period'],
      timeout: cm["port_#{port}"]['timeout'],
      alarm: cm["port_#{port}"]['alarm']
    )
    notifies 'restart', 'service[rackspace-monitoring-agent]', 'delayed'
    action 'create'
  end
end
