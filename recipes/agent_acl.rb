# Encoding: utf-8
#
# Cookbook Name:: elkstack
# Recipe:: agent_acl
#
# Copyright 2014, Rackspace
#

add_iptables_rule('INPUT', '-i lo -j ACCEPT', 9900, 'allow services on loopback to talk to any interface')

include_recipe 'elasticsearch::search_discovery' unless Chef::Config[:solo]
es_nodes = node.deep_fetch('elasticsearch', 'discovery', 'zen', 'ping', 'unicast', 'hosts')
es_nodes = '' if es_nodes.nil?

es_nodes.split(',').each do |host|
  add_iptables_rule('INPUT', "-p tcp -s #{host} --dport 9300 -j ACCEPT", 9996, "allow ES host #{host} to connect")
end
