# Encoding: utf-8
#
# Cookbook Name:: elkstack
# Recipe:: rsyslog
#
# Copyright 2014, Rackspace
#

# see attributes, will forward to logstash on localhost
include_recipe 'rsyslog::client'

# eventually, this wrapper recipe could do more like configure filtering
# or direct logs somewhere else, or handle log rotation, so it hasn't been
# removed or collapsed into another recipe yet.
