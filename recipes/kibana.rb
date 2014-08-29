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
  
  include_recipe 'kibana'
  include_recipe 'kibana::install'

  #::Chef::Recipe.send(:include, Opscode::OpenSSL::Password)
  htpasswd "#{node['nginx']['dir']}/htpassword" do
    user 'kibana'
    password 'CHANGEME'
    #password secure_password
  end

  include_recipe 'openssl'
  directory "#{node['nginx']['dir']}/ssl" do
    owner "root"
    group "root"
    mode 0755
    action :create
  end
  site_name = 'kibana'
  key_file = "#{node['nginx']['dir']}/ssl/#{site_name}.key"
  cert_file = "#{node['nginx']['dir']}/ssl/#{site_name}.pem"
  openssl_x509 cert_file do
    common_name node.name
    org 'Kibana'
    org_unit 'Kibana'
    country 'US'
    key_file key_file
  end

  # nginx cookbook doesn't remove this when !node['nginx']['default_site_enabled']
  # (the main config file template includes both sites-enabled/* and conf.d/*)
  file '/etc/nginx/conf.d/default.conf' do
    action :delete
    notifies :reload, 'service[nginx]'
  end

  template "#{node['nginx']['dir']}/sites-available/kibana" do
   source node['kibana']['nginx']['template']
    mode 0600
    owner 'root'
    group 'root'
    notifies :reload, 'service[nginx]'
    variables(
      es_server: node['kibana']['es_server'],
      es_port: node['kibana']['es_port'],
      server_name: node['kibana']['webserver_hostname'],
      server_aliases: node['kibana']['webserver_aliases'],
      kibana_dir: node['kibana']['web_dir'],
      listen_address: node['kibana']['webserver_listen'],
      listen_port: node['kibana']['webserver_port'],
      es_scheme: node['kibana']['es_scheme'],
      ssl_key: node['nginx']['ssl_key'],
      ssl_cert: node['nginx']['ssl_cert'],
      ssl_protocols: node['nginx']['ssl_protocols'],
      ssl_cipher_list: node['nginx']['ssl_cipher_list']
    )
  end
  
end

