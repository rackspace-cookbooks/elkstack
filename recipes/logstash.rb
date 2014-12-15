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
logstash_service instance_name do
  action :enable
end

directory node['logstash']['instance_default']['basedir'] do
  owner node['logstash']['instance_default']['user']
  group node['logstash']['instance_default']['group']
  mode '0755'
end

# by default, these are the inputs and outputs on the server
my_templates = {
  'input_syslog'         => 'logstash/input_syslog.conf.erb',
  'output_stdout'        => 'logstash/output_stdout.conf.erb',
  'output_elasticsearch' => 'logstash/output_elasticsearch.conf.erb'
}

template_variables = {
  input_lumberjack_host: '0.0.0.0',
  input_lumberjack_port: 5960,
  input_syslog_host: '0.0.0.0',
  input_syslog_port: 5959,
  chef_environment: node.chef_environment
}

include_recipe 'elkstack::_secrets'
unless node.run_state['lumberjack_decoded_certificate'].nil? || node.run_state['lumberjack_decoded_certificate'].nil?
  my_templates['input_lumberjack'] = 'logstash/input_lumberjack.conf.erb'
  template_variables['input_lumberjack_ssl_certificate'] = "#{node['logstash']['instance_default']['basedir']}/lumberjack.crt"
  template_variables['input_lumberjack_ssl_key'] = "#{node['logstash']['instance_default']['basedir']}/lumberjack.key"
end

logstash_config instance_name do
  action 'create'
  templates_cookbook 'elkstack'
  templates my_templates
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
