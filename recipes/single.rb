# Encoding: utf-8
#
# Cookbook Name:: elkstack
# Recipe:: single
#
# Copyright 2014, Rackspace
#
include_recipe 'build-essential'
include_recipe 'chef-sugar'
include_recipe 'elkstack::_base'

include_recipe 'java'
include_recipe 'elasticsearch::default'

node.set['logstash']['instance']['default']['enable_embedded_es'] = false
node.set['logstash']['instance']['default']['elasticsearch_cluster'] = 'logstash'
node.set['logstash']['instance']['default']['elasticsearch_ip'] = '127.0.0.1'
node.set['logstash']['instance']['default']['bind_host_interface'] = '127.0.0.1'
node.set['logstash']['instance']['default']['elasticsearch_port'] = '9200'

node.set['logstash']['server']['enable_embedded_es'] = false
node.set['logstash']['instance']['server'] = 'logstash'
include_recipe 'logstash::server'

if rhel?
  node.override['nginx']['repo_source'] = 'epel'
  include_recipe 'nginx'
end

include_recipe 'kibana'
include_recipe 'kibana::install'
