server = normal['logstash']['instance']['server']
server['bind_host_interface'] = '127.0.0.1'
server['enable_embedded_es'] = false
server['elasticsearch_cluster'] = 'logstash'
server['elasticsearch_ip'] = '127.0.0.1'
server['elasticsearch_protocol'] = 'http'
server['elasticsearch_port'] = '9200'
server['basedir'] = '/opt/logstash'
server['install_type'] = 'tarball'
server['version'] = '1.4.1'
server['checksum'] = 'a1db8eda3d8bf441430066c384578386601ae308ccabf5d723df33cee27304b4'
server['source_url'] = 'https://download.elasticsearch.org/logstash/logstash/logstash-1.4.1.tar.gz'
server['user'] = 'logstash'
server['group'] = 'logstash'
server['user_opts'] = { homedir: '/var/lib/logstash', uid: nil, gid: nil }
server['logrotate_enable']  = true
server['logrotate_options'] = %w(missingok notifempty compress copytruncate)
server['logrotate_frequency'] = 'daily'
server['logrotate_max_backup'] = 10
server['logrotate_max_size'] = '10M'
server['logrotate_use_filesize'] = false

# restrict logstash to 20% of the box
server['xms'] = "#{(node['memory']['total'].to_i * 0.2).floor / 1024}M"
server['xmx'] = "#{(node['memory']['total'].to_i * 0.2).floor / 1024}M"

server['pattern_templates_cookbook'] = 'logstash'
server['base_config_cookbook'] = 'logstash'
server['config_templates_cookbook'] = 'logstash'

# variables for templates
config_templates_variables = {}
config_templates_variables['elasticsearch_embedded'] = server['enable_embedded_es']
config_templates_variables['elasticsearch_ip'] = server['elasticsearch_ip']
config_templates_variables['elasticsearch_protocol'] = server['elasticsearch_protocol']
server['config_templates_variables'] = config_templates_variables
