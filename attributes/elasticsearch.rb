# override the default ones from the elasticsearch cookbook

default['elasticsearch']['version'] = '1.4.4'
default['elasticsearch']['rpm_url'] = 'https://download.elasticsearch.org/elasticsearch/elasticsearch/elasticsearch-1.4.4.noarch.rpm'
default['elasticsearch']['rpm_sha'] = 'a4b31e6129f4c60bfe0998ede887d0c51a6ab403'

default['elasticsearch']['filename']      = "elasticsearch-#{node['elasticsearch']['version']}.tar.gz"
default['elasticsearch']['download_url']  = [node['elasticsearch']['host'], node['elasticsearch']['repository'], node['elasticsearch']['filename']].join('/')

# give us an elasticsearch cluster with these plugins by default
default['elasticsearch']['plugins'] = {
  'karmi/elasticsearch-paramedic' => {},
  'mobz/elasticsearch-head' => {},
  'jlinn/elasticsearch-cloud-rackspace' => {
    'url' => 'https://github.com/jlinn/elasticsearch-cloud-rackspace/releases/download/v0.4.1/elasticsearch-cloud-rackspace-0.4.1.zip'
  }
}

# restrict elasticsearch to 40% of the box
es_mem = (node['memory']['total'].to_i * 0.4).floor / 1024
default['elasticsearch']['allocated_memory'] = "#{es_mem}m"

# force all traffic to eth1, including published cluster addresses
# (default for rackspace, override for others -- vagrant defaults to localhost)
default['elasticsearch']['network']['host'] = '_eth1:ipv4_'

# rubocop:disable LineLength
default['elasticsearch']['discovery']['search_query'] = "tags:elkstack AND chef_environment:#{node.chef_environment} AND elasticsearch_cluster_name:#{node['elasticsearch']['cluster']['name']} AND NOT name:#{node.name}"
# rubocop:enable LineLength

# by default, won't do multicast
default['elasticsearch']['discovery']['zen']['ping']['multicast']['enabled'] = false

# in order to use kibana, we must enable dynamic scripting
default['elasticsearch']['custom_config']['script.disable_dynamic'] = false

# get on a much newer java, required by ES
default['java']['jdk_version']           = '7' # newer ES requires
