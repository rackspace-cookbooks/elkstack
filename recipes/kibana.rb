# Encoding: utf-8
#
# Cookbook Name:: elkstack
# Recipe:: kibana
#
# Copyright 2014, Rackspace
#
include_recipe 'elkstack::_base'

if Chef::Config[:solo]
  Chef::Log.warn('This recipe uses search. Chef Solo does not support search.')
end

es = search('node', "recipes:elasticsearch\\:\\:default AND chef_environment:#{node.chef_environment}").first

node.override['kibana']['es_server'] = best_ip_for(es)
if rhel?
  node.override['nginx']['repo_source'] = 'epel'
  include_recipe 'nginx'
end
include_recipe 'kibana'
include_recipe 'kibana::install'
