# Encoding: utf-8
#
# Cookbook Name:: elkstack
# Recipe:: agent_acl
#
# Copyright 2014, Rackspace
#

firewall 'iptables' do
  action :enable
  provider Chef::Provider::FirewallIptables
end

include_recipe 'elasticsearch::search_discovery' unless Chef::Config[:solo]
es_nodes = node.deep_fetch('elasticsearch', 'discovery', 'zen', 'ping', 'unicast', 'hosts')
es_nodes = '' if es_nodes.nil?

es_nodes.split(',').each do |host|
  firewall_rule "allow ES host #{host} to connect" do
    provider    Chef::Provider::FirewallRuleIptables
    protocol    :tcp
    port        9300
    source      host
    action      :allow
  end
end

firewall_rule 'open_loopback' do
  provider Chef::Provider::FirewallRuleIptables
  raw       'INPUT -i lo -j ACCEPT -m comment --comment "allow services on loopback to talk to any interface"'
  action    :allow
end
