# Encoding: utf-8
#
# Cookbook Name:: elkstack
# Recipe:: single
#
# Copyright 2014, Rackspace
#

# base stack requirements for an all-in-one node
include_recipe 'elkstack::_base'

# bind interface variables
node.override['logstash']['instance']['server']['bind_host_interface'] = '127.0.0.1'
node.override['elasticsearch']['network']['host'] = '127.0.0.1'

# include components
include_recipe 'elkstack::elasticsearch'
include_recipe 'elkstack::logstash'
include_recipe 'elkstack::rsyslog'
include_recipe 'elkstack::kibana'
