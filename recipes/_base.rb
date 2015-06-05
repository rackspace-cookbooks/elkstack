# Encoding: utf-8
#
# Cookbook Name:: elkstack
# Recipe:: _base
#
# Copyright 2014, Rackspace
#
# This recipe is applied to clients and servers alike. Use _server or _agent if
# you need a base that is appropriate only for logging clients or ELK servers.

node.set['apt']['compile_time_update'] = true
include_recipe 'apt'
include_recipe 'build-essential'

include_recipe 'chef-sugar'

# everybody loves python! (this is a shortening(with fix) of python::default)
include_recipe 'elkstack::_python'
