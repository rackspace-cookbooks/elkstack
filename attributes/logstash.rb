instance_name = node['elkstack']['config']['logstash']['instance_name']
server = normal['logstash']['instance'][instance_name]
server['bind_host_interface'] = '127.0.0.1'
server['enable_embedded_es'] = false
server['elasticsearch_cluster'] = 'logstash'
server['elasticsearch_ip'] = 'eslocal'
server['elasticsearch_protocol'] = 'node'
server['elasticsearch_port'] = '9200'
server['basedir'] = '/opt/logstash'
server['install_type'] = 'tarball'
server['version'] = '1.4.1'
server['checksum'] = 'd5be171af8d4ca966a0c731fc34f5deeee9d7631319e3660d1df99e43c5f8069'
server['source_url'] = 'https://download.elasticsearch.org/logstash/logstash/logstash-1.4.2.tar.gz'
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
