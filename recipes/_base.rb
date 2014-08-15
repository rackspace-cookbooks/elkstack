# Encoding: utf-8
#
# Cookbook Name:: elkstack
# Recipe:: base
#
# Copyright 2014, Rackspace
#
include_recipe 'build-essential'
include_recipe 'chef-sugar'
include_recipe 'python'

# for long cloud server names :(
node.set['nginx']['server_names_hash_bucket_size'] = 128
