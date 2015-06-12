# Encoding: utf-8
#
# Cookbook Name:: elkstack
# Recipe:: _server
#
# Copyright 2014, Rackspace
#

include_recipe 'elkstack::_base'
include_recipe 'chef-sugar'

instance_name = node['elkstack']['config']['logstash']['instance_name']

# for long cloud server names :(
node.set['nginx']['server_names_hash_bucket_size'] = 128

# elasticsearch init scripts require ruby -- whee!
# maybe we'll do something different eventually, since it's only using ruby for
# parsing JSON -- we could do that with python which already have.
package 'ruby' do
  action :install
end

# begin nasty logic for logstash & kibana to find es
# this covers es's weird _interface:ipv6/4_ syntax.
stripped_es_network_host = node['elasticsearch']['network']['host']
if stripped_es_network_host.include?(':') # grab ip side of pair
  stripped_es_network_host = stripped_es_network_host.split(':').first
end
if stripped_es_network_host.include?('_') # strip underscores
  stripped_es_network_host = stripped_es_network_host.sub('_', '')
end

if node['network']['interfaces'][stripped_es_network_host].nil?
  append_if_no_line 'make sure a line is in /etc/hosts' do
    path '/etc/hosts'
    line "#{stripped_es_network_host} eslocal # nice shortcut for curl, etc."
    action :edit
  end
else
  correct_ip = node['network']['interfaces'][stripped_es_network_host]['addresses'].keys[1]
  node.override['logstash']['instance'][instance_name]['elasticsearch_ip'] = correct_ip
  node.override['logstash']['instance'][instance_name]['config_templates_variables']['elasticsearch_ip'] = correct_ip
  node.override['kibana']['es_server'] = correct_ip

  append_if_no_line 'make sure a line is in /etc/hosts' do
    path '/etc/hosts'
    line "#{correct_ip} eslocal # nice shortcut for curl, etc."
  end

end
# end nasty logic for logstash & kibana to find es

# if iptables toggle is set, include host based firewall rules
iptables_enabled = node.deep_fetch('elkstack', 'config', 'iptables', 'enabled')
if !iptables_enabled.nil? && iptables_enabled
  include_recipe 'elkstack::acl'
end
