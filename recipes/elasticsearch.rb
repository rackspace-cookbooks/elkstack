# Encoding: utf-8
#
# Cookbook Name:: elkstack
# Recipe:: elasticsearch
#
# Copyright 2014, Rackspace
#

# base stack requirements
include_recipe 'elkstack::_base'

# do clustering magic, with custom query for our tags
include_recipe 'chef-sugar'
should_cluster = node.deep_fetch('elkstack', 'config', 'cluster')
if !should_cluster.nil? && should_cluster
  include_recipe 'elasticsearch::search_discovery'
  node.override['elasticsearch']['network']['host'] = '0.0.0.0'
else
  node.override['elasticsearch']['discovery']['zen']['ping']['multicast']['enabled'] = false
  # if the cluster flag isn't set, turn that junk off
  # ['elasticsearch']['network']['host'] already defaults to localhost
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
