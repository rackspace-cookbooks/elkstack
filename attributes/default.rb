# give us an elasticsearch cluster with these plugins by default
default['elasticsearch']['plugins'] = {
  'karmi/elasticsearch-paramedic' => {},
  'mobz/elasticsearch-head' => {}
}

# restrict elasticsearch to 40% of the box
es_mem = (node['memory']['total'].to_i * 0.4).floor / 1024
default['elasticsearch']['allocated_memory'] = "#{es_mem}m"

# force all traffic to eth1, including published cluster addresses
# (default for rackspace, override for others -- vagrant defaults to localhost)
default['elasticsearch']['network']['host'] = '_eth1:ipv4_'

# send log lines to localhost only
default['rsyslog']['server_ip'] = '127.0.0.1'
default['rsyslog']['port'] = '5959'

# don't enable the default site
default['kibana']['nginx']['enable_default_site'] = false
default['nginx']['default_site_enabled'] = false

# default to not running the cluster search recipe
default['elkstack']['config']['cluster'] = false

# default to include iptables rules
default['elkstack']['iptables']['enabled'] = 'true'

# rubocop:disable LineLength
default['elasticsearch']['discovery']['search_query'] = "tags:elkstack_cluster AND chef_environment:#{node.chef_environment} AND elasticsearch_cluster_name:#{node['elasticsearch']['cluster']['name']} AND NOT name:#{node.name}"
# rubocop:enable LineLength

default['elasticsearch']['discovery']['zen']['ping']['multicast']['enabled'] = false
