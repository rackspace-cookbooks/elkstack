# Encoding: utf-8
#
# Cookbook Name:: elkstack
# Recipe:: newrelic
#
# Copyright 2014, Rackspace
#

include_recipe 'chef-sugar'
newrelic_licence = node.deep_fetch('newrelic', 'license')

if newrelic_licence && !newrelic_licence.nil?
  node.default['newrelic_meetme_plugin']['license'] = node['newrelic']['license']
  if tagged?('elkstack')
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

  include_recipe 'elkstack::_python'
  include_recipe 'newrelic_meetme_plugin'
end
