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

cloud_monitoring_enabled = node.deep_fetch('elkstack', 'config', 'cloud_monitoring', 'enabled')

include_recipe 'chef-sugar'
rackspace_monitoring_service 'default' do
  cloud_credentials_username node.deep_fetch('rackspace', 'cloud_credentials', 'username')
  cloud_credentials_api_key node.deep_fetch('rackspace', 'cloud_credentials', 'api_key')
  action [:create, :start]
  only_if { cloud_monitoring_enabled }
end

# setup the port monitor
port = node['rsyslog']['port']

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
logstash_service = cm['logstash']
action = logstash_service['disabled'] ? 'disable' : 'create'
rackspace_monitoring_check 'logstash_service' do
  type 'agent.plugin'
  agent_filename 'logstash_service'
  plugin_url logstash_service['file_url']
  plugin_args logstash_service['details']['args']
  plugin_filename logstash_service['details']['file']
  label logstash_service['label']
  period logstash_service['period']
  timeout logstash_service['timeout']
  cookbook logstash_service['cookbook']
  alarm logstash_service['alarm']
  alarm_criteria logstash_service['alarm_criteria']
  action action
  only_if { cloud_monitoring_enabled }
end
