
default['lumberjack']['ssl certificate'] = 'lumberjack.crt'
default['lumberjack']['ssl key'] = 'lumberjack.key'
default['lumberjack']['ssl ca'] = 'lumberjack.crt'

default['lumberjack']['ssl_dir'] = '/opt/logstash/server'
default['lumberjack']['ssl_key_path'] = "#{node['lumberjack']['ssl_dir']['forwarder']}/#{node['lumberjack']['ssl key']}"
default['lumberjack']['ssl_cert_path'] = "#{node['lumberjack']['ssl_dir']['forwarder']}/#{node['lumberjack']['ssl certificate']}"

# default['lumberjack']['ssl_dir']['forwarder'] = '/etc'
# default['lumberjack']['ssl_key_path']['forwarder'] = "#{node['lumberjack']['ssl_dir']['forwarder']}/#{node['lumberjack']['ssl key']}"
# default['lumberjack']['ssl_cert_path']['forwarder'] = "#{node['lumberjack']['ssl_dir']['forwarder']}/#{node['lumberjack']['ssl certificate']}"

# default['lumberjack']['ssl_dir']['agent'] = '/opt/logstash/server'
# default['lumberjack']['ssl_key_path']['agent'] = "#{node['lumberjack']['ssl_dir']['agent']}/#{node['lumberjack']['ssl key']}"
# default['lumberjack']['ssl_cert_path']['agent'] = "#{node['lumberjack']['ssl_dir']['agent']}/#{node['lumberjack']['ssl certificate']}"
