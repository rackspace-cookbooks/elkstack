# Encoding: utf-8
#
# Cookbook Name:: elkstack
# Recipe:: kibana
#
# Copyright 2014, Rackspace
#

# base stack requirements
include_recipe 'elkstack::_server'

# setup nginx then kibana ()
node.override['nginx']['repo_source'] = 'epel' if rhel?

# configure / prepare an SSL cert and default htpassword
include_recipe 'elkstack::kibana_ssl'

# nginx cookbook doesn't remove this when !node['nginx']['default_site_enabled']
# (the main config file template includes both sites-enabled/* and conf.d/*)
node.set['nginx']['default_site_enabled'] = node['kibana']['nginx']['enable_default_site']
node.set['nginx']['install_method'] = node['kibana']['nginx']['install_method']
include_recipe 'nginx' # so service[nginx] exists, the one from the LWRP above is not created until runtime
file '/etc/nginx/conf.d/default.conf' do
  action :delete
  notifies :reload, 'service[nginx]'
  only_if { rhel? }
end

# begin replaces 'kibana::install'
if node['kibana']['user'].empty?
  if !node['kibana']['webserver'].empty?
    webserver = node['kibana']['webserver']
    kibana_user = node[webserver]['user']
  else
    kibana_user = 'nobody'
  end
else
  kibana_user = node['kibana']['user']
  kibana_user kibana_user do
    name kibana_user
    group kibana_user
    home node['kibana']['install_dir']
    action :create
  end
end

kibana_install 'kibana' do
  user kibana_user
  group kibana_user
  install_dir node['kibana']['install_dir']
  install_type node['kibana']['install_type']
  action :create
end

template "#{node['kibana']['install_dir']}/current/config.js" do
  source node['kibana']['config_template']
  cookbook node['kibana']['config_cookbook']
  mode '0750'
  user kibana_user
end

link "#{node['kibana']['install_dir']}/current/app/dashboards/default.json" do
  to 'logstash.json'
  only_if { !File.symlink?("#{node['kibana']['install_dir']}/current/app/dashboards/default.json") }
end

kibana_web 'kibana' do
  type node['kibana']['webserver']
  docroot "#{node['kibana']['install_dir']}/current"
  template_cookbook node['kibana']['nginx']['template_cookbook']
  template node['kibana']['nginx']['template']
  es_server node['kibana']['es_server']
  es_port node['kibana']['es_port']
  not_if { node['kibana']['webserver'].empty? }
end
# end replaces 'kibana::install'

# monitoring
include_recipe 'elkstack::kibana_monitoring'
