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

# everybody loves python! (this is a shortening of python::default)
# This should be switched to stack_commons::python when that is merged.
include_recipe "python::#{node['python']['install_method']}"
include_recipe 'python::pip'

bash 'manually upgrade setuptools' do
  user 'root'
  cwd '/tmp'
  code <<-EOH
  easy_install --upgrade setuptools
  EOH
  only_if { rhel? }
end

include_recipe 'python::virtualenv'
