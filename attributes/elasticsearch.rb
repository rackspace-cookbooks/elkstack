# override the default ones from the elasticsearch cookbook
default['elasticsearch']['version']       = '1.3.4'
default['elasticsearch']['rpm_url']       = 'https://download.elasticsearch.org/elasticsearch/elasticsearch/elasticsearch-1.3.4.noarch.rpm'
default['elasticsearch']['rpm_sha']       = 'a84034d07196e58b0471c3fe30289a738715c664'
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
default['elasticsearch']['discovery']['search_query'] = "tags:elkstack_cluster AND chef_environment:#{node.chef_environment} AND elasticsearch_cluster_name:#{node['elasticsearch']['cluster']['name']} AND NOT name:#{node.name}"
# rubocop:enable LineLength

# by default, won't do multicast
default['elasticsearch']['discovery']['zen']['ping']['multicast']['enabled'] = false

# for storing snapshots in cloud files for backup, elasticsearch cookbook requires
# attributes go in ['elasticsearch']['custom_config'] if it doesn't know about them
es_rackspace = default['elasticsearch']['custom_config']
es_rackspace['rackspace.account'] = node['rackspace'] && node['rackspace']['cloud_credentials'] && node['rackspace']['cloud_credentials']['username']
es_rackspace['rackspace.key'] = node['rackspace'] && node['rackspace']['cloud_credentials'] && node['rackspace']['cloud_credentials']['api_key']
es_rackspace['rackspace.enabled'] = es_rackspace['rackspace.account'] && es_rackspace['rackspace.key'] && 'true'

# container: The name of the Cloud Files container to be used. This is mandatory.
es_rackspace['repositories.cloudfiles.container'] = 'elkstack'

# region: The datacenter to be used. Defaults to ORD. Currently, only DFW, ORD, and IAD are supported.
es_rackspace['rackspace.region'] = 'ORD'

# base_path: Specifies the path within the container to store repository data. Defaults to the root of the container.
es_rackspace['rackspace.base_path'] = '/'

# concurrent_streams: Throttles the number of streams per node while performing a snapshot operation. Defaults to 5.
es_rackspace['rackspace.concurrent_streams'] = '5'

# chunk_size: Big files can be broken down into chunks during snapshotting if needed. The chunk size can be specified in bytes or by using size value notation, i.e. 1g, 10m, 5k.
es_rackspace['rackspace.chunk_size'] = '100m'

# compress: When set to true, metadata files are stored in compressed format. This setting doesn't affect index files which are already compressed by default. Defaults to false.
es_rackspace['rackspace.compress'] = false
