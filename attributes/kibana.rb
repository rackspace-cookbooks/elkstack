default['kibana']['web_dir'] = '/opt/kibana/current'
default['kibana']['webserver_port'] = 443
default['kibana']['webserver_scheme'] = 'https://'
default['nginx']['ssl_key'] = '/etc/nginx/ssl/kibana.key'
default['nginx']['ssl_cert'] = '/etc/nginx/ssl/kibana.pem'
default['nginx']['ssl_protocols'] = 'SSLv3 TLSv1 TLSv1.1 TLSv1.2'
default['nginx']['ssl_cipher_list'] = 'ECDH+AESGCM:DH+AESGCM:ECDH+AES256:DH+AES256:ECDH+AES128:DH+AES:ECDH+3DES:DH+3DES:RSA+AESGCM:RSA+AES:RSA+3DES:!aNULL:!MD5:!DSS'
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
