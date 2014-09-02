# Encoding: utf-8
#
# Cookbook Name:: elkstack
# Recipe:: kibana_ssl
#
# Copyright 2014, Rackspace
#

::Chef::Recipe.send(:include, Opscode::OpenSSL::Password)
basic_auth_password = secure_password
htpasswd "#{node['nginx']['dir']}/htpassword" do
  user 'kibana'
  password basic_auth_password
end

# write this for testing
basic_auth_file = "#{node['nginx']['dir']}/htpassword.curl"
file basic_auth_file do
  owner 'root'
  group 'root'
  mode 0600
  content "user = \"kibana:#{basic_auth_password}\""
  action :create_if_missing
end

include_recipe 'openssl'
directory "#{node['nginx']['dir']}/ssl" do
  owner 'root'
  group 'root'
  mode 0755
  action :create
  recursive true
end

site_name = node['elkstack']['config']['site_name']
key_file = "#{node['nginx']['dir']}/ssl/#{site_name}.key"
cert_file = "#{node['nginx']['dir']}/ssl/#{site_name}.pem"
openssl_x509 cert_file do
  common_name node.name
  org 'Kibana'
  org_unit 'Kibana'
  country 'US'
  key_file key_file
end
