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

include_recipe 'chef-sugar'

cloud_monitoring_enabled = node.deep_fetch('elkstack', 'config', 'cloud_monitoring', 'enabled')

rackspace_monitoring_service 'default' do
  cloud_credentials_username node.deep_fetch('rackspace', 'cloud_credentials', 'username')
  cloud_credentials_api_key node.deep_fetch('rackspace', 'cloud_credentials', 'api_key')
  action [:create, :start]
  only_if { cloud_monitoring_enabled }
end

# setup the port monitors
# create a 'ports' list to iterate through for dropping monitoring files.
# these ports are currently hardcoded for kibana.
ports = ['80', '443']

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
nginx_service = cm['nginx']
action = nginx_service['disabled'] ? 'disable' : 'create'
rackspace_monitoring_check 'nginx_service' do
  type 'agent.plugin'
  agent_filename 'nginx_service'
  plugin_url nginx_service['file_url']
  plugin_args nginx_service['details']['args']
  plugin_filename nginx_service['details']['file']
  label nginx_service['label']
  period nginx_service['period']
  timeout nginx_service['timeout']
  cookbook nginx_service['cookbook']
  alarm nginx_service['alarm']
  alarm_criteria nginx_service['alarm_criteria']
  action action
  only_if { cloud_monitoring_enabled }
end
