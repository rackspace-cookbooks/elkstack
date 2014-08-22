# Encoding: utf-8
#
# Cookbook Name:: elkstack
# Recipe:: base
#
# Copyright 2014, Rackspace
#
include_recipe 'build-essential'
include_recipe 'chef-sugar'
include_recipe "python"

# for long cloud server names :(
node.set['nginx']['server_names_hash_bucket_size'] = 128

# elasticsearch init scripts require ruby -- whee!
# maybe we'll do something different eventually, since it's only using ruby for
# parsing JSON -- we could do that with python which already have.
package 'ruby' do
  action :install
end
