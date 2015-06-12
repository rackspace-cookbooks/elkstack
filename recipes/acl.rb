# Encoding: utf-8
#
# Cookbook Name:: elkstack
# Recipe:: acl
#
# Copyright 2014, Rackspace
#

firewall 'iptables' do
  action :enable
  provider Chef::Provider::FirewallIptables
end

include_recipe 'chef-sugar'

# main point of elkstack, open syslog and lumberjack ports
{ 'syslog' => 5959,
  'lumberjack' => 5960,
  'tcp' =>  5961,
  # allow web clients to hit kibana on port 80 and 443
  'nginx SSL' => 443,
  'nginx' => 80
}.each do |service, port|
  firewall_rule "allow #{service} entries inbound" do
    provider    Chef::Provider::FirewallRuleIptables
    protocol    :tcp
    port        port
    action      :allow
  end
end

firewall_rule 'allow udp entries inbound' do
  provider    Chef::Provider::FirewallRuleIptables
  protocol    :udp
  port        5962
  action      :allow
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
