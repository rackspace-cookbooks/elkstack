# Encoding: utf-8
#
# Cookbook Name:: elkstack
# Recipe:: kibana
#
# Copyright 2014, Rackspace
#

# base stack requirements
include_recipe 'elkstack::_base'

if rhel?
  node.override['nginx']['repo_source'] = 'epel'
  include_recipe 'nginx'

  # nginx cookbook doesn't remove this when !node['nginx']['default_site_enabled']
  # (the main config file template includes both sites-enabled/* and conf.d/*)
  file '/etc/nginx/conf.d/default.conf' do
    action :delete
    notifies :reload, 'service[nginx]'
  end
end

# eventually customize this more --
# https://github.com/lusis/chef-kibana/blob/89e6255e7a6c01238d349ca910c58f42af7628c8/recipes/nginx.rb#L30-L37
include_recipe 'kibana'
include_recipe 'kibana::install'

add_iptables_rule('INPUT', '-p tcp --dport 80 -j ACCEPT', 9998, 'allow nginx for kibana to connect') unless node['elkstack']['iptables']['enabled'].nil?
