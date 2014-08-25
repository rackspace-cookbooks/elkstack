# Encoding: utf-8
#
# Cookbook Name:: elkstack
# Recipe:: rsyslog
#
# Copyright 2014, Rackspace
#

log node['rsyslog']['group']

# see attributes, will forward to logstash on localhost
include_recipe 'rsyslog::client'
