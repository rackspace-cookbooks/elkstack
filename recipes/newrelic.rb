# Encoding: utf-8
#
# Cookbook Name:: elkstack
# Recipe:: newrelic
#
# Copyright 2014, Rackspace
#

unless node['newrelic']['license'].nil?
  node.default['newrelic_meetme_plugin']['license'] = node['newrelic']['license']
  if tagged?('elkstack') || tagged?('elkstack_cluster')
    node.override['newrelic_meetme_plugin']['services'] = {
      'elasticsearch' => {
        'name' => node['elasticsearch']['cluster']['name'],
        'host' => 'eslocal',
        'port' => '9200',
        'scheme' => 'http'
      }
    }
  end

  node.default['newrelic_meetme_plugin']['package_name'] = 'newrelic-plugin-agent'

  user node['newrelic_meetme_plugin']['user']

  include_recipe 'python::package'
  include_recipe 'python::pip'
  python_pip 'setuptools' do
    action :upgrade
    version node['python']['setuptools_version']
  end

  include_recipe 'python'
  include_recipe 'newrelic_meetme_plugin'
end
