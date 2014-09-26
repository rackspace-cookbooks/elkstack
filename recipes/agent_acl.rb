# Encoding: utf-8
#
# Cookbook Name:: elkstack
# Recipe:: agent_acl
#
# Copyright 2014, Rackspace
#

add_iptables_rule('INPUT', '-i lo -j ACCEPT', 9900, 'allow services on loopback to talk to any interface')

include_recipe 'elasticsearch::search_discovery'
es_nodes = node['elasticsearch']['discovery']['zen']['ping']['unicast']['hosts']

if es_nodes
  es_nodes.split(',').each do |host|
    add_iptables_rule('INPUT', "-p tcp -s #{host} --dport 9300 -j ACCEPT", 9996, "allow ES host #{host} to connect")
  end
end
