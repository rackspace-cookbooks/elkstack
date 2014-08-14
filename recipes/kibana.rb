# Encoding: utf-8
#
# Cookbook Name:: elkstack
# Recipe:: kibana
#
# Copyright 2014, Rackspace
#
include_recipe 'chef-sugar'

if Chef::Config[:solo]
  Chef::Log.warn('This recipe uses search. Chef Solo does not support search.')
end

es_search = "recipes:elasticsearch\\:\\:default AND chef_environment:#{node.chef_environment}"
es = search('node', es_search).first

node.override['kibana']['es_server'] = best_ip_for(es)
include_recipe 'kibana'
include_recipe 'kibana::install'
