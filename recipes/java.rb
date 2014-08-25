# Encoding: utf-8
#
# Cookbook Name:: elkstack
# Recipe:: java
#
# Copyright 2014, Rackspace
#

# base stack requirements
include_recipe 'elkstack::_base'

# added this for testing. eventually just require wrappers invoke
# a java cookbook of their choice, or perhaps eventually something that installs
# java in a 'rackspace way' where customers have accepted the license and
# downloaded it themselves.
include_recipe 'java'
