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

# switch for platformstack
enable_attr = node.deep_fetch('platformstack', 'elkstack_logging', 'enabled')
logging_enabled = !enable_attr.nil? && enable_attr # ensure this is binary logic, not nil
unless logging_enabled
  Chef::Log.warn('Logging with logstash using ELK stack was explicitly enabled')
end

if enable_attr.nil?
  Chef::Log.warn('Logging with logstash using ELK stack was implicitly enabled since platformstack is not on the runlist')
  logging_enabled = enable_attr.nil?
end

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
end

my_templates = {
  'input_syslog'         => 'logstash/input_syslog.conf.erb',
  'output_stdout'        => 'logstash/output_stdout.conf.erb'
}

template_variables = {
  output_lumberjack_hosts: elk_nodes.split(','),
  output_lumberjack_port: 5960,
  input_syslog_host: '127.0.0.1',
  input_syslog_port: 5959,
  chef_environment: node.chef_environment
}

include_recipe 'elkstack::_secrets'
unless node.run_state['lumberjack_decoded_certificate'].nil? || node.run_state['lumberjack_decoded_certificate'].nil?
  my_templates['output_lumberjack'] = 'logstash/output_lumberjack.conf.erb'
  template_variables['output_lumberjack_ssl_certificate'] = "#{node['logstash']['instance_default']['basedir']}/lumberjack.crt"
  # template_variables['output_lumberjack_ssl_key'] = "#{node['logstash']['instance_default']['basedir']}/lumberjack.key"
end

logstash_pattern agent_name do
  action [:create]
  only_if { logging_enabled }
end

logstash_config agent_name do
  templates_cookbook 'elkstack'
  templates my_templates
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
