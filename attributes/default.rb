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

default['kibana']['nginx']['template'] = 'config/kibana-nginx.conf.erb'
default['kibana']['web_dir'] = '/opt/kibana/current'

# Use SSL
default['kibana']['webserver_port'] = 443
default['kibana']['webserver_scheme'] = 'https://'
default['nginx']['ssl_key'] = '/etc/nginx/ssl/kibana.key'
default['nginx']['ssl_cert'] = '/etc/nginx/ssl/kibana.pem'
default['nginx']['ssl_protocols'] = 'SSLv3 TLSv1 TLSv1.1 TLSv1.2'
default['nginx']['ssl_cipher_list'] = 'ECDH+AESGCM:DH+AESGCM:ECDH+AES256:DH+AES256:ECDH+AES128:DH+AES:ECDH+3DES:DH+3DES:RSA+AESGCM:RSA+AES:RSA+3DES:!aNULL:!MD5:!DSS'
