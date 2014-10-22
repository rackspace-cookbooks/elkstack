# Encoding: utf-8
#
# Cookbook Name:: elkstack
# Recipe:: elasticsearch
#
# Copyright 2014, Rackspace
#

# base stack requirements
include_recipe 'elkstack::_server'

# do clustering magic, with custom query for our tags
include_recipe 'chef-sugar'
should_cluster = node.deep_fetch('elkstack', 'config', 'cluster')
if !should_cluster.nil? && should_cluster
  include_recipe 'elasticsearch::search_discovery'
else
  node.override['elasticsearch']['discovery']['zen']['ping']['multicast']['enabled'] = false
  # if the cluster flag isn't set, turn that junk off
end

# find and format and mount any relevant disks
include_recipe 'elkstack::disk_setup'

# many of the interesting customizations for this were done in attributes
include_recipe 'elasticsearch::default'
include_recipe 'elasticsearch::plugins'

# this must be started for other things like logstash to be startable
service 'elasticsearch' do
  action :start
end

# was the module enabled? (default value for this ensures cloud credentials are set too)
rackspace_elasticsearch_mod_enabled = node.deep_fetch('elasticsearch', 'custom_config', 'rackspace.enabled')

# were backups turned on? they are by default, but check
backups_enabled_flag = node.deep_fetch('elkstack', 'config', 'backups', 'enabled')

if rackspace_elasticsearch_mod_enabled && backups_enabled_flag
  include_recipe 'elkstack::elasticsearch_backup'
end

tag('elkstack')
tag('elkstack_cluster') unless should_cluster.nil? || !should_cluster

include_recipe 'elkstack::elasticsearch_monitoring'
