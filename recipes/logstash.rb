# Encoding: utf-8
#
# Recipe:: logstash
# Cookbook Name:: elkstack
#
# Copyright 2014, Rackspace
#

# base stack requirements
include_recipe 'elkstack::_server'

instance_name = node['elkstack']['config']['logstash']['instance_name']
logstash_instance instance_name do
  action 'create'
end

# for some reason, this also internally does :start, :immediate
include_recipe 'runit'
logstash_service instance_name do
  action :enable
end

directory node['logstash']['instance_default']['basedir'] do
  owner node['logstash']['instance_default']['user']
  group node['logstash']['instance_default']['group']
  mode '0755'
end

template_variables = {
  input_lumberjack_host: '0.0.0.0',
  input_lumberjack_port: 5960,
  input_syslog_host: '0.0.0.0',
  input_syslog_port: 5959,
  input_tcp_host: '0.0.0.0',
  input_tcp_port: 5961,
  input_udp_host: '0.0.0.0',
  input_udp_port: 5962,
  chef_environment: node.chef_environment
}

# set lumberjack key locations and perms
node.default['lumberjack']['ssl_dir'] = node['logstash']['instance_default']['basedir']
node.default['lumberjack']['ssl_key_path'] = "#{node['lumberjack']['ssl_dir']}/#{node['lumberjack']['ssl key']}"
node.default['lumberjack']['ssl_cert_path'] = "#{node['lumberjack']['ssl_dir']}/#{node['lumberjack']['ssl certificate']}"
node.default['lumberjack']['user'] = node['logstash']['instance_default']['user']
node.default['lumberjack']['group'] = node['logstash']['instance_default']['group']

# also receive lumberjack if a keypair is available
include_recipe 'elkstack::_lumberjack_secrets'
unless node.run_state['lumberjack_decoded_certificate'].nil? || node.run_state['lumberjack_decoded_certificate'].nil?\
 || node['elkstack']['config']['agent_protocol'] != 'lumberjack'
  node.default['elkstack']['config']['logstash']['server']['my_templates']['input_lumberjack'] = 'logstash/input_lumberjack.conf.erb'
  template_variables['input_lumberjack_ssl_certificate'] = node['lumberjack']['ssl_cert_path']
  template_variables['input_lumberjack_ssl_key'] = node['lumberjack']['ssl_key_path']
end

logstash_config instance_name do
  action 'create'
  templates_cookbook 'elkstack'
  templates node['elkstack']['config']['logstash']['server']['my_templates']
  variables(template_variables)
  notifies :restart, "logstash_service[#{instance_name}]", :delayed
end

# install additional stacks logstash configuration
node['elkstack']['config']['custom_logstash']['name'].each do |logcfg|
  logcfg_name = node['elkstack']['config']['custom_logstash'][logcfg]['name']
  logcfg_source = node['elkstack']['config']['custom_logstash'][logcfg]['source']
  logcfg_cookbook = node['elkstack']['config']['custom_logstash'][logcfg]['cookbook']
  logcfg_variables = node['elkstack']['config']['custom_logstash'][logcfg]['variables']

  # add one more config for our additional logs
  logstash_custom_config logcfg_name do
    instance_name instance_name # don't let the definition assume the default instance name in case it has been overriden in a wrapper
    service_name instance_name
    template_source_file logcfg_source
    template_source_cookbook logcfg_cookbook
    variables(logcfg_variables)
  end
end

include_recipe 'elkstack::logstash_monitoring'
