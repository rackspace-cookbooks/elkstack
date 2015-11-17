# Encoding: utf-8
#
# Cookbook Name:: elkstack
# Recipe:: agent_acl
#
# Copyright 2014, Rackspace
#

firewall 'iptables' do
  action :enable
end

include_recipe 'elasticsearch::search_discovery' unless Chef::Config[:solo]
es_nodes = node.deep_fetch('elasticsearch', 'discovery', 'zen', 'ping', 'unicast', 'hosts')
es_nodes = '' if es_nodes.nil?

es_nodes.split(',').each do |host|
  firewall_rule "allow ES host #{host} to connect" do
    protocol    :tcp
    port        9300
    source      host
    command     :allow
  end
end

firewall_rule 'open_loopback' do
  interface 'lo'
  protocol :none
end
