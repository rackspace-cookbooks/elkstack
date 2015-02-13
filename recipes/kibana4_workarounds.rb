# Encoding: utf-8
#
# Cookbook Name:: elkstack
# Recipe:: kibana4_workarounds
#
# Copyright 2014, Rackspace
#

template "#{node['kibana']['install_path']}/kibana/current/#{node['kibana']['file']['config']}" do
  source 'kibana.yml.erb'
  cookbook 'elkstack'
  mode '0644'
  user node['kibana']['user']
  group node['kibana']['user']
  variables(
    index: node['kibana']['config']['kibana_index'],
    port: node['kibana']['java_webserver_port'],
    elasticsearch: "#{node['kibana']['es_scheme']}#{node['kibana']['es_server']}:#{node['kibana']['es_port']}",
    default_route: node['kibana']['config']['default_route'],
    panel_names: node['kibana']['config']['panel_names']
  )
end
