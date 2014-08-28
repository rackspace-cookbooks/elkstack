# give us an elasticsearch cluster with these plugins by default
default['elasticsearch']['plugins'] = {
  'karmi/elasticsearch-paramedic' => {},
  'mobz/elasticsearch-head' => {}
}

# restrict elasticsearch to 40% of the box, bind to localhost by default
es_mem = (node['memory']['total'].to_i * 0.4).floor / 1024
default['elasticsearch']['allocated_memory'] = "#{es_mem}m"
default['elasticsearch']['network']['host'] = '127.0.0.1'

# send log lines to localhost only
default['rsyslog']['server_ip'] = '127.0.0.1'
default['rsyslog']['port'] = '5959'

# don't enable the default site
default['kibana']['nginx']['enable_default_site'] = false
default['nginx']['default_site_enabled'] = false

# default to not running the cluster search recipe
default['elkstack']['config']['cluster'] = false

default['elasticsearch']['discovery']['search_query'] = "tags:elkstack_cluster
  AND chef_environment:#{node.chef_environment}
  AND elasticsearch_cluster_name:#{node['elasticsearch']['cluster']['name']}
  AND NOT name:#{node.name}"

default['elasticsearch']['discovery']['zen']['ping']['multicast']['enabled'] = false
