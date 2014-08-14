# Encoding: utf-8
#
# Cookbook Name:: elkstack
# Recipe:: logstash
#
# Copyright 2014, Rackspace
#

es_search = "recipes:elasticsearch\\:\\:default AND chef_environment:#{node.chef_environment}"
es = search('node', es_search).first

node.set['logstash']['instance']['default']['enable_embedded_es'] = false
node.set['logstash']['instance']['default']['elasticsearch_cluster'] = 'logstash'
node.set['logstash']['instance']['default']['elasticsearch_ip'] = best_ip_for(es)
node.set['logstash']['instance']['default']['bind_host_interface'] = best_ip_for(es)
node.set['logstash']['instance']['default']['elasticsearch_port'] = '9200'

node.set['logstash']['server']['enable_embedded_es'] = false
node.set['logstash']['instance']['server'] = 'logstash'
include_recipe 'logstash::server'
