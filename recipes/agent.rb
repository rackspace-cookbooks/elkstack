# Encoding: utf-8
#
# Cookbook Name:: elkstack
# Recipe:: agent
#
# Copyright 2014, Rackspace
#

# base stack requirements for an all-in-one node
include_recipe 'elkstack::_base'
agent_name = node['elkstack']['config']['logstash']['agent_name']

logging_enabled = node['elkstack']['config']['agent']['enabled']

# find central servers
include_recipe 'elasticsearch::search_discovery' unless Chef::Config[:solo]
elk_nodes = node.deep_fetch('elasticsearch', 'discovery', 'zen', 'ping', 'unicast', 'hosts')
unless elk_nodes
  Chef::Log.warn('No logstash server nodes were found when configuring agent')
  elk_nodes = nil
end

if elk_nodes && logging_enabled
  Chef::Log.warn('Elasticsearch nodes found and logging was enabled, proceeding with configuring an agent')
else
  Chef::Log.warn("Exiting agent recipe, either elk_nodes: #{elk_nodes} or logging_enabled: #{logging_enabled} was false")
  return
end

# configure logstash for forwarding
logstash_instance agent_name do
  action :create
  only_if { logging_enabled }
end

logstash_service agent_name do
  action :enable
  only_if { logging_enabled }
  retries 2
  retry_delay 5
end

template_variables = {
  output_lumberjack_hosts: elk_nodes.split(','),
  output_lumberjack_port: 5960,
  input_syslog_host: '127.0.0.1',
  input_syslog_port: 5959,
  chef_environment: node.chef_environment
}

# set lumberjack key locations and perms
node.default['lumberjack']['ssl_dir'] = node['logstash']['instance_default']['basedir']
node.default['lumberjack']['ssl_key_path'] = "#{node['lumberjack']['ssl_dir']}/#{node['lumberjack']['ssl key']}"
node.default['lumberjack']['ssl_cert_path'] = "#{node['lumberjack']['ssl_dir']}/#{node['lumberjack']['ssl certificate']}"
node.default['lumberjack']['user'] = node['logstash']['instance_default']['user']
node.default['lumberjack']['group'] = node['logstash']['instance_default']['group']

# preload any lumberjack key or cert that might be available
include_recipe 'elkstack::_lumberjack_secrets'
lumberjack_keypair = node.run_state['lumberjack_decoded_key'] && node.run_state['lumberjack_decoded_certificate']

# default is 'tcp_udp'
if node['elkstack']['config']['agent_protocol'] == 'tcp_udp'
  # TODO: udp and tcp senders
  node.default['elkstack']['config']['logstash']['agent']['my_templates']['output_tcp'] = 'logstash/output_tcp.conf.erb'
  node.default['elkstack']['config']['logstash']['agent']['my_templates']['output_udp'] = 'logstash/output_udp.conf.erb'

  template_variables[:output_tcp_host] = elk_nodes.split(',').first
  template_variables[:output_tcp_port] = 5961
  template_variables[:output_udp_host] = elk_nodes.split(',').first
  template_variables[:output_udp_port] = 5962

# if flag is set *and* key & cert are available
elsif node['elkstack']['config']['agent_protocol'] == 'lumberjack' && lumberjack_keypair
  node.default['elkstack']['config']['logstash']['agent']['my_templates']['output_lumberjack'] = 'logstash/output_lumberjack.conf.erb'
  template_variables['output_lumberjack_ssl_certificate'] = "#{node['logstash']['instance_default']['basedir']}/lumberjack.crt"
  # template_variables['output_lumberjack_ssl_key'] = "#{node['logstash']['instance_default']['basedir']}/lumberjack.key"
end

logstash_pattern agent_name do
  action [:create]
  only_if { logging_enabled }
end

logstash_config agent_name do
  templates_cookbook 'elkstack'
  templates node['elkstack']['config']['logstash']['agent']['my_templates']
  variables(template_variables)
  notifies :restart, "logstash_service[#{agent_name}]", :delayed
  action [:create]
  only_if { logging_enabled }
end

# install additional stacks logstash configuration
node['elkstack']['config']['custom_logstash']['name'].each do |logcfg|
  logcfg_name = node['elkstack']['config']['custom_logstash'][logcfg]['name']
  logcfg_source = node['elkstack']['config']['custom_logstash'][logcfg]['source']
  logcfg_cookbook = node['elkstack']['config']['custom_logstash'][logcfg]['cookbook']
  logcfg_variables = node['elkstack']['config']['custom_logstash'][logcfg]['variables']

  # add one more config for our additional logs
  logstash_custom_config logcfg_name do
    instance_name agent_name
    service_name agent_name
    template_source_file logcfg_source
    template_source_cookbook logcfg_cookbook
    variables(logcfg_variables)
  end
end

# see attributes, will forward to logstash agent on localhost
include_recipe 'rsyslog::client'
