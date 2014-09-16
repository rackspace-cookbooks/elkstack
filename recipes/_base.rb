# Encoding: utf-8
#
# Cookbook Name:: elkstack
# Recipe:: base
#
# Copyright 2014, Rackspace
#

node.set['apt']['compile_time_update'] = true
include_recipe 'apt'
include_recipe 'build-essential'

include_recipe 'chef-sugar'
include_recipe 'python'
include_recipe 'platformstack::iptables'
include_recipe 'platformstack::default'
include_recipe 'platformstack::monitors'

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
  end
else
  correct_ip = node['network']['interfaces'][stripped_es_network_host]['addresses'].keys[1]
  node.override['logstash']['instance']['server']['elasticsearch_ip'] = correct_ip
  node.override['logstash']['instance']['server']['config_templates_variables']['elasticsearch_ip'] = correct_ip
  node.override['kibana']['es_server'] = correct_ip

  append_if_no_line 'make sure a line is in /etc/hosts' do
    path '/etc/hosts'
    line "#{correct_ip} eslocal # nice shortcut for curl, etc."
  end

end
# end nasty logic for logstash & kibana to find es

# if iptables toggle is set, include host based firewall rules
iptables_enabled = node.deep_fetch('elkstack', 'config', 'iptables')
if !iptables_enabled.nil? && iptables_enabled
  include_recipe 'elkstack::acl'
end
