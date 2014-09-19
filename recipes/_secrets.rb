# Encoding: utf-8
#
# Cookbook Name:: elkstack
# Recipe:: secrets
#
# Copyright 2014, Rackspace
#

# if there's a data bag, get the contents out, shove them in node.run_state
lumberjack_data_bag = node['elkstack']['config']['lumberjack_data_bag']
lumberjack_secrets = Chef::EncryptedDataBagItem.load(lumberjack_data_bag, 'secrets')
if !lumberjack_secrets.nil? && lumberjack_secrets['key'] && lumberjack_secrets['certificate']
  node.run_state['lumberjack_decoded_key'] = Base64.decode64(lumberjack_secrets['key'])
  node.run_state['lumberjack_decoded_certificate'] = Base64.decode64(lumberjack_secrets['certificate'])
end

# if we had overrode basedir value, we'd need to use the new value here too
file "#{node['logstash']['instance_default']['basedir']}/lumberjack.key" do
  content node.run_state['lumberjack_decoded_key']
  owner node['logstash']['instance_default']['user']
  group node['logstash']['instance_default']['group']
  mode '0600'
  not_if { node.run_state['lumberjack_decoded_key'].nil? }
end

# if we had overrode basedir value, we'd need to use the new value here too
file "#{node['logstash']['instance_default']['basedir']}/lumberjack.crt" do
  content node.run_state['lumberjack_decoded_certificate']
  owner node['logstash']['instance_default']['user']
  group node['logstash']['instance_default']['group']
  mode '0600'
  not_if { node.run_state['lumberjack_decoded_certificate'].nil? }
end
