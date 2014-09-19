# Encoding: utf-8
#
# Cookbook Name:: elkstack
# Recipe:: acl
#
# Copyright 2014, Rackspace
#

add_iptables_rule('INPUT', '-i lo -j ACCEPT', 9900, 'allow services on loopback to talk to any interface')

# main point of elkstack, open syslog and lumberjack ports
add_iptables_rule('INPUT', '-p tcp --dport 5959 -j ACCEPT', 9997, 'allow syslog entries inbound')
add_iptables_rule('INPUT', '-p tcp --dport 5960 -j ACCEPT', 9997, 'allow lumberjack protocol inbound')

should_cluster = node.deep_fetch('elkstack', 'config', 'cluster')
if !should_cluster.nil? && should_cluster
  include_recipe 'elasticsearch::search_discovery'
  es_nodes = node['elasticsearch']['discovery']['zen']['ping']['unicast']['hosts']
  es_nodes.split(',').each do |host|
    add_iptables_rule('INPUT', "-p tcp -s #{host} --dport 9300 -j ACCEPT", 9996, "allow ES host #{host} to connect")
  end
end

# allow web clients to hit kibana on port 80 and 443
add_iptables_rule('INPUT', '-p tcp --dport 80 -j ACCEPT', 9998, 'allow nginx for kibana to serve pages')
add_iptables_rule('INPUT', '-p tcp --dport 443 -j ACCEPT', 9998, 'allow nginx for kibana to serve pages')
