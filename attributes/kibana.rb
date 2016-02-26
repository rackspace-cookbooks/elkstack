default['kibana']['web_dir'] = '/opt/kibana/current'
default['kibana']['webserver_port'] = 443
default['kibana']['webserver_scheme'] = 'https://'
default['nginx']['disable_http'] = true
default['nginx']['ssl_key'] = '/etc/nginx/ssl/kibana.key'
default['nginx']['ssl_cert'] = '/etc/nginx/ssl/kibana.pem'
default['nginx']['ssl_protocols'] = 'TLSv1.1 TLSv1.2'
default['nginx']['ssl_cipher_list'] = 'EECDH+AESGCM:EDH+AESGCM:AES256+EECDH:AES256+EDH'
default['nginx']['ssl_prefer_server_ciphers'] = 'on'
default['nginx']['use_dhparam'] = true
default['nginx']['ssl_dhparam'] = '/etc/nginx/ssl/dhparam.pem'
default['nginx']['ssl_dhparam_bits'] = 2048

default['kibana']['nginx']['template_cookbook'] = 'elkstack'
default['kibana']['nginx']['template'] = 'kibana-nginx.conf.erb'
default['kibana']['config']['request_timeout'] = 300_000
default['kibana']['config']['shard_timeout'] = 0

host = node['elasticsearch']['http']['host']
default['kibana']['es_server'] = host if host

port = node['elasticsearch']['http']['port']
default['kibana']['es_port'] = port.to_s if port

default['kibana']['server_name'] = node['fqdn']
default['kibana']['server_aliases'] = []
