# Encoding: utf-8
#
# Cookbook Name:: elkstack
# Recipe:: single
#
# Copyright 2014, Rackspace
#
include_recipe 'elkstack::_base'
include_recipe 'java'
include_recipe 'elasticsearch::default'

node.set['logstash']['instance']['server']['enable_embedded_es'] = false
node.set['logstash']['instance']['server']['elasticsearch_cluster'] = 'logstash'
node.set['logstash']['instance']['server']['elasticsearch_ip'] = '127.0.0.1'
node.set['logstash']['instance']['server']['bind_host_interface'] = '127.0.0.1'
node.set['logstash']['instance']['server']['elasticsearch_port'] = '9200'
node.set['logstash']['instance']['server']['basedir'] = '/opt/logstash'
node.set['logstash']['instance']['server']['install_type'] = 'tarball'
node.set['logstash']['instance']['server']['version'] = '1.4.1'
node.set['logstash']['instance']['server']['checksum'] = 'a1db8eda3d8bf441430066c384578386601ae308ccabf5d723df33cee27304b4'
node.set['logstash']['instance']['server']['source_url'] = 'https://download.elasticsearch.org/logstash/logstash/logstash-1.4.1.tar.gz'
node.set['logstash']['instance']['server']['user'] = 'logstash'
node.set['logstash']['instance']['server']['group'] = 'logstash'
node.set['logstash']['instance']['server']['user_opts'] = { homedir: '/var/lib/logstash', uid: nil, gid: nil }
node.set['logstash']['instance']['server']['logrotate_enable']  = true
node.set['logstash']['instance']['server']['logrotate_options'] = %w(missingok notifempty compress copytruncate)
node.set['logstash']['instance']['server']['logrotate_frequency'] = 'daily'
node.set['logstash']['instance']['server']['logrotate_max_backup'] = 10
node.set['logstash']['instance']['server']['logrotate_max_size'] = '10M'
node.set['logstash']['instance']['server']['logrotate_use_filesize'] = false
node.set['logstash']['instance']['server']['xms'] = "#{(node['memory']['total'].to_i * 0.2).floor / 1024}M"
node.set['logstash']['instance']['server']['xmx'] = "#{(node['memory']['total'].to_i * 0.4).floor / 1024}M"

node.set['logstash']['instance']['server']['pattern_templates_cookbook'] = 'logstash'
node.set['logstash']['instance']['server']['base_config_cookbook'] = 'logstash'
node.set['logstash']['instance']['server']['config_templates_cookbook'] = 'logstash'

config_templates_variables = {}
config_templates_variables['elasticsearch_embedded']=false
node.set['logstash']['instance']['server']['config_templates_variables'] = config_templates_variables

# this is not used anywhere except the README :(
node.set['logstash']['server']['enable_embedded_es'] = false

logstash_instance 'server' do
  action 'create'
end

my_templates = {
  'input_syslog' => 'config/input_syslog.conf.erb',
  'output_stdout' => 'config/output_stdout.conf.erb',
  'output_elasticsearch' => 'config/output_elasticsearch.conf.erb'
}

logstash_service 'server' do
  action ['enable']
end

logstash_config 'server' do
  action 'create'
  templates my_templates
  notifies :restart, 'logstash_service[server]', :delayed
end

logstash_service 'server' do
  action ['start']
end

if rhel?
  node.override['nginx']['repo_source'] = 'epel'
  include_recipe 'nginx'
end

include_recipe 'kibana'
include_recipe 'kibana::install'
