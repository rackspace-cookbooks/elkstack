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

# begin replaces 'kibana::install'
install_type = node['kibana']['install_type']

unless Chef::Config[:solo]
  es_server_results = search(:node, "roles:#{node['kibana']['es_role']} AND chef_environment:#{node.chef_environment}")
  unless es_server_results.empty?
    node.set['kibana']['es_server'] = es_server_results[0]['ipaddress']
  end
end

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
  install_type install_type
  action :create
end

docroot = "#{node['kibana']['install_dir']}/current/kibana"
kibana_config = "#{node['kibana']['install_dir']}/current/#{node['kibana'][install_type]['config']}"
es_server = "#{node['kibana']['es_scheme']}#{node['kibana']['es_server']}:#{node['kibana']['es_port']}"

template kibana_config do
  source node['kibana'][install_type]['config_template']
  cookbook node['kibana'][install_type]['config_template_cookbook']
  mode '0644'
  user kibana_user
  group kibana_user
  variables(
    index: node['kibana']['config']['kibana_index'],
    port: node['kibana']['java_webserver_port'],
    elasticsearch: es_server,
    default_route: node['kibana']['config']['default_route'],
    panel_names:  node['kibana']['config']['panel_names']
  )
end

if install_type == 'file'
  include_recipe 'runit::default'

  runit_service 'kibana' do
    options(
      user: kibana_user,
      home: "#{node['kibana']['install_dir']}/current"
    )
    cookbook 'kibana_lwrp'
    subscribes :restart, "template[#{kibana_config}]", :delayed
  end

end

kibana_web 'kibana' do
  type lazy { node['kibana']['webserver'] }
  docroot docroot
  es_server node['kibana']['es_server']
  kibana_port node['kibana']['java_webserver_port']
  # template 'kibana-nginx_file.conf.erb'
  template_cookbook node['kibana']['nginx']['template_cookbook']
  template node['kibana']['nginx']['template']
  es_port node['kibana']['es_port']
  server_name node['kibana']['server_name']
  server_aliases node['kibana']['server_aliases']
  action :create
  not_if { node['kibana']['webserver'] == '' }
end
# end replaces 'kibana::install'

# include_recipe 'nginx' # so service[nginx] exists, the one from the LWRP above is not created until runtime
service 'nginx' do
  action :nothing
end
file '/etc/nginx/conf.d/default.conf' do
  action :delete
  notifies :reload, 'service[nginx]'
  only_if { rhel? }
end

# monitoring
include_recipe 'elkstack::kibana_monitoring'
