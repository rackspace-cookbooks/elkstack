# Encoding: utf-8
#
# Cookbook Name:: elkstack
# Recipe:: kibana
#
# Copyright 2014, Rackspace
#

# base stack requirements
include_recipe 'elkstack::_base'

if rhel?
  node.override['nginx']['repo_source'] = 'epel'
  include_recipe 'nginx'

  # nginx cookbook doesn't remove this when !node['nginx']['default_site_enabled']
  # (the main config file template includes both sites-enabled/* and conf.d/*)
  file '/etc/nginx/conf.d/default.conf' do
    action :delete
    notifies :reload, 'service[nginx]'
  end
end

# eventually customize this more --
# https://github.com/lusis/chef-kibana/blob/89e6255e7a6c01238d349ca910c58f42af7628c8/recipes/nginx.rb#L30-L37
include_recipe 'kibana'
include_recipe 'kibana::install'

# Cloud monitoring currently doesn't provide a hook to push in files from git, just from the cookbook.
# Push the file ourselves and configure the monitor.

process_name = 'nginx'

# make sure directory structure exists
directory '/usr/lib/rackspace-monitoring-agent/plugins' do
  recursive true
  action :create
end

# drop the file
remote_file '/usr/lib/rackspace-monitoring-agent/plugins/process_mon.sh' do
  owner 'root'
  group 'root'
  mode 00755
  source 'https://raw.github.com/racker/rackspace-monitoring-agent-plugins-contrib/master/process_mon.sh'
end

# setup the monitor
template "process-monitor-#{process_name}" do
  cookbook 'elkstack'
  source 'monitoring-process.yaml.erb'
  path "/etc/rackspace-monitoring-agent.conf.d/#{process_name}-monitor.yaml"
  owner 'root'
  group 'root'
  mode '0644'
  variables(
    process_name: process_name
  )
  notifies 'restart', 'service[rackspace-monitoring-agent]', 'delayed'
  action 'create'
end
