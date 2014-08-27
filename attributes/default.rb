# give us an elasticsearch cluster with these plugins by default
default['elasticsearch']['plugins'] = {
  'karmi/elasticsearch-paramedic' => {},
  'mobz/elasticsearch-head' => {}
}

# restrict elasticsearch to 40% of the box
es_mem = (node['memory']['total'].to_i * 0.4).floor / 1024
default['elasticsearch']['allocated_memory'] = "#{es_mem}m"

# send log lines to localhost only
default['rsyslog']['server_ip'] = '127.0.0.1'
default['rsyslog']['port'] = '5959'

# don't enable the default site
default['kibana']['nginx']['enable_default_site'] = false
default['nginx']['default_site_enabled'] = false

# Use SSL
default['kibana']['webserver_port'] = 443
default['kibana']['webserver_scheme'] = 'https://'
default['kibana']['ssl_key'] = '/etc/nginx/ssl/kibana.key'
default['kibana']['ssl_cert'] = '/etc/nginx/ssl/kibana.crt'

