# Encoding: utf-8
#
# Cookbook Name:: elkstack
# Recipe:: acl
#
# Copyright 2014, Rackspace
#

include_recipe 'chef-sugar'
add_iptables_rule('INPUT', '-i lo -j ACCEPT', 9900, 'allow services on loopback to talk to any interface')

# main point of elkstack, open syslog and lumberjack ports
add_iptables_rule('INPUT', '-p tcp --dport 5959 -j ACCEPT', 9997, 'allow syslog entries inbound')
add_iptables_rule('INPUT', '-p tcp --dport 5960 -j ACCEPT', 9997, 'allow lumberjack protocol inbound')
add_iptables_rule('INPUT', '-p tcp --dport 5961 -j ACCEPT', 9997, 'allow tcp protocol inbound')
add_iptables_rule('INPUT', '-p tcp --dport 5962 -j ACCEPT', 9997, 'allow udp protocol inbound')

include_recipe 'elasticsearch::search_discovery' unless Chef::Config[:solo]
es_nodes = node.deep_fetch('elasticsearch', 'discovery', 'zen', 'ping', 'unicast', 'hosts')
es_nodes = '' if es_nodes.nil?

es_nodes.split(',').each do |host|
  add_iptables_rule('INPUT', "-p tcp -s #{host} --dport 9300 -j ACCEPT", 9996, "allow ES host #{host} to connect")
end

# allow web clients to hit kibana on port 80 and 443
add_iptables_rule('INPUT', '-p tcp --dport 80 -j ACCEPT', 9998, 'allow nginx for kibana to serve pages')
add_iptables_rule('INPUT', '-p tcp --dport 443 -j ACCEPT', 9998, 'allow nginx for kibana to serve pages')
