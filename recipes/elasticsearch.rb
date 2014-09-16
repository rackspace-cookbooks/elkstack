# Encoding: utf-8
#
# Cookbook Name:: elkstack
# Recipe:: elasticsearch
#
# Copyright 2014, Rackspace
#
include_recipe 'chef-sugar'

# base stack requirements
include_recipe 'elkstack::_base'

# find and format and mount any relevant disks
include_recipe 'elkstack::disk_setup'

# do clustering magic, with custom query for our tags
should_cluster = node.deep_fetch('elkstack', 'config', 'cluster')
if !should_cluster.nil? && should_cluster
  include_recipe 'elasticsearch::search_discovery'
else
  node.override['elasticsearch']['discovery']['zen']['ping']['multicast']['enabled'] = false
  # if the cluster flag isn't set, turn that junk off
end

should_backup = node.deep_fetch('elkstack', 'config', 'backups')
if !should_backup.nil? && should_backup
  include_recipe 'elkstack::elasticsearch_backup'
end

# many of the interesting customizations for this were done in attributes
include_recipe 'elasticsearch::default'
include_recipe 'elasticsearch::plugins'

# this must be started for other things like logstash to be startable
service 'elasticsearch' do
  action :start
end

tag('elkstack')
tag('elkstack_cluster') unless should_cluster.nil? || !should_cluster

include_recipe 'elkstack::elasticsearch_monitoring'
