# Encoding: utf-8
#
# Cookbook Name:: elkstack
# Recipe:: cluster
#
# Copyright 2014, Rackspace
#

# base stack requirements for an all-in-one node
include_recipe 'elkstack::_base'

# toggle clustering behavior
node.override['elkstack']['config']['cluster'] = true

# include components
include_recipe 'elkstack::elasticsearch'
include_recipe 'elkstack::logstash'
include_recipe 'elkstack::rsyslog'
include_recipe 'elkstack::kibana'
