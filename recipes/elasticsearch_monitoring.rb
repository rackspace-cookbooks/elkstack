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

# drop a custom elasticsearch plugin
remote_file '/usr/lib/rackspace-monitoring-agent/plugins/elasticsearch.py' do
  owner 'root'
  group 'root'
  mode 00755
  source 'https://raw.github.com/racker/rackspace-monitoring-agent-plugins-contrib/master/elasticsearch.py'
end

# setup the custom es monitor
template 'monitor-elasticsearch-clusterhealth' do
  cookbook 'elkstack'
  source 'monitoring-elasticsearch.yaml.erb'
  path '/etc/rackspace-monitoring-agent.conf.d/monitoring-elasticsearch-clusterhealth.yaml'
  owner 'root'
  group 'root'
  mode '0644'
  variables(
    elasticsearch_ip: 'eslocal', # from our /etc/hosts shortcut in _base.rb
    check_type: 'cluster-health',
    expected_value: 'green',
    warning_value: 'yellow',
    disabled: cm['elasticsearch_cluster-health']['disabled'],
    period: cm['elasticsearch_cluster-health']['period'],
    timeout: cm['elasticsearch_cluster-health']['timeout'],
    alarm: cm['elasticsearch_cluster-health']['alarm']
  )
  notifies 'restart', 'service[rackspace-monitoring-agent]', 'delayed'
  action 'create'
end
