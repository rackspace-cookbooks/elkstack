# Encoding: utf-8
#
# Cookbook Name:: elkstack
# Recipe:: elasticsearch
#
# Copyright 2014, Rackspace
#

# base stack requirements
include_recipe 'elkstack::_base'

# many of the interesting customizations for this were done in attributes
include_recipe 'elasticsearch::default'
include_recipe 'elasticsearch::plugins'

# this must be started for other things like logstash to be startable
service 'elasticsearch' do
  action :start
end
