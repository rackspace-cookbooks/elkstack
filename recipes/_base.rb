# Encoding: utf-8
#
# Cookbook Name:: elkstack
# Recipe:: base
#
# Copyright 2014, Rackspace
#

node.override['apt']['compile_time_update'] = true
include_recipe 'apt'
node.override['build-essential']['compile_time'] = true
include_recipe 'build-essential'

include_recipe 'chef-sugar'
include_recipe 'python'
include_recipe 'platformstack::iptables'
include_recipe 'platformstack::default'
include_recipe 'platformstack::monitors'

# for long cloud server names :(
node.set['nginx']['server_names_hash_bucket_size'] = 128

# elasticsearch init scripts require ruby -- whee!
# maybe we'll do something different eventually, since it's only using ruby for
# parsing JSON -- we could do that with python which already have.
package 'ruby' do
  action :install
end
