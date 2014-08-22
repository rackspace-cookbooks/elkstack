# Encoding: utf-8
#
# Cookbook Name:: elkstack
# Recipe:: logstash
#
# Copyright 2014, Rackspace
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#
include_recipe 'elkstack::_base'

if Chef::Config[:solo]
  Chef::Log.warn('This recipe uses search. Chef Solo does not support search.')
end

# we should move the search somewhere else, or give a toggle so the all-in-one
# recipe named 'single' can share most of the logstash work.
es = search('node', "recipes:elasticsearch\\:\\:default AND chef_environment:#{node.chef_environment}").first

node.set['logstash']['instance']['default']['enable_embedded_es'] = false
node.set['logstash']['instance']['default']['elasticsearch_cluster'] = 'logstash'
node.set['logstash']['instance']['default']['elasticsearch_ip'] = best_ip_for(es)
node.set['logstash']['instance']['default']['bind_host_interface'] = best_ip_for(es)
node.set['logstash']['instance']['default']['elasticsearch_port'] = '9200'

node.set['logstash']['server']['enable_embedded_es'] = false

include_recipe 'logstash'

logstash_instance 'logstash' do
  action :create
end
logstash_service 'logstash' do
  action :enable
end
logstash_config 'logstash' do
  action [:create]
  variables(
    elasticsearch_embedded: false
  )
end
