# Encoding: utf-8
#
# Cookbook Name:: elkstack
# Recipe:: elasticsearch_monitoring
#
# Copyright 2014, Rackspace
#

include_recipe 'chef-sugar'
include_recipe 'elkstack::newrelic'

cloud_monitoring_enabled = node.deep_fetch('elkstack', 'config', 'cloud_monitoring', 'enabled')

rackspace_monitoring_service 'default' do
  cloud_credentials_username node.deep_fetch('rackspace', 'cloud_credentials', 'username')
  cloud_credentials_api_key node.deep_fetch('rackspace', 'cloud_credentials', 'api_key')
  action [:create, :start]
  only_if { cloud_monitoring_enabled }
end

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
if cloud_monitoring_enabled
  ports.each do |port|
    name = "tcp-#{process_name}-#{port}"
    action = cm["port_#{port}"]['disabled'] ? 'disable' : 'enable'
    rackspace_monitoring_check name do
      type 'remote.tcp'
      agent_filename name
      cookbook 'elkstack'
      template 'monitoring-tcp.yaml.erb'
      alarm cm["port_#{port}"]['alarm']
      timeout cm["port_#{port}"]['timeout']
      period cm["port_#{port}"]['period']
      variables 'port' => port
      action action
      only_if { cloud_monitoring_enabled }
    end
  end
end

# monitor elaticsearch service
es_health = cm['elasticsearch_health']
action = es_health['disabled'] ? 'disable' : 'create'
rackspace_monitoring_check 'elasticsearch' do
  type 'agent.plugin'
  agent_filename 'elasticsearch'
  plugin_url es_health['file_url']
  plugin_args es_health['details']['args']
  plugin_filename es_health['details']['file']
  label es_health['label']
  period es_health['period']
  timeout es_health['timeout']
  cookbook es_health['cookbook']
  alarm es_health['alarm']
  alarm_criteria es_health['alarm_criteria']
  action action
  only_if { cloud_monitoring_enabled }
end
es_service = cm['elasticsearch']
action = es_service['disabled'] ? 'disable' : 'create'
rackspace_monitoring_check 'elasticsearch_service' do
  type 'agent.plugin'
  agent_filename 'elasticsearch_service'
  plugin_url es_service['file_url']
  plugin_args es_service['details']['args']
  plugin_filename es_service['details']['file']
  label es_service['label']
  period es_service['period']
  timeout es_service['timeout']
  cookbook es_service['cookbook']
  alarm es_service['alarm']
  alarm_criteria es_service['alarm_criteria']
  action action
  only_if { cloud_monitoring_enabled }
end
